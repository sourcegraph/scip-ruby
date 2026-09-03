#!/usr/bin/env bash

set -euo pipefail

# Make sure the caller told us where to find every file this test needs.
required_env=("RUBY_TGZ" "RUBY_VERSION_FILE" "SAMPLE_RB" "SCIP_RUBY_GEM")
for env_var in "${required_env[@]}"; do
  if [[ -z "${!env_var:-}" ]]; then
    echo "Missing definition for $env_var environment variable"
    exit 1
  fi
done

# Turn a path into a full path so later directory changes do not break it.
abspath() {
  local path="$1"
  if [[ "$path" = /* ]]; then
    printf '%s\n' "$path"
  else
    printf '%s/%s\n' "$PWD" "$path"
  fi
}

# Save full paths for each input before the test moves into its work directory.
RUBY_TGZ="$(abspath "$RUBY_TGZ")"
RUBY_VERSION_FILE="$(abspath "$RUBY_VERSION_FILE")"
SAMPLE_RB="$(abspath "$SAMPLE_RB")"
SCIP_RUBY_GEM="$(abspath "$SCIP_RUBY_GEM")"

# Create a clean place to unpack Ruby and build a small test project.
workdir="${TEST_TMPDIR:-$(mktemp -d)}/scip-ruby-packaging-test"
rm -rf "$workdir"
mkdir -p "$workdir/ruby" "$workdir/project/lib" "$workdir/project/vendor/cache"

# Unpack the Ruby archive that the packaging test should use.
tar -xzf "$RUBY_TGZ" -C "$workdir/ruby"

# Find the unpacked Ruby directory. The archive is expected to use one stable
# directory layout no matter where the Ruby files originally came from.
ruby_root="$workdir/ruby/versions/$(< "$RUBY_VERSION_FILE")"

# Point to the Ruby and Bundler programs inside the unpacked Ruby copy.
ruby_exe="$ruby_root/bin/ruby"
bundle_exe="$ruby_root/bin/bundle"

# Fail early if the Ruby archive did not contain the programs we need.
for exe in "$ruby_exe" "$bundle_exe"; do
  if [[ ! -x "$exe" ]]; then
    echo "Expected executable at $exe"
    exit 1
  fi
done

# Read the packaged gem's name and version so the test project can install it.
gem_info="$(
  "$ruby_exe" -rrubygems/package -e '
    spec = Gem::Package.new(ARGV.fetch(0)).spec
    puts spec.name
    puts spec.version
    puts spec.full_name
  ' "$SCIP_RUBY_GEM"
)"
gem_name="$(printf '%s\n' "$gem_info" | sed -n '1p')"
gem_version="$(printf '%s\n' "$gem_info" | sed -n '2p')"
gem_full_name="$(printf '%s\n' "$gem_info" | sed -n '3p')"

# Stop if the gem file could not be read correctly.
if [[ -z "$gem_name" || -z "$gem_version" || -z "$gem_full_name" ]]; then
  echo "Could not read gem metadata from $SCIP_RUBY_GEM"
  exit 1
fi

# Put the packaged gem and sample Ruby file into the temporary test project.
cp "$SCIP_RUBY_GEM" "$workdir/project/vendor/cache/$gem_full_name.gem"
cp "$SAMPLE_RB" "$workdir/project/lib/sample.rb"

# Create a Gemfile that asks for exactly the packaged gem under test.
cat > "$workdir/project/Gemfile" <<EOF
source "https://rubygems.org"
gem "$gem_name", "$gem_version"
EOF

# Install the packaged gem from the local cache, then run it against sample.rb.
(
  # Work inside the temporary project so Bundler sees the Gemfile created above.
  cd "$workdir/project"

  # Keep all Ruby and Bundler state inside the temporary directory. This prevents
  # the test from reading or writing gems, config files, or home-directory files
  # from the machine running the test.
  export BUNDLE_APP_CONFIG="$workdir/bundle_app_config"
  export BUNDLE_DISABLE_SHARED_GEMS=true
  export BUNDLE_PATH="$workdir/bundle"
  export GEM_HOME="$workdir/gem_home"
  export GEM_PATH="$workdir/gem_home"
  export HOME="$workdir/home"
  export SORBET_SILENCE_DEV_MESSAGE=1

  # Install only from vendor/cache so the test proves the packaged gem can be
  # installed without fetching a different copy from the network.
  "$bundle_exe" install --local --quiet

  # Run the installed command against a tiny Ruby file. If the executable, gem
  # contents, or runtime dependencies are broken, this command should fail.
  "$bundle_exe" exec scip-ruby --index-file "$workdir/index.scip" --gem-metadata "packaging-test@0.0.0" lib/sample.rb
)

# Make sure scip-ruby wrote an index file and that it is not empty.
if [[ ! -s "$workdir/index.scip" ]]; then
  echo "Expected packaged scip-ruby to create a non-empty index at $workdir/index.scip"
  exit 1
fi

# Print a short success message with the size of the generated index.
index_size="$(wc -c < "$workdir/index.scip")"
echo "Packaged gem $gem_full_name created non-empty SCIP index at $workdir/index.scip ($index_size bytes)"
