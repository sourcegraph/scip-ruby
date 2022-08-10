# scip-ruby

Experimental [SCIP](https://github.com/sourcegraph/scip) indexer for Ruby.

If you have any questions, bug reports, feature requests or feedback,
please [file an issue](https://github.com/sourcegraph/scip-ruby/issues).

## Supported Configurations

scip-ruby piggybacks on top of
the [Sorbet](https://github.com/sorbet/sorbet) type-checker.
If you use Sorbet in your project, follow the instructions below.

Projects which do not use Sorbet are not supported.

Supported platforms:
- x86_64 Linux
- x86_64 macOS
- arm64 macOS (via Rosetta)

<!-- Temporarily comment out below as we haven't published the Gem yet. -->
<!-- We also need to get the Gem detection working with tests. -->
<!--

## Quick Start

This section covers the easiest way to use `scip-ruby`: as a gem.
The gem will install the platform-specific `scip-ruby` binary
lazily on first use and use it for indexing.

Alternately, you can follow the instructions under
[Install and Index](#install-and-index).

### First-time setup

If you have a `.gemspec` file, use `add_development_dependency`:

```
Gem::Specification.new do |spec|
  # ... other stuff ...
  spec.add_development_dependency("scip-ruby")
end
```

Otherwise, add this line to your `Gemfile`:

```
gem 'scip-ruby', require: false, :group => :development
```

### Generate an index

If you have a `.gemspec` file, run:

```
bundle exec scip-ruby
```

Otherwise, explicitly specify your Gem's name and current version:

```
# Uses the latest tag as the version
bundle exec scip-ruby --gem-metadata "my-gem-name@$(git describe --tags --abbrev=0)"
```

If you don't use release tags, you can use a Git SHA instead.

The generated index (named `index.scip` by default) can be uploaded
to a Sourcegraph instance using the [Sourcegraph CLI](https://github.com/sourcegraph/src-cli).

-->

## Install and Index

You can download a
[release binary](https://github.com/sourcegraph/scip-ruby/releases)
and run it directly, similar to invoking Sorbet.

```
OS="$(uname -s | tr '[:upper:]' '[:lower:]')" \
RELEASE_URL="https://github.com/sourcegraph/scip-ruby/releases/latest/download" \
curl -L "$RELEASE_URL/scip-ruby-x86_64-$OS" -o scip-ruby && chmod +x scip-ruby

chmod +x scip-ruby

# If using in CI with 'set -e', make sure to wrap the
# scip-ruby invocation in 'set +e' followed by 'set -e'
# so that indexing failures are non-blocking.
./scip-ruby --index-file index.scip --gem-metadata "my-gem-name@vM.N.P"
```

The generated index can be uploaded to a Sourcegraph instance
using the [Sourcegraph CLI](https://github.com/sourcegraph/src-cli).

## Contributing

See the [Contributing docs](./scip-ruby-CONTRIBUTING.md).
