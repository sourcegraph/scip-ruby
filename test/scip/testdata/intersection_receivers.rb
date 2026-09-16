# typed: true
# check-errors: true
# Adapted from test/testdata/infer/t_module_all.rb and any_all_module_type_parameter.rb.

module IntersectionLeft
  extend T::Sig

  sig { params(value: String, block: T.nilable(T.proc.returns(String))).returns(String) }
  def left(value, &block)
    value
  end

  sig { params(key: String).returns(String) }
  def shared(key:)
    key
  end

  sig { returns(String) }
  def title
    "left"
  end

  sig { params(index: Integer).returns(String) }
  def [](index)
    "left"
  end

  alias copied left
end

module IntersectionRight
  extend T::Sig

  sig { params(value: String).returns(String) }
  def right(value)
    value
  end

  sig { params(key: String).returns(String) }
  def shared(key:)
    key
  end

  sig { params(index: Integer, value: String).void }
  def []=(index, value)
  end
end

module IntersectionThird
  extend T::Sig
  sig { params(key: String).returns(String) }
  def shared(key:)
    key
  end
end

module IntersectionMarker
end

module IntersectionParent
  extend T::Sig
  sig { returns(String) }
  def inherited
    "parent"
  end
end

module IntersectionChildA
  include IntersectionParent
end

module IntersectionChildB
  include IntersectionParent
end

class IntersectionCalls
  extend T::Sig

  sig { params(value: T.all(IntersectionLeft, IntersectionRight)).void }
  def overlap(value)
    value.left("a").upcase
    value.right("b").upcase
    value.shared(key: "overlap").upcase
    value.copied("c")
  end

  sig { params(value: T.all(IntersectionChildA, IntersectionChildB)).void }
  def inherited(value)
    value.inherited.upcase
  end

  sig { params(value: T.all(T.any(IntersectionLeft, IntersectionMarker), IntersectionRight)).void }
  def incomplete_branch(value)
    # The left union cannot resolve shared on every branch. Only Right survives.
    value.shared(key: "discard-left")
  end

  sig { params(value: T.all(IntersectionRight, T.any(IntersectionLeft, IntersectionMarker))).void }
  def reversed_incomplete_branch(value)
    value.shared(key: "discard-reversed")
  end

  sig { params(value: T.all(T.any(IntersectionLeft, IntersectionThird), IntersectionRight)).void }
  def complete_branches(value)
    value.shared(key: "complete")
  end

  sig { params(value: T.any(T.all(IntersectionLeft, IntersectionRight), IntersectionThird)).void }
  def nested_union(value)
    value.shared(key: "nested-union")
  end

  sig { params(value: T.any(IntersectionLeft, IntersectionThird)).void }
  def ordinary_union(value)
    value.shared(key: "ordinary-union")
  end

  sig { params(mod: T.all(T::Module[IntersectionLeft], IntersectionRight)).void }
  def module_receiver(mod)
    mod.name
    mod.ancestors
    mod.instance_method(:left).name
    mod.right("module")
  end

  sig { params(value: T.all(IntersectionLeft, IntersectionRight), block: T.proc.returns(String)).void }
  def wrapped(value, &block)
    value.left("a", &block)
    value.left(*["b"])
    value.left(*["c"], &block)
    value.left(*["d"]) { "block" }
    value.left(
      *["multiline"],
      &block
    )
    [value].map(&:title)
    [value].map(&:"title")
    [value].map(&:'title')
    value[0]
    value[*[0]]
    value.[](*[0])
    value[0] = "a"
    value[*[0]] = "b"
    value.[]=(*[0, "c"])
  end
end

class IntersectionBox
  extend T::Sig
  extend T::Generic
  Elem = type_member { {upper: T.all(IntersectionLeft, IntersectionRight)} }

  sig { params(value: Elem).void }
  def bounded(value)
    value.left("bounded")
    value.right("bounded")
    value.shared(key: "bounded")
    value.left(*["bounded-splat"])
  end
end
