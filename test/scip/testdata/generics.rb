# typed: true

# Exercises the TypeArgument / TypeMember descriptor branches in
# scip_indexer/SCIPSymbolRef.cc symbolForExpr (Descriptor::TypeParameter,
# Descriptor::Type).

class GenericBox
  extend T::Sig
  extend T::Generic

  Elem = type_member

  sig { params(x: Elem).void }
  def initialize(x)
    @x = x
  end

  sig { returns(Elem) }
  def get
    @x
  end
end

module MyGenericMixin
  extend T::Generic

  Item = type_member
end

class WithTypeTemplate
  extend T::Generic

  Tag = type_template
end

class WithTypeParameters
  extend T::Sig

  sig { type_parameters(:U).params(x: T.type_parameter(:U)).returns(T.type_parameter(:U)) }
  def identity(x)
    x
  end
end

def use_generics
  box = GenericBox.new(1)
  _ = box.get
  _ = WithTypeParameters.new.identity(42)
  return
end
