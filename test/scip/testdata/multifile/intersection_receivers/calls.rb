# typed: true
# check-errors: true

extend T::Sig
sig { params(value: T.all(CrossIntersectionLeft, CrossIntersectionRight)).void }
def cross_intersection(value)
  value.left.upcase
  value.right.upcase
end
