# typed: true
extend T::Sig

class Box
  extend T::Sig
  extend T::Generic

  Elem = type_member

  sig {params(val: Elem).void}
  def initialize(val)
  end
end

sig do
  type_parameters(:T)
  .params(val: T.type_parameter(:T))
  .returns(Box[T.type_parameter(:T)])
end
def build_box(val)
  Box.new(val)
end

sig do
  type_parameters(:T)
  .params(val: T.type_parameter(:T))
  .returns(Box[T.type_parameter(:T)])
end
def build_box_kw(val:)
  Box.new(val)
end

sig {params(val: Box[Integer]).void}
def takes_box_int(val)
end

a = build_box(42)
takes_box_int(a)

a_kw = build_box_kw(val: 42)
takes_box_int(a_kw)

class Left; end
class Right; end

sig {params(val: Box[T.any(Left, Right)]).void}
def takes_box_left_right(val)
end

a_lr = build_box(Left.new)
takes_box_left_right(a_lr)

sig {params(val: Box[[Integer, String]]).void}
def takes_box_pair_int_string(val)
end

box_is = build_box([0, ''])
T.reveal_type(box_is) # error: Revealed type: `box[[Integer(0), String("")]]`
takes_box_pair_int_string(box_is)

box_sf = build_box([:foo, 0.0])
T.reveal_type(box_sf) # error: Revealed type: `box[[Symbol(:"foo"), Float(0.000000)]]`
takes_box_pair_int_string(box_sf)
