#!/usr/bin/env bash

# Approximate setup script for a Google Cloud VM.
#
# I recommend using a 8 core or 16 core CPU-optimized instance
# with Ubuntu 20.04 (there is a build issue with 22.04 for
# inscrutable reasons). 25 GB disk is more than sufficient

sudo apt update
sudo apt autoremove
sudo apt upgrade
sudo apt install wget unzip ripgrep fd-find gcc libncurses5-dev libncursesw5-dev xxd libtinfo5 make zlib1g-dev autoconf bison build-essential libssl-dev libyaml-dev libreadline6-dev libffi-dev libgdbm6 libgdbm-dev libdb-dev uuid-dev

rm -rf ~/.rbenv
git clone https://github.com/rbenv/rbenv.git ~/.rbenv --depth=1
(cd ~/.rbenv && src/configure && make -C src)
echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.bashrc
echo 'eval "$(rbenv init - bash)"' >> ~/.bashrc
source ~/.bashrc

git clone https://github.com/rbenv/ruby-build.git --depth=1
PREFIX="$HOME/.rbenv" ./ruby-build/install.sh
rm -rf ruby-build

curl -fsSL https://github.com/rbenv/rbenv-installer/raw/main/bin/rbenv-doctor | bash

MAKE_OPTS="-j $(getconf _NPROCESSORS_ONLN)" rbenv install 2.7.2

git clone https://github.com/sourcegraph/scip-ruby.git
cd scip-ruby

export JOB_NAME=test
export CACHE_DIR="$HOME/bae"
mkdir -p "$CACHE_DIR/output-bases/${JOB_NAME}" "$CACHE_DIR/build" "$CACHE_DIR/repos"
{
  echo 'common --curses=no --color=yes'
  echo "startup --output_base=$CACHE_DIR/output-bases/${JOB_NAME}"
  echo "build  --disk_cache=$CACHE_DIR/build --repository_cache=$CACHE_DIR/repos"
  echo "test   --disk_cache=$CACHE_DIR/build --repository_cache=$CACHE_DIR/repos"
  echo "build --define SCIP_RUBY_CACHE_RUBY_DIR='$PWD/.cache_ruby' --define SCIP_RUBY_RBENV_EXE='$(which rbenv)' --define EXTERNAL_GEM_EXE='$(which gem)"
} > .bazelrc.local