#!/usr/bin/env bash

set -euo pipefail

ENV_VARS=("SCIP_RUBY_CACHE_RUBY_DIR" "RUBY_VERSION_FILE" "PRISTINE_TOOLCHAIN_TGZ_PATH" "TEST_GEM_ZIP" "TEST_GEM_ZIP_PREFIX" "TEST_GEM_SUBDIR" "OUT_MODIFIED_TOOLCHAIN_TGZ_PATH" "OUT_GEM_WITH_VENDOR_TGZ_PATH")
for ENV_VAR in "${ENV_VARS[@]}"; do
  if eval "[ -z \"$(printf '${%s:-}' $ENV_VAR)\" ]"; then
    echo "Missing definition for $ENV_VAR environment variable"
    exit 1
  fi
done

SCIP_RUBY_SPECIFIC_RUBY_ROOT="$SCIP_RUBY_CACHE_RUBY_DIR"
if [ -d "$SCIP_RUBY_SPECIFIC_RUBY_ROOT/versions" ]; then
  # rbenv creates an extra versions subdirectory, which doesn't apply in CI.
  # This is to avoid finding the 'gem' from shims/
  SCIP_RUBY_SPECIFIC_RUBY_ROOT="$SCIP_RUBY_SPECIFIC_RUBY_ROOT/versions"
fi
SCIP_RUBY_SPECIFIC_RUBY_ROOT="$SCIP_RUBY_SPECIFIC_RUBY_ROOT/$(< "$RUBY_VERSION_FILE")"

rm -rf "$SCIP_RUBY_CACHE_RUBY_DIR"
mkdir -p "$SCIP_RUBY_CACHE_RUBY_DIR"
tar -xzf "$PRISTINE_TOOLCHAIN_TGZ_PATH" -C "$SCIP_RUBY_CACHE_RUBY_DIR"

GEM_EXE="$(find "$SCIP_RUBY_SPECIFIC_RUBY_ROOT" -name 'gem' -type f)"
BUNDLE_EXE="$(dirname "$GEM_EXE")/bundle"

rm -rf "$TEST_GEM_ZIP_PREFIX"
unzip -q "$TEST_GEM_ZIP"

# Is there a more reliable way to get the version? 😬
_BUNDLER_VERSION="$(tail -n 1 < $TEST_GEM_ZIP_PREFIX/$TEST_GEM_SUBDIR/Gemfile.lock)"
_BUNDLER_VERSION="${_BUNDLER_VERSION// /}"
echo "BUNDLER_VERSION = $_BUNDLER_VERSION"
"$GEM_EXE" install "bundler:$_BUNDLER_VERSION"

pushd "$TEST_GEM_ZIP_PREFIX/$TEST_GEM_SUBDIR"
git init -q
git add .
GIT_AUTHOR_DATE=1993-05-16T15:04:05Z GIT_COMMITTER_DATE=1993-05-16T15:04:05Z \
  git -c user.name='iu' -c user.email='i@u' commit -a -m '(^_^)' --quiet
set +e

if ! "$BUNDLE_EXE" cache --quiet 2> >(tee stderr.log >&2); then
  err="$(< stderr.log)"
  while IFS= read -r line; do
    if [[ "$line" == *"lib/ruby/gems"*"mkmf.log" ]]; then
      echo "----------- Printing likely bad mkmf.log -----------"
      cat "$line"
      echo "----------------------------------------------------"
    fi
  done <<< "$err"
  exit 1
fi
set -e
git restore .
popd

tar -czf "$OUT_MODIFIED_TOOLCHAIN_TGZ_PATH" -C "$SCIP_RUBY_CACHE_RUBY_DIR" .
tar -czf "$OUT_GEM_WITH_VENDOR_TGZ_PATH" -C "$TEST_GEM_ZIP_PREFIX" .
