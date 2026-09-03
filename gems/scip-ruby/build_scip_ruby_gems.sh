#!/usr/bin/env bash

# See also: NOTE[repo-test-structure]

set -eu

ENV_VARS=("EXTERNAL_GEM_EXE" "NAME" "VERSION" "DARWIN_VERSIONS" "SCIP_RUBY_BINARY" "OUT_DIR")
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

if [ ! -f "$EXTERNAL_GEM_EXE" ]; then
  echo "error: Didn't find 'gem' executable at $EXTERNAL_GEM_EXE"
  exit 1
fi

if [ -n "${LLVM_LIBUNWIND:-}" ]; then
  if [ ! -f "$LLVM_LIBUNWIND" ] && [[ "$LLVM_LIBUNWIND" == ../* ]]; then
    LLVM_LIBUNWIND="../../external/${LLVM_LIBUNWIND#../}"
  fi
  case "$LLVM_LIBUNWIND" in
    /*) ;;
    *) LLVM_LIBUNWIND="$PWD/$LLVM_LIBUNWIND" ;;
  esac
fi

GEM_EXE="$EXTERNAL_GEM_EXE"
file "$GEM_EXE"

pushd out

cat scip-ruby.template.gemspec \
  | sed -e "s/VERSION_PLACEHOLDER/$VERSION/" -e "s/NAME_PLACEHOLDER/$NAME/" \
  > "$GEMSPEC"

if [ "$(uname -s)" == "Darwin" ]; then
  if [ -z "${LLVM_LIBUNWIND:-}" ]; then
    echo "Missing LLVM_LIBUNWIND for Darwin gem build"
    exit 1
  fi
  cp -L "$LLVM_LIBUNWIND" native/libunwind.1.dylib
  install_name_tool -add_rpath @executable_path native/scip-ruby
  sed -i.bak "s|\['native/scip-ruby'\]|['native/scip-ruby', 'native/libunwind.1.dylib']|" "$GEMSPEC"
  rm "$GEMSPEC.bak"

  # Darwin 22 ~ macOS 13 (Ventura) was released in late-2022.
  # We can publish older releases if someone asks for them.
  if [ "${CURRENT_PLATFORM_GEM_OUT:-}" ]; then
    DARWIN_VERSIONS=("$(uname -r | cut -d. -f1)")
  else
    DARWIN_VERSIONS=($DARWIN_VERSIONS)
  fi
  for i in "${DARWIN_VERSIONS[@]}"; do
    sed -i.bak "s/Gem::Platform::CURRENT/'arm64-darwin-$i'/" "$GEMSPEC"
    "$GEM_EXE" build "$GEMSPEC"
    mv "$GEMSPEC.bak" "$GEMSPEC"
  done
else
  "$GEM_EXE" build "$GEMSPEC"
fi

popd

if [ "${CURRENT_PLATFORM_GEM_OUT:-}" ]; then
  gems=(out/*.gem)
  if [ "${#gems[@]}" -ne 1 ]; then
    echo "Expected one current-platform gem, found ${#gems[@]}"
    exit 1
  fi
  mv "${gems[0]}" "$CURRENT_PLATFORM_GEM_OUT"
else
  mv out/*.gem "$OUT_DIR/"
fi
