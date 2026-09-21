#!/bin/bash
set -euo pipefail

cd "${TEST_SRCDIR}/${TEST_WORKSPACE}"
indexer="$PWD/main/scip-ruby"
scratch=$(mktemp -d "${TEST_TMPDIR}/scip-runtime.XXXXXX")
trap 'rm -rf "$scratch"' EXIT
cd "$scratch"

cat > input.rb <<'RUBY'
# typed: true
module T
  module Helpers
    def self.resolved_module
      Module
    end
  end
end
RUBY

pin() {
    printf 'GEM\n  specs:\n    sorbet-runtime (%s)\n' "$1" > Gemfile.lock
}
index() {
    "$indexer" --no-config --silence-dev-message --max-threads=1 --unquiet \
        --gem-metadata=runtime-test@0 --cache-dir="$2" --index-file="$1" input.rb
}

pin 0.5.11435
index old.scip shared
pin 0.6.12698
index current-after-old.scip shared
index current-fresh.scip current-fresh
cmp current-after-old.scip current-fresh.scip
if cmp -s old.scip current-fresh.scip; then
    echo 'Expected different Module targets across the runtime boundary' >&2
    exit 1
fi
pin 0.5.11435
index old-again.scip shared
cmp old.scip old-again.scip
rm Gemfile.lock
index unknown-after-old.scip shared
cmp unknown-after-old.scip current-fresh.scip
