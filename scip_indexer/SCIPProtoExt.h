#ifndef SORBET_SCIP_PROTO_EXT
#define SORBET_SCIP_PROTO_EXT

#include "proto/SCIP.pb.h"

namespace scip {
int compareOccurrence(const scip::Occurrence &o1, const scip::Occurrence &o2);

int compareRelationship(const scip::Relationship &r1, const scip::Relationship &r2);

int compareSymbolInformation(const scip::SymbolInformation &s1, const scip::SymbolInformation &s2);
} // namespace scip

#endif // SORBET_SCIP_PROTO_EXT