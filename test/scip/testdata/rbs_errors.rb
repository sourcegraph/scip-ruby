# typed: strict
# parser: prism
# enable-experimental-rbs-comments: true

class RBSValidation
  #: -> String
  def title
    123 # error: Expected `String` but found `Integer(123)` for method result type
  end
end
