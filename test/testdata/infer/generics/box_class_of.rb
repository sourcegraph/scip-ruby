# typed: true
extend T::Sig

class Box
  extend T::Sig
  extend T::Generic
  Elem = type_member(:out)

  sig {params(val: Elem).void}
  def initialize(val)
    @val = val
  end
end

class BoxA < Box
  Elem = type_member(:out) {{upper: A}}
end

sig {params(klass: T.class_of(Box)).void}
def example1(klass)
  T.reveal_type(klass) # error: `T.class_of(Box)[Box[T.anything]]`
  instance = klass.new(0)
  T.reveal_type(instance) # error: `Box[T.anything]`

  T.reveal_type(klass[Integer]) # error: `Runtime object representing type: Box[Integer]`
  instance = klass[Integer].new(0)
  T.reveal_type(instance) # error: `Box[Integer]`

  klass[Integer].new('')
  #                  ^^ error: Expected `Integer` but found `String("")` for argument `val`
end

module M; end
class A; end

class ChildA < A
  include M
end

class BoxChildA < Box
  Elem = type_member(:out) {{upper: ChildA}}
end

sig {params(klass: T.all(T.class_of(Box), T::Class[Box[T.all(A, M)]])).void}
def example2(klass)
  T.reveal_type(klass) # error: `T.class_of(Box)[Box[T.all(A, M)]]`
  instance = klass.new(ChildA.new)
  T.reveal_type(instance) # error: `Box[T.all(A, M)]`

  klass.new # error: Not enough arguments provided for method `Box#initialize`

  # These two are bugs in our Class_new intrinsic. We dispatch on
  # attachedClass->externalType() instead of on the attached class type
  # argument. This doesn't happen for the klass[Integer].new calls because the
  # [] call creates a MetaType, and then the `new` dispatchCall goes to
  # `initialize` on the the MetaType's wrapped type.
  klass.new(A.new)
  klass.new(0)

  # But I guess this still works, where you can just apply it to another type?

  T.reveal_type(klass[Integer]) # error: `Runtime object representing type: Box[Integer]`
  instance = klass[Integer].new # error: Not enough arguments
  T.reveal_type(instance) # error: `Box[Integer]`
end

example2(Box)
#        ^^^ error: Expected `T.class_of(Box)[Box[T.all(A, M)]]` but found `T.class_of(Box)`
example2(BoxA)
#        ^^^^ error: Expected `T.class_of(Box)[Box[T.all(A, M)]]` but found `T.class_of(BoxA)`
example2(BoxChildA)
