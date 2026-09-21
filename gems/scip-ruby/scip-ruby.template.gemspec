# See build-gems.sh for how this file is used.

Gem::Specification.new do |spec|
  spec.name        = 'NAME_PLACEHOLDER'
  spec.version     = 'VERSION_PLACEHOLDER'
  spec.summary     = 'A SCIP indexer for Ruby'
  spec.description = 'Wrapper for the scip-ruby binary'
  spec.authors     = ['Sourcegraph']
  spec.email       = 'code-intel@sourcegraph.com'
  spec.files       = ['native/scip-ruby'] # Populated by build-gems.sh
  spec.executables = ['scip-ruby'] # Wrapper script
  spec.license     = 'Apache-2.0'
  spec.homepage    = 'https://github.com/sourcegraph/scip-ruby'
  spec.metadata = {
    "source_code_uri" => "https://github.com/sourcegraph/scip-ruby"
  }

  # bin/scip-ruby is a native binary, so we are platform dependent
  spec.platform = Gem::Platform::CURRENT

  spec.required_ruby_version = ['>= 2.3.0']
end
