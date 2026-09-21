#!/bin/bash
set -euo pipefail

cd "${TEST_SRCDIR}/${TEST_WORKSPACE}"
scratch=$(mktemp -d "${TEST_TMPDIR}/scip-cache.XXXXXX")
trap 'rm -rf "$scratch"' EXIT
inputs=(test/scip/cache_test.rb)
flags=(--no-config --silence-dev-message --max-threads=1)

# Ordinary Sorbet and SCIP use different rewrites for the same source text.
main/sorbet "${flags[@]}" --cache-dir="$scratch/shared" "${inputs[@]}"
main/scip-ruby "${flags[@]}" --gem-metadata=cache-test@0 --cache-dir="$scratch/shared" \
    --index-file="$scratch/after-sorbet.scip" "${inputs[@]}"
main/scip-ruby "${flags[@]}" --gem-metadata=cache-test@0 --cache-dir="$scratch/fresh" \
    --index-file="$scratch/fresh.scip" "${inputs[@]}"
main/scip-ruby "${flags[@]}" --gem-metadata=cache-test@0 --cache-dir="$scratch/shared" \
    --index-file="$scratch/warm.scip" "${inputs[@]}"

cmp "$scratch/after-sorbet.scip" "$scratch/fresh.scip"
cmp "$scratch/warm.scip" "$scratch/fresh.scip"
