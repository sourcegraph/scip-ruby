#include "rewriter/Minitest.h"
#include "ast/Helpers.h"
#include "ast/ast.h"
#include "ast/treemap/treemap.h"
#include "core/Context.h"
#include "core/Names.h"
#include "core/core.h"
#include "core/errors/rewriter.h"
#include "rewriter/rewriter.h"

using namespace std;

namespace sorbet::rewriter {

namespace {

core::LocOffsets testHelperNameLoc(const ast::Send &send) {
    if (send.fun == core::Names::before() || send.fun == core::Names::after() || send.numPosArgs() == 0) {
        return send.funLoc;
    }
    return send.getPosArg(0).loc();
}

class ConstantMover {
    uint32_t classDepth = 0;
    vector<ast::ExpressionPtr> movedConstants = {};

    ast::ExpressionPtr createConstAssign(ast::Assign &asgn) {
        auto loc = asgn.loc;
        auto raiseUnimplemented = ast::MK::RaiseUnimplemented(loc);
        if (auto cast = ast::cast_tree<ast::Cast>(asgn.rhs)) {
            if (cast->cast == core::Names::let()) {
                auto rhs = ast::MK::Let(loc, move(raiseUnimplemented), cast->typeExpr.deepCopy());
                return ast::MK::Assign(asgn.loc, move(asgn.lhs), move(rhs));
            }
        }

        return ast::MK::Assign(asgn.loc, move(asgn.lhs), move(raiseUnimplemented));
    }

public:
    void postTransformAssign(core::MutableContext ctx, ast::ExpressionPtr &tree) {
        if (classDepth != 0) {
            // These will be moved when we move the whole enclosing class def
            return;
        }

        auto asgn = ast::cast_tree<ast::Assign>(tree);
        if (auto cnst = ast::cast_tree<ast::UnresolvedConstantLit>(asgn->lhs)) {
            if (ast::isa_tree<ast::UnresolvedConstantLit>(asgn->rhs)) {
                movedConstants.emplace_back(move(tree));
                tree = ast::MK::EmptyTree();
                return;
            }
            auto name = ast::MK::Symbol(cnst->loc, cnst->cnst);

            // if the constant is already in a T.let, preserve it, otherwise decay it to unsafe
            movedConstants.emplace_back(createConstAssign(*asgn));

            auto module = ast::MK::Constant(asgn->loc, core::Symbols::Module());
            tree = ast::MK::Send2(asgn->loc, move(module), core::Names::constSet(), asgn->loc.copyWithZeroLength(),
                                  move(name), move(asgn->rhs));
            return;
        }
    }

    // classdefs define new constants, so we always move those if they're the "top-level" classdef (i.e. if we have
    // nested classdefs, we should only move the outermost one)
    void preTransformClassDef(core::MutableContext ctx, ast::ExpressionPtr &classDef) {
        classDepth++;
    }

    void postTransformClassDef(core::MutableContext ctx, ast::ExpressionPtr &classDef) {
        classDepth--;
        if (classDepth == 0) {
            movedConstants.emplace_back(move(classDef));
            classDef = ast::MK::EmptyTree();
        }
    }

    vector<ast::ExpressionPtr> getMovedConstants() {
        return move(movedConstants);
    }

    ast::ExpressionPtr addConstantsToExpression(core::LocOffsets loc, ast::ExpressionPtr expr) {
        auto consts = getMovedConstants();

        if (consts.empty()) {
            return expr;
        } else {
            ast::InsSeq::STATS_store stats;

            for (auto &m : consts) {
                stats.emplace_back(move(m));
            }

            return ast::MK::InsSeq(loc, std::move(stats), move(expr));
        }
    }
};

// Transforms is_expected calls to expect(subject.attribute) for RSpec's `its` DSL
class IsExpectedTransformer {
private:
    core::NameRef attributeName;

public:
    IsExpectedTransformer(core::NameRef attributeName) : attributeName(attributeName) {}

    ast::ExpressionPtr postTransformSend(core::Context ctx, ast::ExpressionPtr tree) {
        auto &send = ast::cast_tree_nonnull<ast::Send>(tree);

        // Look for is_expected calls
        if (send.fun == core::Names::isExpected() && send.recv.isSelfReference()) {
            // Replace is_expected with expect(subject.attribute)
            auto subjectCall = ast::MK::Send0(send.loc, ast::MK::Self(send.loc), core::Names::subject(),
                                              send.loc.copyWithZeroLength());
            auto attributeCall =
                ast::MK::Send0(send.loc, std::move(subjectCall), attributeName, send.loc.copyWithZeroLength());
            return ast::MK::Send1(send.loc, ast::MK::Self(send.loc), core::Names::expect(),
                                  send.loc.copyWithZeroLength(), std::move(attributeCall));
        }

        return tree;
    }
};

ast::ExpressionPtr addSigVoid(core::Context ctx, ast::ExpressionPtr expr) {
    if (ctx.file.data(ctx).strictLevel < core::StrictLevel::Strict) {
        // Only add a dummy sig if it would be required (because the file is `# typed: strict`).
        // This is to save memory (and possibly also typechecking runtime).
        //
        // Another alternative if this approach becomes problematic would be to set some sort of
        // flag on MethodDef that says to suppress the "missing sig" error, or to implicitly assume
        // a sig of `sig { void }` or something.
        //
        // For example, in a world where all tests are `# typed: strict`, this approach saves no memory.
        return expr;
    }

    core::LocOffsets declLoc;
    if (auto mdef = ast::cast_tree<ast::MethodDef>(expr)) {
        declLoc = mdef->declLoc;
    } else {
        ENFORCE(false, "Added a sig to something that wasn't a method def");
        declLoc = expr.loc();
    }
    return ast::MK::InsSeq1(expr.loc(), ast::MK::SigVoid(declLoc, {}), std::move(expr));
}

core::LocOffsets declLocForSendWithBlock(const ast::Send &send) {
    return send.loc.copyWithZeroLength().join(send.block()->loc.copyWithZeroLength());
}

// Namer only looks at ancestors at the ClassDef top-level. If a `describe` block has ancestor items
// at the top level inside the InsSeq of the Block body, that should count as a an ancestor in namer.
// But if we just plop the whole InsSeq as a single element inside the the ClassDef rhs, they won't
// be at the top level anymore.
void flattenStatements(ast::ClassDef::RHS_store &rhs, ast::ExpressionPtr body) {
    if (auto seq = ast::cast_tree<ast::InsSeq>(body)) {
        for (auto &stat : seq->stats) {
            flattenStatements(rhs, std::move(stat));
        }
        flattenStatements(rhs, std::move(seq->expr));
    } else {
        rhs.emplace_back(std::move(body));
    }
}

ast::ClassDef::RHS_store flattenDescribeBody(core::Context ctx, ast::ExpressionPtr body) {
    ast::ClassDef::RHS_store rhs;
    if (ctx.state.isSCIPRuby) {
        // Preserved DSL calls wrap rewritten include_context/include_examples
        // in another InsSeq. Keep their includes visible to namer as ancestors.
        flattenStatements(rhs, std::move(body));
        return rhs;
    }
    if (auto bodySeq = ast::cast_tree<ast::InsSeq>(body)) {
        absl::c_move(bodySeq->stats, back_inserter(rhs));
        rhs.emplace_back(move(bodySeq->expr));
    } else {
        rhs.emplace_back(move(body));
    }

    return rhs;
}

// Returns true if `classBody` already contains a `described_class` method definition (whether
// explicit `def described_class` or rewritten from `let(:described_class)` / `subject(:described_class)`).
// The one-level `InsSeq` descent mirrors the output shape of `ConstantMover::addConstantsToExpression`,
// which wraps a rewritten `let`/`subject` method def in an `InsSeq` when constants are hoisted.
bool hasUserDefinedDescribedClass(const ast::ClassDef::RHS_store &classBody) {
    auto isDescribedClassMethod = [](const ast::ExpressionPtr &stmt) {
        auto methodDef = ast::cast_tree<ast::MethodDef>(stmt);
        return methodDef && methodDef->name == core::Names::describedClass();
    };
    for (const auto &stmt : classBody) {
        if (isDescribedClassMethod(stmt)) {
            return true;
        }
        if (auto insSeq = ast::cast_tree<ast::InsSeq>(stmt)) {
            for (const auto &nested : insSeq->stats) {
                if (isDescribedClassMethod(nested)) {
                    return true;
                }
            }
            if (isDescribedClassMethod(insSeq->expr)) {
                return true;
            }
        }
    }
    return false;
}

string to_s(core::Context ctx, const ast::ExpressionPtr &arg) {
    auto argLit = ast::cast_tree<ast::Literal>(arg);
    if (argLit != nullptr && argLit->isName()) {
        return argLit->asName().show(ctx);
    }
    auto argConstant = ast::cast_tree<ast::UnresolvedConstantLit>(arg);
    if (argConstant != nullptr) {
        return string(ctx.locAt(argConstant->loc).source(ctx).value_or("<unknown>"));
    }
    return arg.toString(ctx);
}

// This returns `true` for expressions which can be moved from class to method scope without changing their meaning, and
// `false` otherwise. This mostly encompasses literals (arrays, hashes, basic literals), constants, and sends that only
// involve the other things described.
bool canMoveIntoMethodDef(const ast::ExpressionPtr &exp) {
    if (ast::isa_tree<ast::Literal>(exp)) {
        return true;
    } else if (auto list = ast::cast_tree<ast::Array>(exp)) {
        return absl::c_all_of(list->elems, [](auto &elem) { return canMoveIntoMethodDef(elem); });
    } else if (auto hash = ast::cast_tree<ast::Hash>(exp)) {
        return absl::c_all_of(hash->keys, [](auto &elem) { return canMoveIntoMethodDef(elem); }) &&
               absl::c_all_of(hash->values, [](auto &elem) { return canMoveIntoMethodDef(elem); });
    } else if (auto send = ast::cast_tree<ast::Send>(exp)) {
        if (!canMoveIntoMethodDef(send->recv)) {
            return false;
        }
        for (auto &arg : send->nonBlockArgs()) {
            if (!canMoveIntoMethodDef(arg)) {
                return false;
            }
        }

        return true;
    } else if (ast::isa_tree<ast::UnresolvedConstantLit>(exp)) {
        return true;
    }
    return false;
}

// if the thing can be moved into a method def, then the thing we iterate over can be copied into the body of the
// method, and otherwise we replace it with a synthesized 'nil'
ast::ExpressionPtr getIteratee(ast::ExpressionPtr &exp) {
    if (canMoveIntoMethodDef(exp)) {
        return exp.deepCopy();
    } else {
        return ast::MK::RaiseUnimplemented(exp.loc());
    }
}

optional<pair<core::NameRef, core::LocOffsets>> getLetNameAndDeclLoc(const ast::Send &send) {
    if (send.numPosArgs() == 0) {
        if (send.fun != core::Names::subject()) {
            return nullopt;
        }

        return pair{core::Names::subject(), send.funLoc};
    }

    if (send.numPosArgs() != 1) {
        return nullopt;
    }

    auto &arg = send.getPosArg(0);
    if (!ast::isa_tree<ast::Literal>(arg)) {
        return nullopt;
    }
    auto argLiteral = ast::cast_tree_nonnull<ast::Literal>(arg);
    if (!argLiteral.isName()) {
        return nullopt;
    }

    auto declLoc = send.loc.copyWithZeroLength().join(argLiteral.loc);
    auto methodName = argLiteral.asName();
    return pair{methodName, declLoc};
}

bool isRSpec(core::Context ctx, const ast::ExpressionPtr &recv) {
    auto cnst = ast::cast_tree<ast::UnresolvedConstantLit>(recv);
    if (cnst == nullptr) {
        return false;
    }

    return cnst->cnst == core::Names::Constants::RSpec() && ast::MK::isRootScope(cnst->scope);
}

// Some RSpec methods are relatively common method names where we really want to make sure that
// we're definitely in a test context before we do the translation here.
//
// This is kind of vibes based, mostly just to be defensive so that we don't break people who had
// depended on methods sharing names with RSpec methods not firing.
bool requiresSecondFactor(core::NameRef fun) {
    switch (fun.rawId()) {
        // Example names
        case core::Names::example().rawId():
        case core::Names::focus().rawId():
        case core::Names::pending().rawId():
        case core::Names::skip().rawId():
        case core::Names::its().rawId():
        // ExampleGroup names
        case core::Names::context().rawId():
        case core::Names::exampleGroup().rawId():
            return true;

        default:
            return false;
    }
}

// Returns a method name for the method definition to create, or no name if this is not a valid
// method-defining test helper.
// rspecMode: if true, allows RSpec-style multi-argument calls (metadata tags)
core::NameRef nameForTestHelperMethod(core::MutableContext ctx, const ast::Send &send, bool rspecMode) {
    auto arity = send.numPosArgs();
    switch (send.fun.rawId()) {
        case core::Names::before().rawId():
            // For RSpec: allow before() with optional scope (:each/:all/:context/:suite) and
            // metadata filters (e.g., before(:each, :slow) or before(:example, :authorized => true))
            // For minitest: only allow before() with no arguments
            if (rspecMode) {
                return core::Names::beforeAngles();
            } else {
                return arity == 0 ? core::Names::beforeAngles() : core::NameRef::noName();
            }

        case core::Names::after().rawId():
            // For RSpec: allow after() with optional scope (:each/:all/:context/:suite) and
            // metadata filters (e.g., after(:each, :slow) or after(:example, :authorized => true))
            // For minitest: only allow after() with no arguments
            if (rspecMode) {
                return core::Names::afterAngles();
            } else {
                return arity == 0 ? core::Names::afterAngles() : core::NameRef::noName();
            }

        case core::Names::it().rawId():
        case core::Names::xit().rawId():
        case core::Names::fit().rawId():
        case core::Names::specify().rawId():
        case core::Names::xspecify().rawId():
        case core::Names::fspecify().rawId():
        case core::Names::example().rawId():
        case core::Names::fexample().rawId():
        case core::Names::xexample().rawId():
        case core::Names::focus().rawId():
        case core::Names::pending().rawId():
        case core::Names::skip().rawId(): {
            // For RSpec: allow multiple arguments (description + optional metadata tags)
            // For minitest: only allow 0 or 1 argument
            if (arity == 0) {
                return core::Names::itAngles();
            } else if (arity == 1 || rspecMode) {
                auto name = fmt::format("<{} '{}'>", send.fun.show(ctx), to_s(ctx, send.getPosArg(0)));
                return ctx.state.enterNameUTF8(name);
            } else {
                return core::NameRef::noName();
            }
        }

        default:
            return core::NameRef::noName();
    }
}

// Synthesizes a `<shared_examples 'name'>` constant reference, either root-scoped
// (`rootScoped=true`, for `RSpec.shared_examples`, matching RSpec's `:main` registry slot)
// or unrooted (for bare `shared_examples`, nested under the enclosing scope). Consumer
// references (`include_examples` / `it_behaves_like`) always use unrooted constants so
// lookup reaches both via the ancestor chain.
ast::ExpressionPtr makeSharedExamplesConstant(core::MutableContext ctx, const ast::ExpressionPtr &arg,
                                              bool rootScoped) {
    // We use shared_examples regardless of the send used to create the shared examples module,
    // because they are uniquely identified by the string argument (not which method alias was used
    // to create the module)
    auto name = fmt::format("<shared_examples '{}'>", to_s(ctx, arg));
    ast::ExpressionPtr scope = rootScoped ? ast::MK::Constant(arg.loc(), core::Symbols::root()) : ast::MK::EmptyTree();
    return ast::make_expression<ast::UnresolvedConstantLit>(arg.loc(), move(scope), ctx.state.enterNameConstant(name));
}

// Returns the appropriate superclass for a test class (e.g. from `its` or `it_behaves_like`)
// that may be nested inside a shared_examples block. Inside a shared_examples block, `self` is
// a module, not a class. We can't inherit from a module, so we use RSpec::Core::ExampleGroup
// instead, mirroring what describe/context does in the same situation.
ast::ExpressionPtr makeTestClassAncestor(core::LocOffsets loc, const ast::ExpressionPtr &maybeSharedExamplesName) {
    if (maybeSharedExamplesName == nullptr) {
        return ast::MK::Self(loc);
    }
    static const core::NameRef rspecParts[3] = {
        core::Names::Constants::RSpec(),
        core::Names::Constants::Core(),
        core::Names::Constants::ExampleGroup(),
    };
    return ast::MK::UnresolvedConstantParts(loc, rspecParts);
}

bool isSharedExamplesName(core::NameRef name) {
    switch (name.rawId()) {
        case core::Names::sharedExamples().rawId():
        case core::Names::sharedContext().rawId():
        case core::Names::sharedExamplesFor().rawId():
            return true;
        default:
            return false;
    }
}

// Rewrites include_examples/include_context to include(ConstantName), or returns EmptyTree to
// silently drop the call if the argument is not a string/symbol literal (e.g. a block parameter
// that can't be resolved at compile time). Must only be called after a numPosArgs >= 1 check.
ast::ExpressionPtr rewriteIncludeExamples(core::MutableContext ctx, ast::Send *send) {
    ENFORCE(send->numPosArgs() > 0);
    if (!ast::isa_tree<ast::Literal>(send->getPosArg(0))) {
        return ast::MK::EmptyTree();
    }
    auto name = makeSharedExamplesConstant(ctx, send->getPosArg(0), /*rootScoped=*/false);
    return ast::MK::Send1(send->loc, move(send->recv), core::Names::include(), send->funLoc, move(name));
}

ast::ExpressionPtr prepareParameterizedBody(core::MutableContext ctx, core::NameRef eachName, ast::ExpressionPtr body,
                                            const ast::MethodDef::PARAMS_store &args,
                                            absl::Span<const ast::ExpressionPtr> destructuringStmts,
                                            ast::ExpressionPtr &iteratee, bool insideDescribe);

// A describe with captured locals keeps its executable body in the original
// block, while its helper declarations belong to a separate synthetic class.
struct CapturedDescribe {
    const ast::ExpressionPtr &name;
    ast::ClassDef::RHS_store &declarations;
};

ast::ExpressionPtr runSingle(core::MutableContext ctx, bool isClass, const ast::ExpressionPtr &maybeSharedExamplesName,
                             ast::Send *send, bool insideDescribe, CapturedDescribe *capturedDescribe = nullptr);

// A Ruby block can capture a local from an enclosing block. Replacing either
// side with a class or method loses that binding. Keep these blocks intact when
// indexing; ordinary Sorbet continues to use its test DSL rewrites.
class CapturedTestLocals {
    struct Scope {
        UnorderedMap<core::NameRef, size_t> bindings;
        bool crossesRewrite = false;
        bool inRoot = true;
    };
    vector<Scope> scopes;
    UnorderedSet<const ast::Block *> rewrittenBlocks;
    UnorderedSet<core::NameRef> rootParameters;

    void define(const ast::ExpressionPtr &expr, bool shadow = false) {
        if (auto local = ast::cast_tree<ast::UnresolvedIdent>(expr)) {
            if (local->kind == ast::UnresolvedIdent::Kind::Local) {
                auto &bindings = scopes.back().bindings;
                if (shadow || !bindings.contains(local->name)) {
                    bindings[local->name] = scopes.size() - 1;
                }
            }
        } else if (auto rest = ast::cast_tree<ast::RestParam>(expr)) {
            define(rest->expr, shadow);
        } else if (auto keyword = ast::cast_tree<ast::KeywordArg>(expr)) {
            define(keyword->expr, shadow);
        } else if (auto optional = ast::cast_tree<ast::OptionalParam>(expr)) {
            define(optional->expr, shadow);
        } else if (auto block = ast::cast_tree<ast::BlockParam>(expr)) {
            define(block->expr, shadow);
        } else if (auto local = ast::cast_tree<ast::ShadowArg>(expr)) {
            define(local->expr, shadow);
        }
    }

public:
    bool captures = false;
    bool externalCaptures = false;
    bool copiesParameters = false;

    void preTransformSend(core::MutableContext ctx, ast::ExpressionPtr &tree) {
        auto &send = ast::cast_tree_nonnull<ast::Send>(tree);
        if (!send.hasBlock()) {
            return;
        }
        if (nameForTestHelperMethod(ctx, send, true).exists() ||
            send.fun == core::Names::let() || send.fun == core::Names::let_bang() ||
            send.fun == core::Names::subject() || send.fun == core::Names::describe() ||
            send.fun == core::Names::context() || send.fun == core::Names::exampleGroup() ||
            send.fun == core::Names::xdescribe() || send.fun == core::Names::fdescribe() ||
            send.fun == core::Names::xcontext() || send.fun == core::Names::fcontext() ||
            send.fun == core::Names::its() || isSharedExamplesName(send.fun)) {
            rewrittenBlocks.insert(send.block());
        }
    }

    void preTransformBlock(core::MutableContext ctx, ast::ExpressionPtr &tree) {
        auto &block = ast::cast_tree_nonnull<ast::Block>(tree);
        Scope scope = scopes.empty() ? Scope{} : scopes.back();
        scope.crossesRewrite |= !scopes.empty() && rewrittenBlocks.contains(&block);
        scopes.emplace_back(std::move(scope));
        for (const auto &param : block.params) {
            define(param, true);
        }
        if (scopes.size() == 1 && copiesParameters) {
            for (const auto &[name, depth] : scopes.back().bindings) {
                rootParameters.insert(name);
            }
        }
    }
    void postTransformBlock(core::MutableContext ctx, ast::ExpressionPtr &tree) {
        scopes.pop_back();
    }
    void preTransformClassDef(core::MutableContext ctx, ast::ExpressionPtr &tree) {
        scopes.emplace_back(Scope{{}, false, false});
    }
    void postTransformClassDef(core::MutableContext ctx, ast::ExpressionPtr &tree) {
        scopes.pop_back();
    }
    void preTransformMethodDef(core::MutableContext ctx, ast::ExpressionPtr &tree) {
        scopes.emplace_back(Scope{{}, false, false});
    }
    void postTransformMethodDef(core::MutableContext ctx, ast::ExpressionPtr &tree) {
        scopes.pop_back();
    }
    void preTransformAssign(core::MutableContext ctx, ast::ExpressionPtr &tree) {
        define(ast::cast_tree_nonnull<ast::Assign>(tree).lhs);
    }
    void preTransformRescueCase(core::MutableContext ctx, ast::ExpressionPtr &tree) {
        define(ast::cast_tree_nonnull<ast::RescueCase>(tree).var);
    }
    void postTransformUnresolvedIdent(core::MutableContext ctx, ast::ExpressionPtr &tree) {
        auto &local = ast::cast_tree_nonnull<ast::UnresolvedIdent>(tree);
        if (!scopes.back().inRoot || local.kind != ast::UnresolvedIdent::Kind::Local ||
            local.name.kind() != core::NameKind::UTF8 ||
            ctx.locAt(local.loc).source(ctx) != local.name.show(ctx)) {
            return;
        }
        const auto &scope = scopes.back();
        auto binding = scope.bindings.find(local.name);
        externalCaptures |= binding == scope.bindings.end();
        captures |= binding == scope.bindings.end() ||
                    (binding->second == 0 && scope.crossesRewrite && !rootParameters.contains(local.name));
    }
};

ast::ExpressionPtr invalidUnderParameterizedBody(core::MutableContext ctx, core::NameRef eachName,
                                                 ast::ExpressionPtr stmt) {
    if (isSharedExamplesName(eachName)) {
        // To avoid causing undue errors in codebases that already use `shared_examples`, we don't
        // report an error. Only report for test_each-style usages, because codebases will have
        // explicitly opted into using that to get their types to check (no pre-existing usages that
        // cause tricky migrations).
        return stmt;
    }

    // if any of the above tests were not satisfied, then mark this statement as being invalid here
    if (auto e = ctx.beginIndexerError(stmt.loc(), core::errors::Rewriter::BadTestEach)) {
        e.setHeader("Only valid `{}`, `{}`, `{}`, and `{}` blocks can appear within `{}`", "it", "before", "after",
                    "describe", eachName.show(ctx));
        e.addErrorNote("For other things, like constant and variable assignments,"
                       "    hoist them to constants or methods defined outside the `{}` block.",
                       eachName.show(ctx));
    }

    return stmt;
}

// this applies to each statement contained within a `test_each`: if it's an `it`-block, then convert it appropriately,
// otherwise flag an error about it
ast::ExpressionPtr runUnderParameterized(core::MutableContext ctx, core::NameRef eachName,
                                         absl::Span<const ast::ExpressionPtr> destructuringStmts,
                                         ast::ExpressionPtr stmt, const ast::MethodDef::PARAMS_store &args,
                                         ast::ExpressionPtr &iteratee, bool insideDescribe) {
    // this statement must be a send
    auto send = ast::cast_tree<ast::Send>(stmt);
    if (send == nullptr) {
        return invalidUnderParameterizedBody(ctx, eachName, move(stmt));
    }

    if (send->hasBlock() && send->block()->params.size() != 0) {
        // Allow shared_examples/shared_context (bare or RSpec.-prefixed) with block params to
        // pass through to the switch below, where they'll be handled by runSingle's
        // sharedExamples arm (which fake-test_each's the inner body). Other statements with
        // block params are unsupported.
        if (!isSharedExamplesName(send->fun)) {
            return invalidUnderParameterizedBody(ctx, eachName, move(stmt));
        }
    }

    // test_each is a Sorbet-specific DSL, not RSpec, so use minitest-style strict arity
    auto maybeName = nameForTestHelperMethod(ctx, *send, /* rspecMode */ false);
    if (maybeName.exists() && send->hasBlock()) {
        auto name = maybeName;

        // pull constants out of the block
        ConstantMover constantMover;
        ast::ExpressionPtr body = move(send->block()->body);

        // we don't need to make a new body if the original one was empty
        if (!ast::isa_tree<ast::EmptyTree>(body)) {
            ast::TreeWalk::apply(ctx, constantMover, body);

            // add the destructuring statements to the block if they're present
            if (!destructuringStmts.empty()) {
                ast::InsSeq::STATS_store stmts;
                for (auto &stmt : destructuringStmts) {
                    stmts.emplace_back(stmt.deepCopy());
                }
                body = ast::MK::InsSeq(body.loc(), std::move(stmts), std::move(body));
            }
        }

        // pull the arg and the iteratee in and synthesize `iterate.each { |arg| body }`
        ast::MethodDef::PARAMS_store new_args;
        for (auto &arg : args) {
            new_args.emplace_back(arg.deepCopy());
        }

        auto blk = ast::MK::Block(send->block()->loc, move(body), std::move(new_args));
        auto each = ast::MK::Send0Block(send->loc, iteratee.deepCopy(), core::Names::each(),
                                        send->loc.copyWithZeroLength(), move(blk));
        // put that into a method def named the appropriate thing
        auto declLoc = declLocForSendWithBlock(*send);
        auto method = ast::MK::SyntheticMethod0(send->loc, declLoc, testHelperNameLoc(*send), move(name), move(each));
        ast::cast_tree_nonnull<ast::MethodDef>(method).flags.hasHandwrittenBody = true;
        method = addSigVoid(ctx, move(method));
        // add back any moved constants
        return constantMover.addConstantsToExpression(send->loc, move(method));
    }

    switch (send->fun.rawId()) {
        case core::Names::describe().rawId():
        case core::Names::xdescribe().rawId():
        case core::Names::fdescribe().rawId():
        case core::Names::context().rawId():
        case core::Names::xcontext().rawId():
        case core::Names::fcontext().rawId():
        case core::Names::exampleGroup().rawId(): {
            if (send->numPosArgs() != 1 || !send->hasBlock()) {
                break;
            }

            return prepareParameterizedBody(ctx, eachName, std::move(send->block()->body), args, destructuringStmts,
                                            iteratee, /* insideDescribe */ true);
        }

        case core::Names::let().rawId():
        case core::Names::let_bang().rawId():
        case core::Names::subject().rawId(): {
            if (!send->hasBlock() ||
                !(insideDescribe && (send->numPosArgs() == 0 || ast::isa_tree<ast::Literal>(send->getPosArg(0))))) {
                break;
            }

            auto maybeDecl = getLetNameAndDeclLoc(*send);
            if (!maybeDecl.has_value()) {
                break;
            }
            auto [methodName, declLoc] = maybeDecl.value();

            ConstantMover constantMover;
            auto body = move(send->block()->body);
            ast::TreeWalk::apply(ctx, constantMover, body);

            if (ctx.state.isSCIPRuby && !args.empty()) {
                // Shared-example helpers capture the shared block's parameters,
                // just like its examples do. Carry their definitions into the
                // synthetic helper so these reads do not become dangling locals.
                ast::MethodDef::PARAMS_store params;
                for (const auto &arg : args) {
                    params.emplace_back(arg.deepCopy());
                }
                ast::InsSeq::STATS_store stmts;
                for (const auto &stmt : destructuringStmts) {
                    stmts.emplace_back(stmt.deepCopy());
                }
                body = ast::MK::InsSeq(body.loc(), std::move(stmts), std::move(body));
                auto block = ast::MK::Block(send->block()->loc, std::move(body), std::move(params));
                body = ast::MK::Send0Block(send->loc, iteratee.deepCopy(), core::Names::each(),
                                           send->loc.copyWithZeroLength(), std::move(block));
            }

            auto method = ast::MK::SyntheticMethod0(send->loc, declLoc, testHelperNameLoc(*send), methodName, move(body));
            ast::cast_tree_nonnull<ast::MethodDef>(method).flags.hasHandwrittenBody = true;
            return constantMover.addConstantsToExpression(send->loc, move(method));
        }

        case core::Names::sharedExamples().rawId():
        case core::Names::sharedContext().rawId():
        case core::Names::sharedExamplesFor().rawId(): {
            if (!ctx.state.cacheSensitiveOptions.rspecRewriterEnabled) {
                break;
            }
            // `RSpec.`-prefixed registers globally, bare-receiver scopes to the consumer on
            // each include of the outer. `runSingle` distinguishes the two by checking the
            // receiver — see the comment on its `sharedExamples` arm.
            auto result =
                runSingle(ctx, /* isClass */ false, /* maybeSharedExamplesName */ nullptr, send, insideDescribe);
            if (result != nullptr) {
                return result;
            }
            break;
        }

        case core::Names::includeExamples().rawId():
        case core::Names::includeContext().rawId(): {
            if (!ctx.state.cacheSensitiveOptions.rspecRewriterEnabled || send->hasBlock() || !insideDescribe ||
                send->numPosArgs() < 1) {
                break;
            }

            return rewriteIncludeExamples(ctx, send);
        }
    }

    return invalidUnderParameterizedBody(ctx, eachName, move(stmt));
}

bool isDestructuringArg(core::GlobalState &gs, const ast::MethodDef::PARAMS_store &args,
                        const ast::ExpressionPtr &expr) {
    auto local = ast::cast_tree<ast::UnresolvedIdent>(expr);
    if (local == nullptr || local->kind != ast::UnresolvedIdent::Kind::Local) {
        return false;
    }

    auto name = local->name;
    if (name.kind() != core::NameKind::UNIQUE || name.dataUnique(gs)->original != core::Names::destructureArg()) {
        return false;
    }

    return absl::c_find_if(args, [name](auto &argExpr) {
               auto arg = ast::cast_tree<ast::UnresolvedIdent>(argExpr);
               return arg && arg->name == name;
           }) != args.end();
}

// When given code that looks like
//
//     test_each(pairs) do |(x, y)|
//       # ...
//     end
//
// Sorbet desugars it to essentially
//
//     test_each(pairs) do |<destructureArg$1|
//       x = <destructureArg$1>[0]
//       y = <destructureArg$1>[1]
//
//       # ...
//     end
//
// which would otherwise defeat the "Only valid it-blocks can appear within test_each" error message.
//
// Because this case is so common, we have special handling to detect "contains only valid it-blocks
// plus desugared destruturing assignments."
bool isDestructuringInsSeq(core::GlobalState &gs, const ast::MethodDef::PARAMS_store &args, ast::InsSeq *body) {
    return absl::c_all_of(body->stats, [&gs, &args](auto &stat) {
        auto insSeq = ast::cast_tree<ast::InsSeq>(stat);
        if (insSeq == nullptr) {
            return false;
        }

        auto assign = ast::cast_tree<ast::Assign>(insSeq->stats.front());
        return assign && isDestructuringArg(gs, args, assign->rhs);
    });
}

// this just walks the body of a `test_each` and tries to transform every statement
ast::ExpressionPtr prepareParameterizedBody(core::MutableContext ctx, core::NameRef eachName, ast::ExpressionPtr body,
                                            const ast::MethodDef::PARAMS_store &args,
                                            absl::Span<const ast::ExpressionPtr> destructuringStmts,
                                            ast::ExpressionPtr &iteratee, bool insideDescribe) {
    if (auto bodySeq = ast::cast_tree<ast::InsSeq>(body)) {
        if (isDestructuringInsSeq(ctx, args, bodySeq)) {
            ENFORCE(destructuringStmts.empty(), "Nested destructuring statements");
            return prepareParameterizedBody(ctx, eachName, std::move(bodySeq->expr), args,
                                            absl::MakeSpan(bodySeq->stats), iteratee, insideDescribe);
        }

        for (auto &exp : bodySeq->stats) {
            exp = runUnderParameterized(ctx, eachName, destructuringStmts, std::move(exp), args, iteratee,
                                        insideDescribe);
        }

        bodySeq->expr = runUnderParameterized(ctx, eachName, destructuringStmts, std::move(bodySeq->expr), args,
                                              iteratee, insideDescribe);
    } else {
        body =
            runUnderParameterized(ctx, eachName, destructuringStmts, std::move(body), args, iteratee, insideDescribe);
    }

    return body;
}

ast::ExpressionPtr tryRunSingleOnSend(core::MutableContext ctx, bool isClass,
                                      const ast::ExpressionPtr &maybeSharedExamplesName, ast::ExpressionPtr body,
                                      bool insideDescribe, CapturedDescribe *capturedDescribe) {
    if (capturedDescribe && (ast::isa_tree<ast::MethodDef>(body) || ast::isa_tree<ast::ClassDef>(body))) {
        capturedDescribe->declarations.emplace_back(std::move(body));
        return ast::MK::EmptyTree();
    }
    auto bodySend = ast::cast_tree<ast::Send>(body);
    if (bodySend) {
        if (capturedDescribe && bodySend->recv.isSelfReference() &&
            (bodySend->fun == core::Names::sig() || bodySend->fun == core::Names::include() ||
             bodySend->fun == core::Names::extend())) {
            capturedDescribe->declarations.emplace_back(std::move(body));
            return ast::MK::EmptyTree();
        }
        auto change = runSingle(ctx, isClass, maybeSharedExamplesName, bodySend, insideDescribe, capturedDescribe);
        if (change) {
            return change;
        }
    }
    return body;
}

ast::ExpressionPtr prepareBody(core::MutableContext ctx, bool isClass,
                               const ast::ExpressionPtr &maybeSharedExamplesName, ast::ExpressionPtr body,
                               bool insideDescribe, CapturedDescribe *capturedDescribe = nullptr) {
    body = tryRunSingleOnSend(ctx, isClass, maybeSharedExamplesName, std::move(body), insideDescribe, capturedDescribe);

    if (auto bodySeq = ast::cast_tree<ast::InsSeq>(body)) {
        for (auto &exp : bodySeq->stats) {
            exp = tryRunSingleOnSend(ctx, isClass, maybeSharedExamplesName, std::move(exp), insideDescribe,
                                     capturedDescribe);
        }

        bodySeq->expr = tryRunSingleOnSend(ctx, isClass, maybeSharedExamplesName, std::move(bodySeq->expr),
                                           insideDescribe, capturedDescribe);
    }
    return body;
}

ast::ExpressionPtr runSingleImpl(core::MutableContext ctx, bool isClass,
                                 const ast::ExpressionPtr &maybeSharedExamplesName, ast::Send *send,
                                 bool insideDescribe, bool &retainsOriginalCall, CapturedDescribe *capturedDescribe);

ast::ExpressionPtr runSingle(core::MutableContext ctx, bool isClass, const ast::ExpressionPtr &maybeSharedExamplesName,
                             ast::Send *send, bool insideDescribe, CapturedDescribe *capturedDescribe) {
    if (ctx.state.isSCIPRuby && send->flags.isRewriterSynthesized) {
        return nullptr;
    }
    ast::ExpressionPtr originalCall;
    if (ctx.state.isSCIPRuby) {
        // Replacing the DSL call with a class/method must not erase navigation
        // on `context`, `specify`, etc. Keep its receiver and arguments in their
        // original scope. The rewritten node owns the handwritten block body.
        ast::Send::ARGS_store args;
        for (const auto &arg : send->nonBlockArgs()) {
            args.emplace_back(arg.deepCopy());
        }
        if (auto block = send->block()) {
            args.emplace_back(ast::MK::Block(block->loc, ast::MK::EmptyTree(), {}));
        }
        auto flags = send->flags;
        flags.isRewriterSynthesized = true;
        originalCall = ast::MK::Send(send->loc, send->recv.deepCopy(), send->fun, send->funLoc,
                                    send->numPosArgs(), std::move(args), flags);
    }
    bool retainsOriginalCall = false;
    auto result = runSingleImpl(ctx, isClass, maybeSharedExamplesName, send, insideDescribe, retainsOriginalCall,
                                capturedDescribe);
    if (result && originalCall && !retainsOriginalCall) {
        return ast::MK::InsSeq1(send->loc, std::move(originalCall), std::move(result));
    }
    return result;
}

ast::ExpressionPtr runSingleImpl(core::MutableContext ctx, bool isClass,
                                 const ast::ExpressionPtr &maybeSharedExamplesName, ast::Send *send,
                                 bool insideDescribe, bool &retainsOriginalCall, CapturedDescribe *capturedDescribe) {
    auto *block = send->block();
    bool preserveDescribe = false;
    if (ctx.state.isSCIPRuby && block != nullptr && send->fun != core::Names::testEach() &&
        send->fun != core::Names::testEachHash()) {
        CapturedTestLocals locals;
        locals.copiesParameters = isSharedExamplesName(send->fun);
        ast::TreeWalk::apply(ctx, locals, *send->rawBlock());
        const bool isDescribe = send->fun == core::Names::describe() || send->fun == core::Names::context() ||
                                send->fun == core::Names::exampleGroup() || send->fun == core::Names::xdescribe() ||
                                send->fun == core::Names::fdescribe() || send->fun == core::Names::xcontext() ||
                                send->fun == core::Names::fcontext();
        preserveDescribe = isDescribe && (locals.externalCaptures || capturedDescribe != nullptr);
        if (!isDescribe && (locals.captures || capturedDescribe != nullptr)) {
            bool isLet = send->fun == core::Names::let() || send->fun == core::Names::let_bang() ||
                         send->fun == core::Names::subject();
            if (insideDescribe && send->recv.isSelfReference() &&
                (isLet || nameForTestHelperMethod(ctx, *send, ctx.state.cacheSensitiveOptions.rspecRewriterEnabled).exists())) {
                // An example executes on an instance even when it stays a block
                // to retain its lexical locals. Match the self type of the
                // method that the ordinary test rewriter would have generated.
                auto loc = block->loc.copyWithZeroLength();
                auto type = capturedDescribe ? capturedDescribe->name.deepCopy()
                                             : (maybeSharedExamplesName ? maybeSharedExamplesName.deepCopy()
                                                                        : ast::MK::SelfType(loc));
                auto bind = ast::MK::SyntheticBind(loc, ast::MK::Self(loc), std::move(type));
                block->body = ast::MK::InsSeq1(block->loc, std::move(bind), std::move(block->body));
                if (isLet) {
                    if (auto decl = getLetNameAndDeclLoc(*send)) {
                        // Keep the body in its closure, and expose the helper
                        // name to other examples. Its return type is untyped,
                        // just as for an unsignatured handwritten method.
                        auto [name, declLoc] = *decl;
                        auto method = ast::MK::SyntheticMethod0(send->loc, declLoc, testHelperNameLoc(*send), name,
                                                               ast::MK::UntypedNil(loc));
                        if (capturedDescribe) {
                            capturedDescribe->declarations.emplace_back(std::move(method));
                            return nullptr;
                        }
                        ast::Send::ARGS_store args;
                        for (const auto &arg : send->nonBlockArgs()) {
                            args.emplace_back(arg.deepCopy());
                        }
                        args.emplace_back(send->rawBlock()->deepCopy());
                        auto flags = send->flags;
                        flags.isRewriterSynthesized = true;
                        auto original = ast::MK::Send(send->loc, send->recv.deepCopy(), send->fun, send->funLoc,
                                                      send->numPosArgs(), std::move(args), flags);
                        retainsOriginalCall = true;
                        return ast::MK::InsSeq1(send->loc, std::move(original), std::move(method));
                    }
                }
            }
            return nullptr;
        }
    }

    switch (send->fun.rawId()) {
        case core::Names::testEach().rawId():
        case core::Names::testEachHash().rawId(): {
            if (block == nullptr || !send->recv.isSelfReference()) {
                return nullptr;
            }

            if (send->numPosArgs() != 1) {
                if (send->fun == core::Names::testEachHash() && send->numKwArgs() > 0) {
                    auto errLoc = send->getKwKey(0).loc().join(send->getKwValue(send->numKwArgs() - 1).loc());
                    if (auto e = ctx.beginIndexerError(errLoc, core::errors::Rewriter::BadTestEach)) {
                        e.setHeader("`{}` expects a single `{}` argument, not keyword args", "test_each_hash", "Hash");
                        if (send->numPosArgs() == 0 && errLoc.exists()) {
                            auto replaceLoc = ctx.locAt(errLoc);
                            e.replaceWith("Wrap with curly braces", replaceLoc, "{{{}}}",
                                          replaceLoc.source(ctx).value());
                        }
                    }
                }

                return nullptr;
            }

            if ((send->fun == core::Names::testEach() && block->params.size() < 1) ||
                (send->fun == core::Names::testEachHash() && block->params.size() != 2)) {
                if (auto e = ctx.beginIndexerError(block->loc, core::errors::Rewriter::BadTestEach)) {
                    e.setHeader("Wrong number of parameters for `{}` block: expected `{}`, got `{}`",
                                send->fun.show(ctx), send->fun == core::Names::testEach() ? "at least 1" : "2",
                                block->params.size());
                }
                return nullptr;
            }

            // if this has the form `test_each(expr) { |arg | .. }`, then start by trying to convert `expr` into a thing
            // we can freely copy into methoddef scope
            auto iteratee = getIteratee(send->getPosArg(0));
            // and then reconstruct the send but with a modified body
            auto body = prepareParameterizedBody(ctx, send->fun, std::move(block->body), block->params, {}, iteratee,
                                                 insideDescribe);
            return ast::MK::Send(send->loc, ast::MK::Self(send->recv.loc()), send->fun, send->funLoc, 1,
                                 ast::MK::SendArgs(move(send->getPosArg(0)), ast::MK::Block(block->loc, std::move(body),
                                                                                            std::move(block->params))),
                                 send->flags);
        }

        case core::Names::describe().rawId():
        case core::Names::xdescribe().rawId():
        case core::Names::fdescribe().rawId():
        case core::Names::context().rawId():
        case core::Names::xcontext().rawId():
        case core::Names::fcontext().rawId():
        case core::Names::exampleGroup().rawId(): {
            if (block == nullptr) {
                return nullptr;
            }

            auto recvIsRSpec = isRSpec(ctx, send->recv);
            if (!send->recv.isSelfReference() && !recvIsRSpec) {
                return nullptr;
            }

            // RSpec.describe requires the RSpec rewriter to be enabled
            if (recvIsRSpec && !ctx.state.cacheSensitiveOptions.rspecRewriterEnabled) {
                return nullptr;
            }

            // RSpec mode allows multiple args (description + metadata tags like :slow, focus: true)
            // Minitest mode requires exactly one arg (description only)
            //
            // Note: rspecMode includes recvIsRSpec here because top-level RSpec.describe calls
            // need RSpec treatment even though insideDescribe is false. For it/before/after below,
            // we only use insideDescribe because those methods should only get RSpec treatment
            // when nested inside a describe block.
            bool rspecMode = recvIsRSpec || (insideDescribe && ctx.state.cacheSensitiveOptions.rspecRewriterEnabled);
            if (rspecMode) {
                if (send->numPosArgs() == 0) {
                    return nullptr;
                }
            } else {
                if (send->numPosArgs() != 1) {
                    return nullptr;
                }
            }

            if (requiresSecondFactor(send->fun) && !recvIsRSpec && !insideDescribe) {
                return nullptr;
            }

            auto &arg = send->getPosArg(0);
            auto argString = to_s(ctx, arg);
            ast::ClassDef::ANCESTORS_store ancestors;

            static const core::NameRef rspecParts[3] = {
                core::Names::Constants::RSpec(),
                core::Names::Constants::Core(),
                core::Names::Constants::ExampleGroup(),
            };
            if (recvIsRSpec) {
                ancestors.emplace_back(ast::MK::UnresolvedConstantParts(send->recv.loc(), rspecParts));
            } else if (maybeSharedExamplesName == nullptr) {
                // First ancestor is the superclass
                if (isClass) {
                    ancestors.emplace_back(ast::MK::Self(arg.loc()));
                } else {
                    // Avoid subclassing self when it's a module, as that will produce an error.
                    ancestors.emplace_back(ast::MK::Constant(arg.loc(), core::Symbols::todo()));

                    // Note: For cases like `module M; describe '' {}; end`, minitest does not treat `M` as
                    // an ancestor of the dynamically-created class. Instead, it treats `Minitest::Spec` as
                    // an ancestor, which we're choosing not to model so that this rewriter pass works for
                    // RSpec specs too. This means users might have to add extra `include` lines in their
                    // describe bodies to convince Sorbet what's available, but at least it won't say that
                    // Minitest::Spec is an ancestor for RSpec tests.
                }
            } else {
                // If we're inside a shared_examples block, things are a little different.
                // We can't use `<self>` as the superclass, because `self` is a module. But we can't
                // leave it as nothing, because all the test helpers are defined on e.g. ExampleGroup
                // There might also be helpers from the outer shared_examples block.
                //
                // In this case, we'll hard-code that the parent class is `RSpec::Core::ExampleGroup`
                ENFORCE(!isClass, "Somehow we threaded down a maybeSharedExamplesName for a non-module parent class?")

                ancestors.emplace_back(ast::MK::UnresolvedConstantParts(maybeSharedExamplesName.loc(), rspecParts));
                ancestors.emplace_back(maybeSharedExamplesName.deepCopy());
            }

            auto testName = fmt::format("<{} '{}'>", send->fun.show(ctx), argString);
            // When the describe argument is a constant (e.g., `RSpec.describe MyClass`),
            // use a zero-length loc for the synthetic class name so that hovering on
            // `MyClass` resolves to the real constant, not the synthetic describe class.
            auto nameLoc = (recvIsRSpec && ast::isa_tree<ast::UnresolvedConstantLit>(arg))
                               ? arg.loc().copyWithZeroLength()
                               : arg.loc();
            auto name = ast::MK::UnresolvedConstantParts(nameLoc, {ctx.state.enterNameConstant(testName)});
            auto declLoc = declLocForSendWithBlock(*send);
            ast::ClassDef::RHS_store classBody;
            if (preserveDescribe) {
                // Keep the closure in its lexical scope. Only declarations move
                // into the describe class, so nested helpers remain distinct from
                // outer helpers even when their bodies capture the same local.
                auto loc = send->loc.copyWithZeroLength();
                auto scope = capturedDescribe ? capturedDescribe->name.deepCopy() : ast::MK::EmptyTree();
                auto instanceType =
                    ast::MK::UnresolvedConstant(loc, std::move(scope), ctx.state.enterNameConstant(testName));
                CapturedDescribe current{instanceType, classBody};
                auto body = prepareBody(ctx, true, nullptr, std::move(block->body), true, &current);
                auto bind =
                    ast::MK::SyntheticBind(loc, ast::MK::Self(loc), ast::MK::ClassOf(loc, instanceType.deepCopy()));
                block->body = ast::MK::InsSeq1(block->loc, std::move(bind), std::move(body));
            } else {
                auto rhs = prepareBody(ctx, true, nullptr, std::move(block->body), true);
                classBody = flattenDescribeBody(ctx, std::move(rhs));
            }

            // For an RSpec `describe`/`context` with a constant arg, synthesize an instance method
            // `described_class` typed `T.class_of(arg)`. Without this, callers see the `T.untyped`
            // return from `RSpec::Core::ExampleGroup#described_class`, or for nested describes the
            // wrong constant inherited from the enclosing describe. Skipped when the user defines
            // their own `described_class` to avoid shadowing or duplicate-method errors.
            if (rspecMode && ast::isa_tree<ast::UnresolvedConstantLit>(arg) &&
                !hasUserDefinedDescribedClass(classBody)) {
                auto methodLoc = arg.loc().copyWithZeroLength();
                auto describedClassMethod =
                    ast::MK::SyntheticMethod0(arg.loc(), methodLoc, core::Names::describedClass(), arg.deepCopy());
                ast::cast_tree_nonnull<ast::MethodDef>(describedClassMethod).flags.discardDef = true;
                auto sig = ast::MK::Sig0(methodLoc, ast::MK::ClassOf(methodLoc, arg.deepCopy()));
                classBody.emplace_back(std::move(sig));
                classBody.emplace_back(std::move(describedClassMethod));
            }

            auto classDef =
                ast::MK::Class(send->loc, declLoc, std::move(name), std::move(ancestors), std::move(classBody));

            if (preserveDescribe) {
                auto original = send->deepCopy();
                ast::cast_tree_nonnull<ast::Send>(original).flags.isRewriterSynthesized = true;
                retainsOriginalCall = true;
                if (capturedDescribe) {
                    capturedDescribe->declarations.emplace_back(std::move(classDef));
                    return original;
                }
                return ast::MK::InsSeq1(send->loc, std::move(classDef), std::move(original));
            }

            // Preserve the original constant reference in the tree so Sorbet can
            // resolve it for hover and go-to-definition.
            return ast::MK::InsSeq1(send->loc, arg.deepCopy(), move(classDef));
        }

        case core::Names::after().rawId():
        case core::Names::before().rawId():
        case core::Names::it().rawId():
        case core::Names::xit().rawId():
        case core::Names::fit().rawId():
        case core::Names::specify().rawId():
        case core::Names::xspecify().rawId():
        case core::Names::fspecify().rawId():
        case core::Names::example().rawId():
        case core::Names::fexample().rawId():
        case core::Names::xexample().rawId():
        case core::Names::focus().rawId():
        case core::Names::pending().rawId():
        case core::Names::skip().rawId(): {
            if (block == nullptr || !send->recv.isSelfReference() ||
                (!insideDescribe && requiresSecondFactor(send->fun))) {
                return nullptr;
            }

            // Use RSpec mode if we're inside a describe block and RSpec rewriter is enabled
            bool rspecMode = insideDescribe && ctx.state.cacheSensitiveOptions.rspecRewriterEnabled;
            auto name = nameForTestHelperMethod(ctx, *send, rspecMode);
            if (!name.exists()) {
                return nullptr;
            }

            ConstantMover constantMover;
            ast::TreeWalk::apply(ctx, constantMover, block->body);
            auto declLoc = declLocForSendWithBlock(*send);
            auto method = ast::MK::SyntheticMethod0(
                send->loc, declLoc, testHelperNameLoc(*send), std::move(name),
                prepareBody(ctx, isClass, move(maybeSharedExamplesName), std::move(block->body), insideDescribe));

            // This prevents the `RuntimeMethodDefinition` from getting generated. For these `it`-block
            // defined methods, we don't actually need to care about the RuntimeMethodDefinition, and
            // omitting it saves memory.
            ast::cast_tree_nonnull<ast::MethodDef>(method).flags.discardDef = true;
            ast::cast_tree_nonnull<ast::MethodDef>(method).flags.hasHandwrittenBody = true;
            method = addSigVoid(ctx, move(method));
            if (send->numPosArgs() > 0 && !ast::isa_tree<ast::Literal>(send->getPosArg(0))) {
                method = ast::MK::InsSeq1(send->loc, send->getPosArg(0).deepCopy(), move(method));
            }
            return constantMover.addConstantsToExpression(send->loc, move(method));
        }

        case core::Names::its().rawId(): {
            if (block == nullptr || !send->recv.isSelfReference() || !insideDescribe) {
                return nullptr;
            }

            if (send->numPosArgs() != 1) {
                return nullptr;
            }

            auto &arg = send->getPosArg(0);

            // Handle both symbol and string arguments: its(:attribute) or its("attribute")
            // Note: We don't currently support chained method calls like its("size.zero?")
            auto argLit = ast::cast_tree<ast::Literal>(arg);
            if (argLit == nullptr || !argLit->isName()) {
                return nullptr;
            }

            auto attributeName = argLit->asName();
            auto argString = attributeName.show(ctx);

            // Create the describe block name
            auto describeTestName = fmt::format("<describe '{}'>", argString);
            auto describeName =
                ast::MK::UnresolvedConstantParts(arg.loc(), {ctx.state.enterNameConstant(describeTestName)});

            // Transform the its block body to replace is_expected with expect(subject.attribute)
            IsExpectedTransformer transformer(attributeName);
            ast::ExpressionPtr itBody = ast::TreeMap::apply(ctx, transformer, move(block->body));

            // Create it block
            auto itName = core::Names::itAngles();
            auto itDeclLoc = send->loc.copyWithZeroLength();

            ConstantMover constantMover;
            ast::TreeWalk::apply(ctx, constantMover, itBody);

            auto itMethod = ast::MK::SyntheticMethod0(send->loc, itDeclLoc, arg.loc(), itName,
                                                      prepareBody(ctx, /* isClass */ true, maybeSharedExamplesName,
                                                                  std::move(itBody), /* insideDescribe */ true));
            ast::cast_tree_nonnull<ast::MethodDef>(itMethod).flags.discardDef = true;
            ast::cast_tree_nonnull<ast::MethodDef>(itMethod).flags.hasHandwrittenBody = true;
            itMethod = addSigVoid(ctx, move(itMethod));
            itMethod = constantMover.addConstantsToExpression(send->loc, move(itMethod));

            ast::ClassDef::RHS_store describeBody;
            describeBody.emplace_back(std::move(itMethod));

            ast::ClassDef::ANCESTORS_store ancestors;
            ancestors.emplace_back(makeTestClassAncestor(arg.loc(), maybeSharedExamplesName));

            auto describeDeclLoc = declLocForSendWithBlock(*send);
            return ast::MK::Class(send->loc, describeDeclLoc, std::move(describeName), std::move(ancestors),
                                  std::move(describeBody));
        }

        case core::Names::let().rawId():
        case core::Names::let_bang().rawId():
        case core::Names::subject().rawId(): {
            if (block == nullptr || !send->recv.isSelfReference() || !insideDescribe) {
                return nullptr;
            }

            ConstantMover constantMover;
            ast::TreeWalk::apply(ctx, constantMover, block->body);

            auto maybeDecl = getLetNameAndDeclLoc(*send);
            if (!maybeDecl.has_value()) {
                return nullptr;
            }

            auto [methodName, declLoc] = maybeDecl.value();
            auto method = ast::MK::SyntheticMethod0(send->loc, declLoc, testHelperNameLoc(*send), methodName, std::move(block->body));
            ast::cast_tree_nonnull<ast::MethodDef>(method).flags.hasHandwrittenBody = true;
            return constantMover.addConstantsToExpression(send->loc, move(method));
        }

        case core::Names::sharedExamples().rawId():
        case core::Names::sharedContext().rawId():
        case core::Names::sharedExamplesFor().rawId(): {
            ENFORCE(isSharedExamplesName(send->fun));
            // Allow one or more arguments (name + optional metadata tags)
            if (!ctx.state.cacheSensitiveOptions.rspecRewriterEnabled || block == nullptr || send->numPosArgs() < 1) {
                return nullptr;
            }

            auto recvIsRSpec = isRSpec(ctx, send->recv);
            if (!send->recv.isSelfReference() && !recvIsRSpec) {
                return nullptr;
            }

            if (!insideDescribe && !recvIsRSpec) {
                return nullptr;
            }

            // See `makeSharedExamplesConstant` for why the receiver drives `rootScoped`.
            auto name = makeSharedExamplesConstant(ctx, send->getPosArg(0), /*rootScoped=*/recvIsRSpec);

            auto declLoc = declLocForSendWithBlock(*send);

            ast::ExpressionPtr body;
            if (block->params.empty()) {
                // We're not in a class (we're making a module).
                //
                // We're also not in a describe, but we're going to lie and say we are, because
                // we currently only use that to gate other Minitest/RSpec features behind a
                // check where we're _really_ sure that we're probably in a test context (vs
                // some unrelated, similarly-named DSL)
                body = prepareBody(ctx, /* isClass */ false, name.deepCopy(), move(block->body),
                                   /* insideDescribe */ true);
            } else {
                // We want to "fake" a test_each to approximate support for `shared_examples` that
                // accept parameters. Inside the body, it's basically the same as a test_each over a
                // single element.
                //
                // We hardcode `insideDescribe=true` here so that bare `shared_examples` nested
                // inside an outer parameterized `shared_context` reach the bare-arm of `runSingle`
                // (which gates on `insideDescribe || recvIsRSpec`) instead of being dropped. If
                // this argument ever becomes propagated, the bare-nested-in-parameterized fixture
                // (`rspec_shared_examples_bare_in_parameterized_context*.rb`) should catch the
                // regression.
                auto iterateeLoc = block->params.front().loc().join(block->params.back().loc());
                ast::Array::ENTRY_store entries;
                entries.emplace_back(ast::MK::UntypedNil(iterateeLoc));
                auto iteratee = ast::MK::Array(iterateeLoc, move(entries));
                body = prepareParameterizedBody(ctx, send->fun, move(block->body), block->params, {}, iteratee,
                                                /* insideDescribe */ true);
            }
            auto rhs = flattenDescribeBody(ctx, move(body));

            if (ctx.state.cacheSensitiveOptions.requiresAncestorEnabled) {
                // Don't generate this if the option isn't enabled.
                // Technically, Sorbet will ignore it, but also it could possibly generate a "failed
                // to resolve constant" error, so better to be defensive.

                auto emptyLoc = declLoc.copyEndWithZeroLength();
                static const core::NameRef parts[3] = {
                    core::Names::Constants::RSpec(),
                    core::Names::Constants::Core(),
                    core::Names::Constants::ExampleGroup(),
                };
                auto rspecExampleGroup = ast::MK::UnresolvedConstantParts(emptyLoc, parts);

                rhs.emplace_back(ast::MK::Send0Block(emptyLoc, ast::MK::Magic(emptyLoc),
                                                     core::Names::requiresAncestor(), emptyLoc,
                                                     ast::MK::Block0(emptyLoc, move(rspecExampleGroup))));
            }

            return ast::MK::Module(send->loc, declLoc, move(name), move(rhs));
        }

        case core::Names::includeExamples().rawId():
        case core::Names::includeContext().rawId(): {
            if (!ctx.state.cacheSensitiveOptions.rspecRewriterEnabled || block != nullptr ||
                !send->recv.isSelfReference() || !insideDescribe || send->numPosArgs() < 1) {
                return nullptr;
            }

            return rewriteIncludeExamples(ctx, send);
        }

        case core::Names::itBehavesLike().rawId(): {
            if (!ctx.state.cacheSensitiveOptions.rspecRewriterEnabled || block != nullptr ||
                !send->recv.isSelfReference() || !insideDescribe || send->numPosArgs() < 1) {
                return nullptr;
            }

            auto &arg = send->getPosArg(0);
            auto argString = to_s(ctx, arg);

            // it_behaves_like creates a nested class for isolation.
            // This wraps the shared examples in a new context so their definitions
            // (like let-defined methods) don't clobber the outer context's definitions.
            auto testName = fmt::format("<it_behaves_like '{}'>", argString);
            auto isolatedClassName = ast::MK::UnresolvedConstantParts(send->loc.copyWithZeroLength(),
                                                                      {ctx.state.enterNameConstant(testName)});

            ast::ClassDef::ANCESTORS_store ancestors;
            ast::ClassDef::RHS_store rhs;
            ancestors.emplace_back(makeTestClassAncestor(send->loc.copyWithZeroLength(), maybeSharedExamplesName));
            if (maybeSharedExamplesName != nullptr) {
                // Also include the parent shared_examples module so its helpers are available.
                rhs.emplace_back(ast::MK::Send1(send->loc, ast::MK::Self(send->recv.loc()), core::Names::include(),
                                                send->loc.copyWithZeroLength(), maybeSharedExamplesName.deepCopy()));
            }

            // Include the shared examples module in this isolated context. Use an unrooted
            // reference so the lookup walks the consumer's class hierarchy (finds both
            // root-scoped and nested-under-outer definitions).
            //
            // Load-bearing: this isolated class is emitted *lexically* where the original
            // `it_behaves_like` call appeared (inside the consumer's describe), so the
            // unrooted lookup walks through the consumer's ancestors and reaches a
            // bare-nested-under-outer shared examples module via the included outer. If a
            // future refactor hoists this class out of the consumer's lexical scope, bare
            // nested references will silently stop resolving.
            auto sharedExamplesName = makeSharedExamplesConstant(ctx, arg, /*rootScoped=*/false);
            auto includeStmt = ast::MK::Send1(send->loc, ast::MK::Self(send->recv.loc()), core::Names::include(),
                                              arg.loc(), move(sharedExamplesName));
            rhs.emplace_back(move(includeStmt));

            auto declLoc = send->loc.copyWithZeroLength();
            return ast::MK::Class(send->loc, declLoc, std::move(isolatedClassName), std::move(ancestors),
                                  std::move(rhs));
        }
    }

    return nullptr;
}

} // namespace

vector<ast::ExpressionPtr> Minitest::run(core::MutableContext ctx, bool isClass, ast::Send *send) {
    vector<ast::ExpressionPtr> stats;
    if (ctx.state.cacheSensitiveOptions.runningUnderAutogen) {
        return stats;
    }

    // Handle RSpec.local_context do ... end: scan the body for RSpec.shared_examples /
    // shared_context / shared_examples_for calls and hoist them to the top-level scope,
    // making them resolvable via include_examples / include_context in any describe block.
    if (ctx.state.cacheSensitiveOptions.rspecRewriterEnabled && send->fun == core::Names::localContext() &&
        isRSpec(ctx, send->recv) && send->hasBlock()) {
        auto *block = send->block();

        // Note: only direct Send children of the block body are scanned.
        // Shared examples nested inside conditionals or other blocks are not hoisted.
        auto processStmt = [&](ast::ExpressionPtr &stmt) {
            if (auto bodySend = ast::cast_tree<ast::Send>(stmt)) {
                auto result = runSingle(ctx, /* isClass */ false, /* maybeSharedExamplesName */ nullptr, bodySend,
                                        /* insideDescribe */ false);
                if (result != nullptr) {
                    stats.emplace_back(std::move(result));
                }
            }
        };

        if (auto bodySeq = ast::cast_tree<ast::InsSeq>(block->body)) {
            for (auto &exp : bodySeq->stats) {
                processStmt(exp);
            }
            processStmt(bodySeq->expr);
        } else {
            processStmt(block->body);
        }
        return stats;
    }

    auto insideDescribe = false;
    auto exp = runSingle(ctx, isClass, /* maybeSharedExamplesName */ nullptr, send, insideDescribe);
    if (exp != nullptr) {
        stats.emplace_back(std::move(exp));
    }
    return stats;
}

}; // namespace sorbet::rewriter
