# typed: true
# check-errors: true

module CrossIntersectionLeft
  extend T::Sig
  sig { returns(String) }
  def left
    "left"
  end
end

module CrossIntersectionRight
  extend T::Sig
  sig { returns(String) }
  def right
    "right"
  end
end
