# typed: true

# Synthetic error-recovery case: including a class is invalid Ruby, but recovery
# can retain Object in a module's ancestry. Indexing must not require the
# experimental requires_ancestor feature for Object#class or #singleton_class.
module ObjectAncestor
  include Object

  def marker
    :sample
  end
end

module IndirectObjectAncestor
  include ObjectAncestor
end

class ToyRecord
  include IndirectObjectAncestor
end

class ClassQueries
  extend T::Sig

  # The result must retain the module type so the marker call is indexed.
  sig { params(item: ObjectAncestor).returns(Symbol) }
  def self.direct(item)
    item.class.new.marker
  end

  sig { params(item: IndirectObjectAncestor).returns(Symbol) }
  def self.indirect(item)
    item.class.new.marker
  end

  # singleton_class uses the same intrinsic as class.
  sig { params(item: ObjectAncestor).returns(T.nilable(String)) }
  def self.singleton_label(item)
    item.singleton_class.name
  end

  # Ordinary class receivers should retain their existing behavior.
  sig { params(item: ToyRecord).returns(Symbol) }
  def self.concrete(item)
    item.class.new.marker
  end
end

ClassQueries.direct(ToyRecord.new)
ClassQueries.indirect(ToyRecord.new)
ClassQueries.singleton_label(ToyRecord.new)
ClassQueries.concrete(ToyRecord.new)
