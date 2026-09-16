# typed: true
# check-errors: true
# Adapted from test/testdata/lsp/type_member_references.rb.

class Upper
  extend T::Sig, T::Generic, T::Helpers
  abstract!
  X = type_member { {upper: Numeric} }

  sig { abstract.returns(X) }
  def value; end
end

class Fixed
  extend T::Sig, T::Generic
  X = type_member { {fixed: Integer} }

  sig { returns(X) }
  def value
    1
  end
end

class Lower
  extend T::Sig, T::Generic
  X = type_member { {lower: Integer} }

  sig { params(x: X).returns(X) }
  def identity(x)
    T.let(x, X)
  end
end

class Template
  extend T::Sig, T::Generic
  X = type_template { {fixed: String} }

  sig { returns(X) }
  def self.value
    "text"
  end
end

class Plain
  extend T::Sig, T::Generic
  X = type_member

  sig { params(x: X).returns(X) }
  def identity(x)
    x
  end
end

Fixed.new.value.abs
Lower[Numeric].new.identity(1).abs
Template.value.upcase
Plain[String].new.identity("text").upcase
