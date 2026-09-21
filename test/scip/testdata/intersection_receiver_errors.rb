# typed: true
# check-errors: true

module IntersectionErrorLeft
  extend T::Sig
  sig { params(value: String).returns(String) }
  def left(value)
    value
  end
end

module IntersectionErrorRight
end

extend T::Sig
sig { params(value: T.all(IntersectionErrorLeft, IntersectionErrorRight), values: T::Array[String]).void }
def unresolved_intersection(value, values)
  value.missing # error: Method `missing` does not exist on `IntersectionErrorLeft` component
                # error: Method `missing` does not exist on `IntersectionErrorRight` component
  value.left(1) # error: Expected `String` but found `Integer(1)` for argument `value`
  value.left(*values) # error: Splats are only supported where the size of the array is known statically
end
