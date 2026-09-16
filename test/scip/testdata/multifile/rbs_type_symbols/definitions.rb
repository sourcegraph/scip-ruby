# typed: true
# enable-experimental-rbs-comments: true

module RBSDefinitions
  #: type text = String
  #: type copy = text

  #: [Elem]
  class Box
    #: (Elem) -> Elem
    def echo(value)
      value #: Elem
    end

    #: [Elem] (Elem) -> Elem
    def generic_echo(value)
      value #: Elem
    end
  end

  #: [Elem < Numeric]
  class Bounded
    #: (Elem) -> Elem
    def echo(value)
      value
    end
  end
end
