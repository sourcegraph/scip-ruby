#include "scip_indexer/SCIPProtoExt.h"

#include <string>

namespace scip {
#define CHECK_CMP(expr)     \
    {                       \
        auto cmp = expr;    \
        if (cmp != 0) {     \
            return cmp < 0; \
        }                   \
    }

int compareDiagnostic(const scip::Diagnostic &d1, const scip::Diagnostic &d2) {
    CHECK_CMP(int32_t(d1.severity()) - int32_t(d2.severity()));
    CHECK_CMP(d1.code().compare(d2.code()));
    CHECK_CMP(d1.message().compare(d2.message()));
    CHECK_CMP(d1.source().compare(d2.source()));
    CHECK_CMP(d1.tags_size() - d2.tags_size());
    for (auto i = 0; i < d1.tags_size(); i++) {
        CHECK_CMP(int32_t(d1.tags(i)) - int32_t(d2.tags(i)));
    }
    return 0;
}

int compareOccurrence(const scip::Occurrence &o1, const scip::Occurrence &o2) {
    CHECK_CMP(o1.range_size() - o2.range_size());
    for (auto i = 0; i < o1.range_size(); i++) {
        CHECK_CMP(o1.range(i) - o2.range(i));
    }
    CHECK_CMP(o1.symbol().compare(o2.symbol()));
    CHECK_CMP(o1.symbol_roles() - o2.symbol_roles());
    CHECK_CMP(o1.override_documentation_size() - o2.override_documentation_size());
    for (auto i = 0; i < o1.override_documentation_size(); i++) {
        CHECK_CMP(o1.override_documentation(i).compare(o2.override_documentation(i)));
    }
    CHECK_CMP(int32_t(o1.syntax_kind()) - int32_t(o2.syntax_kind()));
    CHECK_CMP(o1.diagnostics_size() - o2.diagnostics_size());
    for (auto i = 0; i < o1.diagnostics_size(); i++) {
        CHECK_CMP(compareDiagnostic(o1.diagnostics(i), o2.diagnostics(i)));
    }
    return 0;
}

int compareBool(bool b1, bool b2) {
    return int8_t(b1) - int8_t(b2);
}

int compareRelationship(const scip::Relationship &r1, const scip::Relationship &r2) {
    CHECK_CMP(r1.symbol().compare(r2.symbol()));
    CHECK_CMP(compareBool(r1.is_reference(), r2.is_reference()));
    CHECK_CMP(compareBool(r1.is_implementation(), r2.is_implementation()));
    CHECK_CMP(compareBool(r1.is_type_definition(), r2.is_type_definition()));
    CHECK_CMP(compareBool(r1.is_definition(), r2.is_definition()));
    return 0;
}

int compareSymbolInformation(const scip::SymbolInformation &s1, const scip::SymbolInformation &s2) {
    CHECK_CMP(s1.symbol().compare(s2.symbol()));
    CHECK_CMP(s1.documentation_size() - s2.documentation_size());
    for (auto i = 0; i < s1.documentation_size(); i++) {
        CHECK_CMP(s1.documentation(i).compare(s2.documentation(i)));
    }
    CHECK_CMP(s1.relationships_size() - s2.relationships_size());
    for (auto i = 0; i < s1.relationships_size(); i++) {
        CHECK_CMP(compareRelationship(s1.relationships(i), s2.relationships(i)))
    }
    return 0;
}
#undef CHECK_CMP
} // namespace scip