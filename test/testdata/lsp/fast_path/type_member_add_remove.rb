# typed: true

class Parent
  extend T::Sig
  extend T::Generic

  sig {params(x: MyElem).returns(MyElem)}
  #              ^^^^^^ error: Unable to resolve constant `MyElem`
  #                              ^^^^^^ error: Unable to resolve constant `MyElem`
  def example(x)
    T.reveal_type(x) # error: `Parent::MyElem (unresolved)`
  end
end

parent = Parent[Integer].new
T.reveal_type(parent.example(0)) # error: `T.untyped`
