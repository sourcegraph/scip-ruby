#!/usr/bin/env bash

set -euo pipefail
set -x

while [[ $# -gt 0 ]]; do
  case $1 in
    --gem-name)
      GEM_NAME="$2"
      shift # past argument
      shift # past value
      ;;
    --gem-version)
      GEM_VERSION="$2"
      shift # past argument
      shift # past value
      ;;
    --is-package)
      IS_PACKAGE_REPO="YES"
      shift # past argument
  esac
done

initialize_sorbet() {
  echo "group :development do
  gem 'tapioca', require: false
end" >> Gemfile

  bundle install
  bundle exec tapioca init
}

initialize_package() {
  gem install "$GEM_NAME" -v "$GEM_VERSION"

  # Assume that current directory is the gem root.
  # `gem lock` will emit the current gem too, but we don't want that,
  # as the root already has the source code.

  # FIXME: Allow passing in gem source from the outside
  # Blocked on https://github.com/sourcegraph/sourcegraph/issues/44204
  #
  # Not entirely sure in Bundler respects sources in .gemrc
  # or not, because this issue was closed:
  #   https://github.com/rubygems/bundler/issues/6633
  # So we may need to modify both .gemrc and Gemfile.
  echo "source 'https://rubygems.org'" > Gemfile
 
  gem lock "$GEM_NAME-$GEM_VERSION" \
   | grep -v "gem '$GEM_NAME'" \
   >> Gemfile

  initialize_sorbet
}

check_index_and_exit() {
  if [ -f "index.scip" ]; then
    echo "Emitted index.scip successfully."
    exit 0
  else
    echo "Failed to emit index.scip."
    exit 1
  fi
}

# FIXME: Modify the global gem sources list to use the configured host
# in Sourcegraph rather than https://rubygems.org

# Created by Sourcegraph to indicate package repos.
if [ -f "rubygems-metadata.yml" ]; then
  IS_PACKAGE_REPO="YES"
fi

if [ -n "${IS_PACKAGE_REPO:-}" ]; then
  if [ -z "${GEM_NAME:-}" ]; then
    GEM_NAME="$(grep 'name:' rubygems-metadata.yml | head -n 1 | sed -e 's/name: //')"
  fi
  if [ -z "${GEM_VERSION:-}" ]; then
    GEM_VERSION="$(grep '  version:' rubygems-metadata.yml | head -n 1 | sed -e 's/  version: //')"
  fi
  set +e
  initialize_package
  scip-ruby . --gem-metadata "$GEM_NAME@$GEM_VERSION"
  check_index_and_exit
fi

if [ -f "sorbet/config" ]; then
  set +e
  if [ -n "${GEM_NAME:-}" ] && [ -n "${GEM_VERSION:-}" ]; then
    scip-ruby --gem-metadata "$GEM_NAME@$GEM_VERSION"
  else
    scip-ruby
  fi
  check_index_and_exit
fi

set +e
initialize_sorbet
# Can remove this once the 'default to using .' problem in
# https://github.com/sourcegraph/scip-ruby/issues/133 is fixed.
if [ -n "${GEM_NAME:-}" ] && [ -n "${GEM_VERSION:-}" ]; then
  scip-ruby . --gem-metadata "$GEM_NAME@$GEM_VERSION"
else
  scip-ruby .
fi
check_index_and_exit
