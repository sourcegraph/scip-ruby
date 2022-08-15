# Design Decisions

## Repo tests

<!-- DEF NOTE[repo-test-structure] -->

The repo tests have a couple of unusual things:
#. Tests are broken up into 3 stages,
   instead of being a simple script that does clone
   + apply patch + invoke dev tool (`scip-ruby`).
#. There is "manual" caching going on for the intermediate results
   of these steps. The cache cannot be used in parallel; repo tests run serially.

I'll cover each of these one-by-one.

Some constraints to keep in mind while reading the sections below:
#. We want to run tests using as close to "real-world" tools (such as Bundler)
   as possible instead of trying to mimic what they do.
#. We want to cache intermediate results as much as possible,
   as many steps in Ruby installation + Gem installation are slow.
#. Tests should hopefully run reasonably quickly, especially if you only
   modify the indexer (most common situation).
#. Tests should be isolated from each other. We don't one test to "install"
   `scip-ruby` and have that be visible to another test.

Before going into details about the caching, first let's cover
an outline of the 3 stages.
### 3 stages of repo tests

#. Create a standalone ruby installation: This is cached
   and the installation is blown away.
#. Test prep: This step involves installing the dependencies of the gem,
   including any custom bundler version it may require.
   The pristine toolchain from the first step is extracted
   and we run `bundle cache`.
   After this is done, the _entire_ Ruby toolchain is cached again
   (because it will be have been modified by `bundle cache`).
   The modified source tree is also cached (I tried `--frozen` earlier but
   ran into some error with it that I didn't have time to look into).
#. Index: This step reuses the two caches from the previous step,
   applies a patch, copies the `scip-ruby` gem into the `vendor/cache`
   directory, runs `bundle install --local` (so nothing should be
   fetched from the internet). Now, everything is in a state which mostly
   mimics what a user would have. Then we invoke `scip-ruby` normally.

Intermediate results use tarballs for caching directory trees instead of copying
directories because it seemed much simpler to deal with a tarball in Bazel.

Why do we go through all this trouble to cache things "manually"?
### Manual caching

Here are some obstacles the caching system needs to overcome.

* Ruby installation is [path-dependent](https://github.com/ruby/setup-ruby#using-self-hosted-runners).
* Ruby installation is relatively slow as it builds everything from source:
  it takes a few minutes even on a Macbook Pro.
  Installing it per-test would be too time-consuming.

These two factors together imply that we should cache a Ruby installation
inside a stable directory, not a temporary test directory.

Additionally, we only want one Ruby toolchain cache; to ensure test isolation,
we run them in serial on the same directory (a GIL for the test suite).

* We want to ensure reproducibility, and not mess with the global environment.

To achieve this, we delete the toolchain directory at the start of a test,
and restore it from the cache in the 'Test prep' step.

### Bonus: Bundler weirdness

If you run `bundle install --local` for a test gem X,
after copying an updated `scip-ruby` gem (same version, new checksum)
into X's `vendor/cache` directory,
you would naively expect `bundle` to re-install the updated `scip-ruby` gem.
(install = copy/setup stuff in toolchain-adjacent directories)
But `bundle` doesn't actually do that. 🙈