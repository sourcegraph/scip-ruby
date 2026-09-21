#include "doctest/doctest.h"
// has to go first as it violates our requirements
#include "ast/ast.h"
#include "ast/desugar/Desugar.h"
#include "common/common.h"
#include "core/Error.h"
#include "core/ErrorQueue.h"
#include "core/Names.h"
#include "core/Unfreeze.h"
#include "infer/infer.h"
#include "local_vars/local_vars.h"
#include "namer/namer.h"
#include "resolver/resolver.h"
#include "rewriter/rewriter.h"
#include "spdlog/spdlog.h"
// has to come before the next one. This comment stops formatter from reordering them
#include "spdlog/sinks/stdout_color_sinks.h"
#include <fstream>
#include <memory>

using namespace std;

namespace sorbet::infer::test {

auto logger = spdlog::stderr_color_mt("infer_test");
auto errorQueue = make_shared<sorbet::core::ErrorQueue>(*logger, *logger);

void processSource(core::GlobalState &cb, string str) {
    sorbet::core::UnfreezeNameTable nt(cb);
    sorbet::core::UnfreezeSymbolTable st(cb);
    sorbet::core::UnfreezeFileTable ft(cb);
    core::FileRef fileId = cb.enterFile("<test>", str);
    auto settings = parser::Parser::Settings{};
    auto ast = parser::Parser::run(cb, fileId, settings).tree;
    sorbet::core::MutableContext ctx(cb, core::Symbols::root(), fileId);
    auto tree = ast::ParsedFile{ast::desugar::node2Tree(ctx, move(ast)), fileId};
    tree.tree = rewriter::Rewriter::run(ctx, move(tree.tree));
    tree = local_vars::LocalVars::run(ctx, move(tree));
    vector<ast::ParsedFile> trees;
    trees.emplace_back(move(tree));
    auto workers = WorkerPool::create(0, *logger);
    core::FoundDefHashesResult foundHashes; // compute this just for test coverage
    auto cancelled = namer::Namer::run(cb, absl::Span<ast::ParsedFile>(trees), *workers, &foundHashes);
    ENFORCE(!cancelled);
    auto resolved = resolver::Resolver::run(cb, move(trees), *workers);
}

TEST_CASE("Infer") {
    core::GlobalState gs(errorQueue);
    gs.initEmpty();

    SUBCASE("LiteralsSubtyping") {
        auto intLit = core::make_type<core::IntegerLiteralType>(int64_t(1));
        auto intClass = core::make_type<core::ClassType>(core::Symbols::Integer());
        auto floatLit = core::make_type<core::FloatLiteralType>(1.0f);
        auto floatClass = core::make_type<core::ClassType>(core::Symbols::Float());
        auto trueLit = core::Types::trueClass();
        auto trueClass = core::make_type<core::ClassType>(core::Symbols::TrueClass());
        auto stringLit = core::make_type<core::NamedLiteralType>(core::Symbols::String(), core::Names::assignTemp());
        auto stringClass = core::make_type<core::ClassType>(core::Symbols::String());
        REQUIRE(core::Types::isSubType(gs, intLit, intClass));
        REQUIRE(core::Types::isSubType(gs, floatLit, floatClass));
        REQUIRE(core::Types::isSubType(gs, trueLit, trueClass));
        REQUIRE(core::Types::isSubType(gs, stringLit, stringClass));

        REQUIRE(core::Types::isSubType(gs, intLit, intLit));
        REQUIRE(core::Types::isSubType(gs, floatLit, floatLit));
        REQUIRE(core::Types::isSubType(gs, trueLit, trueLit));
        REQUIRE(core::Types::isSubType(gs, stringLit, stringLit));

        REQUIRE_FALSE(core::Types::isSubType(gs, intClass, intLit));
        REQUIRE(core::Types::isSubType(gs, core::Types::top(), core::Types::untypedUntracked()));
        REQUIRE(core::Types::isSubType(gs, core::Types::untypedUntracked(), core::Types::top()));
    }

    SUBCASE("LiteralAggregateLubs") {
        core::UnfreezeNameTable names(gs);
        auto label = core::make_type<core::NamedLiteralType>(core::Symbols::String(), gs.enterNameUTF8("label"));
        auto text = core::make_type<core::NamedLiteralType>(core::Symbols::String(), gs.enterNameUTF8("toy"));
        auto symbol = core::make_type<core::NamedLiteralType>(core::Symbols::Symbol(), gs.enterNameUTF8("sample"));
        auto shape = core::make_type<core::ShapeType>(vector<core::TypePtr>{label}, vector<core::TypePtr>{text});
        auto tuple = core::make_type<core::TupleType>(vector<core::TypePtr>{core::Types::Integer(), text});
        vector<core::TypePtr> literals{core::make_type<core::IntegerLiteralType>(int64_t(7)),
                                       core::make_type<core::FloatLiteralType>(0.5), text, symbol};

        for (auto scipMode : {false, true}) {
            gs.isSCIPRuby = scipMode;
            CAPTURE(scipMode);
            for (auto &literal : literals) {
                CAPTURE(literal.toString(gs));
                for (auto &aggregate : {shape, tuple}) {
                    CAPTURE(aggregate.toString(gs));
                    // SCIP joins must agree with joining the widened literal while keeping the aggregate.
                    // Outside SCIP mode, preserve the existing widening of both proxy types.
                    auto expected =
                        core::Types::any(gs, literal.underlying(gs), scipMode ? aggregate : aggregate.underlying(gs));
                    auto joined = core::Types::any(gs, literal, aggregate);
                    auto reversed = core::Types::any(gs, aggregate, literal);
                    CHECK(core::Types::equiv(gs, joined, expected));
                    CHECK(core::Types::equiv(gs, reversed, expected));
                    CHECK(core::Types::isSubType(gs, literal, joined));
                    CHECK(core::Types::isSubType(gs, aggregate, joined));
                }
            }
        }
    }

    SUBCASE("SCIPNilableTupleLub") {
        gs.isSCIPRuby = true;
        core::UnfreezeNameTable names(gs);
        core::UnfreezeSymbolTable symbols(gs);
        // initEmpty does not load Array's generic parameter from the RBI payload.
        auto elem = gs.enterTypeMember(core::Loc::none(), core::Symbols::Array(), gs.enterNameConstant("Elem"),
                                       core::Variance::CoVariant);
        elem.data(gs)->resultType = core::make_type<core::LambdaParam>(elem, core::Types::bottom(), core::Types::top());

        auto label = core::make_type<core::NamedLiteralType>(core::Symbols::String(), gs.enterNameUTF8("label"));
        auto text = core::make_type<core::NamedLiteralType>(core::Symbols::String(), gs.enterNameUTF8("toy"));
        auto shape = core::make_type<core::ShapeType>(vector<core::TypePtr>{label}, vector<core::TypePtr>{text});
        auto precise = core::make_type<core::TupleType>(
            vector<core::TypePtr>{core::make_type<core::IntegerLiteralType>(int64_t(7)), shape, text});
        auto general = core::make_type<core::TupleType>(
            vector<core::TypePtr>{core::Types::Integer(), shape, core::Types::String()});

        REQUIRE(core::Types::isSubType(gs, precise, general));
        CHECK(core::Types::isSubType(gs, precise, general.underlying(gs)));
        auto nilable = core::Types::any(gs, core::Types::nilClass(), precise);
        auto joined = core::Types::any(gs, nilable, general);
        CHECK(core::Types::isSubType(gs, nilable, joined));
        CHECK(core::Types::isSubType(gs, general, joined));
        CHECK(core::Types::equiv(gs, joined, core::Types::any(gs, general, nilable)));
    }

    SUBCASE("ShapeUnionLubs") {
        core::UnfreezeNameTable names(gs);
        auto label = core::make_type<core::NamedLiteralType>(core::Symbols::Symbol(), gs.enterNameUTF8("label"));
        auto text = core::make_type<core::NamedLiteralType>(core::Symbols::String(), gs.enterNameUTF8("sample"));
        auto shape = core::make_type<core::ShapeType>(vector<core::TypePtr>{label},
                                                      vector<core::TypePtr>{core::Types::String()});
        auto narrowShape = core::make_type<core::ShapeType>(vector<core::TypePtr>{label}, vector<core::TypePtr>{text});
        auto common = core::Types::any(gs, core::Types::Integer(), core::Types::Symbol());
        auto overlapping = core::Types::any(gs, core::Types::Integer(), narrowShape);

        for (auto scipMode : {false, true}) {
            gs.isSCIPRuby = scipMode;
            CAPTURE(scipMode);
            auto shapeInUnion = scipMode ? shape : shape.underlying(gs);
            for (auto &other : {common, overlapping}) {
                CAPTURE(other.toString(gs));
                auto expected = core::Types::any(gs, core::Types::Integer(), shapeInUnion);
                if (other == common) {
                    expected = core::Types::any(gs, expected, core::Types::Symbol());
                }
                auto joined = core::Types::any(gs, other, shape);
                CHECK(core::Types::equiv(gs, joined, expected));
                CHECK(core::Types::equiv(gs, core::Types::any(gs, shape, other), expected));
                CHECK(core::Types::isSubType(gs, other, joined));
                CHECK(core::Types::isSubType(gs, shape, joined));
            }
        }
    }

    SUBCASE("SCIPShapeUnionGlb") {
        gs.isSCIPRuby = true;
        core::UnfreezeNameTable names(gs);
        core::UnfreezeSymbolTable symbols(gs);
        // initEmpty does not load Hash's generic parameters from the RBI payload.
        for (auto name : {"K", "V", "Elem"}) {
            auto member = gs.enterTypeMember(core::Loc::none(), core::Symbols::Hash(), gs.enterNameConstant(name),
                                             core::Variance::CoVariant);
            member.data(gs)->resultType =
                core::make_type<core::LambdaParam>(member, core::Types::bottom(), core::Types::top());
        }
        auto label = core::make_type<core::NamedLiteralType>(core::Symbols::Symbol(), gs.enterNameUTF8("label"));
        auto shape = core::make_type<core::ShapeType>(vector<core::TypePtr>{label},
                                                      vector<core::TypePtr>{core::Types::String()});
        auto common = core::Types::any(gs, core::Types::Integer(), core::Types::Symbol());
        auto precise = core::Types::any(gs, core::Types::any(gs, core::Types::Integer(), shape), core::Types::Symbol());
        auto general = core::Types::any(gs, common, core::Types::hashOf(gs, core::Types::String()));

        auto intersection = core::Types::all(gs, general, precise);
        CHECK(core::Types::equiv(gs, intersection, precise));
        CHECK(core::Types::isSubType(gs, intersection, precise));
        CHECK(core::Types::isSubType(gs, intersection, general));
        CHECK(core::Types::equiv(gs, intersection, core::Types::all(gs, precise, general)));
    }

    SUBCASE("NestedUnionIntersections") {
        processSource(gs, "module Labeled; end; module Tagged; end; class Spare; end");
        const auto &root = core::Symbols::root().data(gs);
        auto labeled = core::make_type<core::ClassType>(
            root->findMember(gs, gs.enterNameConstant("Labeled")).asClassOrModuleRef());
        auto tagged =
            core::make_type<core::ClassType>(root->findMember(gs, gs.enterNameConstant("Tagged")).asClassOrModuleRef());
        auto spare =
            core::make_type<core::ClassType>(root->findMember(gs, gs.enterNameConstant("Spare")).asClassOrModuleRef());
        auto common = core::Types::any(gs, labeled, tagged);
        vector<core::TypePtr> nestedUnions{core::Types::any(gs, core::Types::any(gs, labeled, spare), tagged),
                                           core::Types::any(gs, labeled, core::Types::any(gs, tagged, spare))};

        for (auto scipMode : {false, true}) {
            gs.isSCIPRuby = scipMode;
            CAPTURE(scipMode);
            for (auto &nested : nestedUnions) {
                CAPTURE(nested.toString(gs));
                auto narrowed = core::Types::all(gs, core::Types::nilClass(), nested);
                if (!scipMode) {
                    // Preserve the original intersection representation outside SCIP mode.
                    REQUIRE(core::isa_type<core::AndType>(narrowed));
                    CHECK(core::cast_type_nonnull<core::AndType>(narrowed).right == nested);
                    continue;
                }
                auto expected = core::Types::any(gs, core::Types::all(gs, core::Types::nilClass(), labeled),
                                                 core::Types::all(gs, core::Types::nilClass(), tagged));
                CHECK_FALSE(narrowed.isBottom());
                CHECK(core::Types::equiv(gs, narrowed, expected));
                CHECK(core::Types::equiv(gs, narrowed, core::Types::all(gs, nested, core::Types::nilClass())));
                CHECK(core::Types::isSubType(gs, narrowed, core::Types::nilClass()));
                CHECK(core::Types::isSubType(gs, narrowed, nested));
                auto joined = core::Types::any(gs, common, narrowed);
                CHECK(core::Types::equiv(gs, joined, common));
                CHECK(core::Types::isSubType(gs, narrowed, joined));
                CHECK(core::Types::equiv(gs, core::Types::any(gs, narrowed, common), joined));
            }
        }
    }

    SUBCASE("SCIPDistributedIntersectionPreservesAggregates") {
        processSource(gs, "module Tagged; end");
        gs.isSCIPRuby = true;
        core::UnfreezeNameTable names(gs);
        auto tagged = core::make_type<core::ClassType>(
            core::Symbols::root().data(gs)->findMember(gs, gs.enterNameConstant("Tagged")).asClassOrModuleRef());
        auto label = core::make_type<core::NamedLiteralType>(core::Symbols::Symbol(), gs.enterNameUTF8("label"));
        auto shape = core::make_type<core::ShapeType>(vector<core::TypePtr>{label},
                                                      vector<core::TypePtr>{core::Types::String()});
        auto tuple = core::make_type<core::TupleType>(vector<core::TypePtr>{core::Types::String()});
        for (auto &aggregate : {shape, tuple}) {
            CAPTURE(aggregate.toString(gs));
            auto container =
                core::make_type<core::ClassType>(aggregate == shape ? core::Symbols::Hash() : core::Symbols::Array());
            auto source = core::Types::any(gs, aggregate, tagged);
            auto narrowed = core::Types::all(gs, container, source);
            CHECK(core::Types::isSubType(gs, aggregate, narrowed));
            CHECK(core::Types::isSubType(gs, core::Types::all(gs, container, tagged), narrowed));
            CHECK(core::Types::isSubType(gs, narrowed, source));
            CHECK(core::Types::isSubType(gs, narrowed, container));
            CHECK_FALSE(core::Types::isSubType(gs, container, narrowed));
        }
    }

    SUBCASE("SCIPUnionIntersectionPreservesAggregates") {
        gs.isSCIPRuby = true;
        core::UnfreezeNameTable names(gs);
        core::UnfreezeSymbolTable symbols(gs);
        // initEmpty does not load generic parameters from the RBI payload.
        for (auto klass : {core::Symbols::Hash(), core::Symbols::Array()}) {
            for (auto name : {"K", "V", "Elem"}) {
                if (klass == core::Symbols::Array() && string_view(name) != "Elem") {
                    continue;
                }
                auto member =
                    gs.enterTypeMember(core::Loc::none(), klass, gs.enterNameConstant(name), core::Variance::CoVariant);
                member.data(gs)->resultType =
                    core::make_type<core::LambdaParam>(member, core::Types::bottom(), core::Types::top());
            }
        }
        auto label = core::make_type<core::NamedLiteralType>(core::Symbols::Symbol(), gs.enterNameUTF8("label"));
        auto count = core::make_type<core::NamedLiteralType>(core::Symbols::Symbol(), gs.enterNameUTF8("count"));
        auto shape1 = core::make_type<core::ShapeType>(vector<core::TypePtr>{label},
                                                       vector<core::TypePtr>{core::Types::String()});
        auto shape2 = core::make_type<core::ShapeType>(vector<core::TypePtr>{count},
                                                       vector<core::TypePtr>{core::Types::Integer()});
        auto nestedShape = core::make_type<core::ShapeType>(vector<core::TypePtr>{label, count},
                                                            vector<core::TypePtr>{core::Types::String(), shape2});
        auto tuple1 = core::make_type<core::TupleType>(vector<core::TypePtr>{core::Types::String()});
        auto tuple2 =
            core::make_type<core::TupleType>(vector<core::TypePtr>{core::Types::String(), core::Types::Integer()});

        for (auto &aggregates : {pair{shape1, shape2}, pair{shape1, nestedShape}}) {
            auto &[first, second] = aggregates;
            auto container = core::Types::hashOfUntyped();
            auto nil = core::Types::nilClass();
            // Adding a shape to a nilable shape preserves both branches, unlike directly lubbing two shapes.
            for (auto &nilable : {core::Types::any(gs, core::Types::any(gs, nil, first), second),
                                  core::Types::any(gs, core::Types::any(gs, nil, second), first)}) {
                for (auto &precise : {nilable, core::Types::dropNil(gs, nilable)}) {
                    CAPTURE(precise.toString(gs));
                    for (auto &general : {core::Types::any(gs, nil, container), core::Types::any(gs, container, nil)}) {
                        auto intersection = core::Types::all(gs, precise, general);
                        auto reversed = core::Types::all(gs, general, precise);
                        CHECK(core::Types::isSubType(gs, intersection, precise));
                        CHECK(core::Types::isSubType(gs, intersection, general));
                        CHECK(core::Types::equiv(gs, intersection, precise));
                        CHECK(core::Types::equiv(gs, reversed, precise));
                        CHECK_FALSE(core::Types::isSubType(gs, container, intersection));
                    }
                }
            }
        }

        // Existing nilable tuple intersections should still collapse in both SCIP and ordinary Sorbet modes.
        auto array = core::Types::arrayOfUntyped(core::Symbols::Array());
        auto nilableArray = core::Types::any(gs, core::Types::nilClass(), array);
        for (auto scipMode : {false, true}) {
            gs.isSCIPRuby = scipMode;
            CAPTURE(scipMode);
            for (auto &tuple : {tuple1, tuple2}) {
                auto nilableTuple = core::Types::any(gs, core::Types::nilClass(), tuple);
                auto intersection = core::Types::all(gs, nilableTuple, nilableArray);
                CHECK(core::Types::equiv(gs, intersection, nilableTuple));
                CHECK(core::Types::equiv(gs, core::Types::all(gs, nilableArray, nilableTuple), nilableTuple));
            }
        }
    }

    SUBCASE("ClassesSubtyping") {
        processSource(gs, "class Bar; end; class Foo < Bar; end");
        const auto &rootScope = core::Symbols::root().data(gs);

        auto barSymbol = rootScope->findMember(gs, gs.enterNameConstant("Bar"));
        auto fooSymbol = rootScope->findMember(gs, gs.enterNameConstant("Foo"));
        REQUIRE_EQ("<C <U Bar>>", barSymbol.name(gs).showRaw(gs));
        REQUIRE_EQ("<C <U Foo>>", fooSymbol.name(gs).showRaw(gs));

        auto barType = core::make_type<core::ClassType>(barSymbol.asClassOrModuleRef());
        auto fooType = core::make_type<core::ClassType>(fooSymbol.asClassOrModuleRef());

        REQUIRE(core::Types::isSubType(gs, fooType, barType));
        REQUIRE(core::Types::isSubType(gs, fooType, fooType));
        REQUIRE(core::Types::isSubType(gs, barType, barType));
        REQUIRE_FALSE(core::Types::isSubType(gs, barType, fooType));
    }

    SUBCASE("ClassesLubs") {
        processSource(gs, "class Bar; end; class Foo1 < Bar; end; class Foo2 < Bar;  end");
        const auto &rootScope = core::Symbols::root().data(gs);

        auto barSymbol = rootScope->findMember(gs, gs.enterNameConstant("Bar"));
        auto foo1Symbol = rootScope->findMember(gs, gs.enterNameConstant("Foo1"));
        auto foo2Symbol = rootScope->findMember(gs, gs.enterNameConstant("Foo2"));
        REQUIRE_EQ("<C <U Bar>>", barSymbol.name(gs).showRaw(gs));
        REQUIRE_EQ("<C <U Foo1>>", foo1Symbol.name(gs).showRaw(gs));
        REQUIRE_EQ("<C <U Foo2>>", foo2Symbol.name(gs).showRaw(gs));

        auto barType = core::make_type<core::ClassType>(barSymbol.asClassOrModuleRef());
        auto foo1Type = core::make_type<core::ClassType>(foo1Symbol.asClassOrModuleRef());
        auto foo2Type = core::make_type<core::ClassType>(foo2Symbol.asClassOrModuleRef());

        auto barNfoo1 = core::Types::any(gs, barType, foo1Type);
        auto foo1Nbar = core::Types::any(gs, foo1Type, barType);
        auto barNfoo2 = core::Types::any(gs, barType, foo2Type);
        auto foo2Nbar = core::Types::any(gs, foo2Type, barType);
        auto foo1Nfoo2 = core::Types::any(gs, foo1Type, foo2Type);
        auto foo2Nfoo1 = core::Types::any(gs, foo2Type, foo1Type);

        REQUIRE_EQ("ClassType", barNfoo1.typeName());
        REQUIRE(core::Types::isSubType(gs, barType, barNfoo1));
        REQUIRE(core::Types::isSubType(gs, foo1Type, barNfoo1));
        REQUIRE_EQ("ClassType", barNfoo2.typeName());
        REQUIRE(core::Types::isSubType(gs, barType, barNfoo2));
        REQUIRE(core::Types::isSubType(gs, foo2Type, barNfoo2));
        REQUIRE_EQ("ClassType", foo1Nbar.typeName());
        REQUIRE(core::Types::isSubType(gs, barType, foo1Nbar));
        REQUIRE(core::Types::isSubType(gs, foo1Type, foo1Nbar));
        REQUIRE_EQ("ClassType", foo2Nbar.typeName());
        REQUIRE(core::Types::isSubType(gs, barType, foo2Nbar));
        REQUIRE(core::Types::isSubType(gs, foo2Type, foo2Nbar));

        REQUIRE(core::Types::equiv(gs, barNfoo2, foo2Nbar));
        REQUIRE(core::Types::equiv(gs, barNfoo1, foo1Nbar));
        REQUIRE(core::Types::equiv(gs, foo1Nfoo2, foo2Nfoo1));

        auto intType = core::make_type<core::ClassType>(core::Symbols::Integer());
        auto intNfoo1 = core::Types::any(gs, foo1Type, intType);
        auto intNbar = core::Types::any(gs, barType, intType);
        auto intNfoo1Nbar = core::Types::any(gs, intNfoo1, barType);
        REQUIRE(core::Types::equiv(gs, intNfoo1Nbar, intNbar));
        auto intNfoo1Nfoo2 = core::Types::any(gs, intNfoo1, foo2Type);
        auto intNfoo1Nfoo2Nbar = core::Types::any(gs, intNfoo1Nfoo2, barType);
        REQUIRE(core::Types::equiv(gs, intNfoo1Nfoo2Nbar, intNbar));
    }

    SUBCASE("ClassesGlbs") {
        processSource(gs, "class Bar; end; class Foo1 < Bar; end; class Foo2 < Bar;  end");
        const auto &rootScope = core::Symbols::root().data(gs);

        auto barSymbol = rootScope->findMember(gs, gs.enterNameConstant("Bar"));
        auto foo1Symbol = rootScope->findMember(gs, gs.enterNameConstant("Foo1"));
        auto foo2Symbol = rootScope->findMember(gs, gs.enterNameConstant("Foo2"));
        REQUIRE_EQ("<C <U Bar>>", barSymbol.name(gs).showRaw(gs));
        REQUIRE_EQ("<C <U Foo1>>", foo1Symbol.name(gs).showRaw(gs));
        REQUIRE_EQ("<C <U Foo2>>", foo2Symbol.name(gs).showRaw(gs));

        auto barType = core::make_type<core::ClassType>(barSymbol.asClassOrModuleRef());
        auto foo1Type = core::make_type<core::ClassType>(foo1Symbol.asClassOrModuleRef());
        auto foo2Type = core::make_type<core::ClassType>(foo2Symbol.asClassOrModuleRef());

        auto barOrfoo1 = core::Types::all(gs, barType, foo1Type);
        auto foo1Orbar = core::Types::all(gs, foo1Type, barType);
        auto barOrfoo2 = core::Types::all(gs, barType, foo2Type);
        auto foo2Orbar = core::Types::all(gs, foo2Type, barType);
        auto foo1Orfoo2 = core::Types::all(gs, foo1Type, foo2Type);
        auto foo2Orfoo1 = core::Types::all(gs, foo2Type, foo1Type);

        REQUIRE_EQ("ClassType", barOrfoo1.typeName());
        REQUIRE(core::Types::isSubType(gs, barOrfoo1, barType));
        REQUIRE(core::Types::isSubType(gs, barOrfoo1, foo1Type));
        REQUIRE_EQ("ClassType", barOrfoo2.typeName());
        REQUIRE(core::Types::isSubType(gs, barOrfoo2, barType));
        REQUIRE(core::Types::isSubType(gs, barOrfoo2, foo2Type));
        REQUIRE_EQ("ClassType", foo1Orbar.typeName());
        REQUIRE(core::Types::isSubType(gs, foo1Orbar, barType));
        REQUIRE(core::Types::isSubType(gs, foo1Orbar, foo1Type));
        REQUIRE_EQ("ClassType", foo2Orbar.typeName());
        REQUIRE(core::Types::isSubType(gs, foo2Orbar, barType));
        REQUIRE(core::Types::isSubType(gs, foo2Orbar, foo2Type));

        REQUIRE(core::Types::equiv(gs, barOrfoo2, foo2Orbar));
        REQUIRE(core::Types::equiv(gs, barOrfoo1, foo1Orbar));
        REQUIRE(core::Types::equiv(gs, foo1Orfoo2, foo2Orfoo1));
    }
}

} // namespace sorbet::infer::test
