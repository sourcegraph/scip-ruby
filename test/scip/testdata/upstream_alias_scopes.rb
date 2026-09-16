# typed: true
# Adapted from test/testdata/lsp/alias_scopes.rb.

class Bar
  Cnst = 1
end

module Foo
  Alias = Bar

  module Other
    Alias = Bar
  end

  OtherAlias = Other
  DeepAlias = OtherAlias::Alias
end

module Foo
  Alias::Cnst
  DeepAlias::Cnst
end
