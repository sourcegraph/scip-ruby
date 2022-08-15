#!/usr/bin/env bash

set -euo pipefail

CACHE_ROOT="$HOME/bazelcache"
mkdir -p "$CACHE_ROOT/output-base" "$CACHE_ROOT/build" "$CACHE_ROOT/repos"

os="$(uname -s)"
if [ "$os" == "Linux" ]; then
  SETUP_RUBY_TOOLS_DIR="/opt/hostedtoolcache/Ruby"
elif [ "$os" == "Darwin" ]; then
  SETUP_RUBY_TOOLS_DIR="/Users/runner/hostedtoolcache/Ruby"
else
  echo "Check https://github.com/ruby/setup-ruby#using-self-hosted-runners and note setup-ruby's cache directory here"
  exit 1
fi

{
  echo "common --curses=no --color=yes "
  echo "startup --output_base=$CACHE_ROOT/output-base"
  echo "build  --disk_cache=$CACHE_ROOT/build --repository_cache=$CACHE_ROOT/repos"
  echo "build --define SCIP_RUBY_CACHE_RUBY_DIR=$SETUP_RUBY_TOOLS_DIR --define SCIP_RUBY_RBENV_EXE=RUNNING_IN_CI_RBENV_NOT_NEEDED --define EXTERNAL_GEM_EXE='$(which gem)'"
  if [ -n "${VERSION:-}" ]; then
    echo "build --//gems/scip-ruby:version=$VERSION"
  fi
  echo "test   --disk_cache=$CACHE_ROOT/build --repository_cache=$CACHE_ROOT/repos --test_output=errors"
} > .bazelrc.local

# Install Bazel and print version
./bazel version
