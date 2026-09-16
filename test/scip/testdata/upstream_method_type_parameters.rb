# typed: true
# check-errors: true

class GenericMethods
  extend T::Sig

  sig { type_parameters(:U).params(value: T.type_parameter(:U)).returns(T.type_parameter(:U)) }
  def identity(value)
    result = T.let(value, T.type_parameter(:U))
    1.times { result = T.let(value, T.type_parameter(:U)) }
    result
  end

  sig do
    type_parameters(:U, :V)
      .params(first: T.type_parameter(:U), second: T.type_parameter(:V))
      .returns(T.type_parameter(:V))
  end
  def second(first, second)
    second
  end

  sig { type_parameters(:Unused).void }
  def unused; end

  sig { type_parameters(:"U").params(value: T.type_parameter(:'U')).returns(T.type_parameter(:"U")) }
  def self.identity(value)
    T.let(value, T.type_parameter(:'U'))
  end
end

class OtherGenericMethods
  extend T::Sig

  sig { type_parameters(:U).params(value: T.type_parameter(:U)).returns(T.type_parameter(:U)) }
  def identity(value)
    value
  end
end

GenericMethods.new.identity("text").upcase
GenericMethods.new.second(1, "text").upcase
GenericMethods.identity(1).abs
OtherGenericMethods.new.identity("text").upcase
