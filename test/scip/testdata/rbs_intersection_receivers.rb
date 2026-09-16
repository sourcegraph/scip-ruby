# typed: true
# enable-experimental-rbs-comments: true

module RBSIntersectionLeft
  #: -> String
  def left
    "left"
  end
end

module RBSIntersectionRight
  #: -> String
  def right
    "right"
  end
end

#: (RBSIntersectionLeft & RBSIntersectionRight) -> void
def rbs_intersection(value)
  value.left.upcase
  value.right.upcase
end
