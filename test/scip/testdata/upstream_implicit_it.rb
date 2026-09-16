# typed: true
# check-errors: true
# Adapted from test/testdata/lsp/hover_it_param.rb and
# test/testdata/resolver/it_param_method_vs_local.rb / it_param_method_vs_param.rb.

[1, 2].map { it + it }
["a", "b"].map { it.upcase }

[[1, 2], [3, 4]].map do
  it.map { it + it }
  it.length
end

class ImplicitItPrecedence
  extend T::Sig

  sig { params(value: Integer).returns(String) }
  def it(value)
    value.to_s
  end

  def implicit_parameter
    [1, 2].map { it + it }
    [1, 2].map { it(it).upcase }
    [1, 2].map { self.it(it).upcase }
    it(1).upcase
  end

  def existing_local
    it = "outer"
    [1, 2].map { it.upcase }
    [1, 2].map { it(it.length).upcase }
    it.downcase
  end
end
