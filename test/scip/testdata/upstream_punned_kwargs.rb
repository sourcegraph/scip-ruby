# typed: true
# options: showDocs
# Adapted from test/testdata/lsp/punned_kwargs.rb.

extend T::Sig

sig { params(xyz: String).returns(String) }
def takes_string(xyz:)
  xyz
end

xyz = "hello"
takes_string(xyz:)
takes_string(xyz: xyz)
