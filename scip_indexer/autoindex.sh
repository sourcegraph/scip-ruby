#!/usr/bin/env bash

set -euo pipefail

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
  gem install "$GEM_NAME" -v "$GEM_VERSION"

  # Assume that current directory is the gem root
  # gem lock will emit the current gem too, but we don't want
  # that, as the root already has the source code
  # FIXME: Allow passing in gem source from the outside
  gem lock "$GEM_NAME-$GEM_VERSION" \
   | grep -v "gem '$GEM_NAME'" \
   | sed -E 's|^gem|source "https://rubygems.org"\ngem|' \
   > Gemfile

  echo "group :development do
  gem 'tapioca', require: false
end" >> Gemfile

  bundle install
  bundle exec tapioca init
}

# FIXME: Modify the global gem sources list to use the configured host
# in Sourcegraph rather than https://rubygems.org

# Created by Sourcegraph to indicate package repos.
if [ -f "rubygems-metadata.yml" ]; then
  IS_PACKAGE_REPO="YES"
fi

if [ -n "$IS_PACKAGE_REPO" ] && [ -n "${GEM_NAME:-}" ] && [ -n "${GEM_VERSION:-}" ]; then
  initialize_sorbet
  set +e
  scip-ruby . --gem-metadata "$GEM_NAME@$GEM_VERSION"
  exit 0
fi

if [ -f "sorbet/config" ]; then
  set +e
  if [ -n "$GEM_NAME" ] && [ -n "$GEM_VERSION" ]; then
    scip-ruby --gem-metadata "$GEM_NAME@$GEM_VERSION"
  else
    scip-ruby
  fi
  exit 0
fi


set +e
# Can remove this once the 'default to using .' problem in
# https://github.com/sourcegraph/scip-ruby/issues/133 is fixed.
if [ -n "$GEM_NAME" ] && [ -n "$GEM_VERSION" ]; then
  scip-ruby . --gem-metadata "$GEM_NAME@$GEM_VERSION"
else
  scip-ruby .
fi
