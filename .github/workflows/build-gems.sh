#!/usr/bin/env bash

# For local testing, do a build and invoke this script from the root
# of the repo with:
#
# NAME="scip-ruby-debug" VERSION="0.0.0" .github/workflows/build-gems.sh

# Based on build-static-release.sh

set -eux

if [ -z "${VERSION:-}" ]; then
  echo 'Missing value for $VERSION environment variable'
  exit 1
fi
if [ -z "${NAME:-}" ]; then
  echo 'Missing value for $NAME environment variable'
  exit 1
fi

mkdir -p gems/scip-ruby/bin
cp bazel-bin/main/scip-ruby gems/scip-ruby/bin/scip-ruby
GEMSPEC="$NAME.gemspec"
cleanup() {
  rm -rf gems/scip-ruby/bin
  rm -rf "gems/scip-ruby/$GEMSPEC"
}
trap cleanup EXIT

pushd gems/scip-ruby

cat scip-ruby.template.gemspec \
  | sed -e "s/VERSION_PLACEHOLDER/$VERSION/" -e "s/NAME_PLACEHOLDER/$NAME/" \
  > "$GEMSPEC"

if [ "$(uname -s)" == "Darwin" ]; then
  # Darwin 20 ~ macOS 11 (Big Sur) was released in mid-2020.
  # We can publish older releases if someone asks for them.
  for i in {20..22}; do
    sed -i.bak "s/Gem::Platform::CURRENT/'universal-darwin-$i'/" "$GEMSPEC"
    gem build "$GEMSPEC"
    mv "$GEMSPEC.bak" "$GEMSPEC"
  done
else
  gem build "$GEMSPEC"
fi

popd
