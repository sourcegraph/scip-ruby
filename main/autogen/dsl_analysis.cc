#include "main/autogen/dsl_analysis.h"
#include "ast/Helpers.h"
#include "ast/ast.h"
#include "ast/treemap/treemap.h"
#include "common/formatting.h"
#include "main/autogen/crc_builder.h"

using namespace std;
namespace sorbet::autogen {

const std::vector<uint32_t> KNOWN_PROP_METHODS = {
    core::Names::tokenProp().rawId(), core::Names::timestampedTokenProp().rawId(),
    core::Names::registerPrefix().rawId(), core::Names::setArchiveTokenPrefix().rawId()};

const std::vector<core::NameRef> ABSTRACT_BLACKLIST_RECORD = {
    core::Names::Constants::Opus(),
    core::Names::Constants::Risk(),
    core::Names::Constants::Denylists(),
    core::Names::Constants::Model(),
    core::Names::Constants::AbstractBlacklistRecord(),
};

class DSLAnalysisWalk {
    UnorderedMap<vector<core::NameRef>, DSLInfo> dslInfo;
    vector<vector<core::NameRef>> nestingScopes;
    core::FileRef file;
    bool validScope;

    // Convert a symbol name into a fully qualified name
    vector<core::NameRef> symbolName(core::Context ctx, core::SymbolRef sym) {
        vector<core::NameRef> out;
        while (sym.exists() && sym != core::Symbols::root()) {
            out.emplace_back(sym.name(ctx));
            sym = sym.owner(ctx);
        }
        reverse(out.begin(), out.end());
        return out;
    }

    struct PropInfoInternal {
        core::NameRef name;
        bool isTimestamped;
    };

    std::optional<PropInfoInternal> parseProp(core::Context ctx, ast::Send *send) {
        switch (send->fun.rawId()) {
            case core::Names::timestampedTokenProp().rawId():
                if (send->numPosArgs() > 0) {
                    auto *lit = ast::cast_tree<ast::Literal>(send->getPosArg(0));
                    if (lit && lit->isString(ctx)) {
                        return PropInfoInternal{lit->asString(ctx), true};
                    } else {
                        return PropInfoInternal{core::NameRef::noName(), true};
                    }
                }
                break;
            case core::Names::setArchiveTokenPrefix().rawId():
            case core::Names::registerPrefix().rawId():
            case core::Names::tokenProp().rawId():
                if (send->numPosArgs() > 0) {
                    auto *lit = ast::cast_tree<ast::Literal>(send->getPosArg(0));
                    if (lit && lit->isString(ctx)) {
                        return PropInfoInternal{lit->asString(ctx), false};
                    } else {
                        return PropInfoInternal{core::NameRef::noName(), false};
                    }
                }
                break;
            default:
                return std::nullopt;
        }

        return std::nullopt;
    }

public:
    DSLAnalysisWalk(core::FileRef a_file) {
        validScope = true;
        file = a_file;
    }

    ast::ExpressionPtr preTransformClassDef(core::Context ctx, ast::ExpressionPtr tree) {
        auto &original = ast::cast_tree_nonnull<ast::ClassDef>(tree);
        if (original.symbol.data(ctx)->owner == core::Symbols::PackageRegistry()) {
            // this is a package, so do not enter a definition for it
            return tree;
        }

        vector<vector<core::NameRef>> ancestors;
        for (auto &ancst : original.ancestors) {
            auto *cnst = ast::cast_tree<ast::ConstantLit>(ancst);
            if (cnst == nullptr || cnst->original == nullptr) {
                // ignore them if they're not statically-known ancestors (i.e. not constants)
                continue;
            }

            const auto ancstName = symbolName(ctx, cnst->symbol);
            ancestors.emplace_back(std::move(ancstName));
        }

        const vector<core::NameRef> className = symbolName(ctx, original.symbol);
        nestingScopes.emplace_back(className);
        dslInfo.emplace(className, DSLInfo{{}, ancestors, file, {}});

        return tree;
    }

    ast::ExpressionPtr postTransformClassDef(core::Context ctx, ast::ExpressionPtr tree) {
        if (nestingScopes.size() == 0 || !validScope) {
            // Not in any scope
            return tree;
        }

        nestingScopes.pop_back();

        return tree;
    }

    ast::ExpressionPtr preTransformSend(core::Context ctx, ast::ExpressionPtr tree) {
        if (nestingScopes.size() == 0) {
            // Not in any scope
            return tree;
        }

        auto *original = ast::cast_tree<ast::Send>(tree);
        auto &curScope = nestingScopes.back();

        uint32_t funId = original->fun.rawId();
        bool isProp = absl::c_any_of(KNOWN_PROP_METHODS, [&](const auto &nrid) -> bool { return nrid == funId; });
        if (isProp) {
            if (!validScope) {
                dslInfo[curScope].problemLocs.emplace_back(LocInfo{file, std::move(original->loc)});
                return tree;
            }

            const auto prop = parseProp(ctx, original);
            if (prop.has_value()) {
                dslInfo[curScope].props.emplace_back(
                    PrefixPropInfo{std::move((*prop).name), std::move((*prop).isTimestamped)});
            } else {
                dslInfo[curScope].props.emplace_back(PrefixPropInfo{core::NameRef::noName(), false});
            }

            return tree;
        }

        return tree;
    }

    ast::ExpressionPtr preTransformMethodDef(core::Context ctx, ast::ExpressionPtr tree) {
        if (nestingScopes.size() == 0 || !validScope) {
            // Not already in a valid scope
            return tree;
        }

        auto &curScope = nestingScopes.back();
        if (curScope == ABSTRACT_BLACKLIST_RECORD) {
            return tree;
        }

        validScope = false;
        return tree;
    }

    ast::ExpressionPtr postTransformMethodDef(core::Context ctx, ast::ExpressionPtr tree) {
        if (nestingScopes.size() == 0 || validScope) {
            // Already in a valid scope, or never in a scope
            return tree;
        }

        validScope = true;
        return tree;
    }

    DSLAnalysisFile dslAnalysisFile() {
        DSLAnalysisFile out;
        out.dslInfo = std::move(dslInfo);
        out.file = std::move(file);
        return out;
    }
};

DSLAnalysisFile DSLAnalysis::generate(core::Context ctx, ast::ParsedFile tree, const CRCBuilder &crcBuilder) {
    DSLAnalysisWalk walk(tree.file);
    ast::TreeMap::apply(ctx, walk, move(tree.tree));
    auto daf = walk.dslAnalysisFile();
    auto src = tree.file.data(ctx).source();
    daf.cksum = crcBuilder.crc32(src);
    return daf;
}

} // namespace sorbet::autogen
