#!/usr/bin/env bash

# See also: NOTE[repo-test-structure]

set -eu

ENV_VARS=("PRISTINE_TOOLCHAIN_TGZ_PATH" "SCIP_RUBY_CACHE_RUBY_DIR" "RUBY_VERSION_FILE" "VERSION" "NAME" "SCIP_RUBY_BINARY" "OUT_DIR")
for ENV_VAR in "${ENV_VARS[@]}"; do
  if eval "[ -z \"$(printf '${%s:-}' $ENV_VAR)\" ]"; then
    echo "Missing definition for $ENV_VAR environment variable"
    echo 'This is likely a bug in the bazel code running the build'
    exit 1
  fi
done

cp -R gems/scip-ruby out
mkdir -p out/native
cp "$SCIP_RUBY_BINARY" out/native/scip-ruby

GEMSPEC="$NAME.gemspec"

cleanup() {
  rm -rf out
}
trap cleanup EXIT

rm -rf "$SCIP_RUBY_CACHE_RUBY_DIR"
mkdir -p "$SCIP_RUBY_CACHE_RUBY_DIR"
tar -xzf "$PRISTINE_TOOLCHAIN_TGZ_PATH" -C "$SCIP_RUBY_CACHE_RUBY_DIR"

SCIP_RUBY_SPECIFIC_RUBY_ROOT="$SCIP_RUBY_CACHE_RUBY_DIR"
if [ -d "$SCIP_RUBY_SPECIFIC_RUBY_ROOT/versions" ]; then
  # rbenv creates an extra versions subdirectory, which doesn't apply in CI.
  # This is to avoid finding the 'gem' from shims/
  SCIP_RUBY_SPECIFIC_RUBY_ROOT="$SCIP_RUBY_SPECIFIC_RUBY_ROOT/versions"
fi
SCIP_RUBY_SPECIFIC_RUBY_ROOT="$SCIP_RUBY_SPECIFIC_RUBY_ROOT/$(< "$RUBY_VERSION_FILE")"

GEM_EXE="$(find "$SCIP_RUBY_SPECIFIC_RUBY_ROOT" -name 'gem' -type f)"
file "$GEM_EXE"

pushd out

cat scip-ruby.template.gemspec \
  | sed -e "s/VERSION_PLACEHOLDER/$VERSION/" -e "s/NAME_PLACEHOLDER/$NAME/" \
  > "$GEMSPEC"

if [ "$(uname -s)" == "Darwin" ]; then
  # Darwin 20 ~ macOS 11 (Big Sur) was released in mid-2020.
  # We can publish older releases if someone asks for them.
  DARWIN_VERSIONS=($DARWIN_VERSIONS)
  for i in "${DARWIN_VERSIONS[@]}"; do
    sed -i.bak "s/Gem::Platform::CURRENT/'universal-darwin-$i'/" "$GEMSPEC"
    "$GEM_EXE" build "$GEMSPEC"
    mv "$GEMSPEC.bak" "$GEMSPEC"
  done
else
  "$GEM_EXE" build "$GEMSPEC"
fi

popd

mv out/*.gem "$OUT_DIR/"
