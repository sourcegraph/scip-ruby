# typed: true
# options: showDocs
# check-errors: true

class LegacySingleArgumentUnion
  extend T::Sig
  Name = T.type_alias { T.any(String, Symbol) }
  Normalize = T.let(T.unsafe(nil), T.proc.params(name: T.any(Name)).returns(Symbol)) # error: Not enough arguments provided for method `T.any`. Expected: `2+`, got: `1`

  sig { params(value: T.any(String)).returns(String) } # error: Not enough arguments provided for method `T.any`. Expected: `2+`, got: `1`
  def normalize(value)
    value.upcase
  end

  # Invalid empty unions still have no recoverable type.
  sig { params(value: T.any).void } # error: Not enough arguments provided for method `T.any`. Expected: `2+`, got: `0`
  def empty(value)
    value.upcase
  end
end
