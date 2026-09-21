# typed: strict

# Exercises abstract!, interface!, final!, sealed!, mixes_in_class_methods.

module Drawable
  extend T::Sig
  extend T::Helpers
  interface!

  sig { abstract.returns(String) }
  def draw; end
end

class Shape
  extend T::Sig
  extend T::Helpers
  abstract!

  sig { abstract.returns(Integer) }
  def area; end
end

class Square < Shape
  extend T::Sig
  include Drawable

  sig { override.returns(Integer) }
  def area
    16
  end

  sig { override.returns(String) }
  def draw
    "square"
  end
end

class FinalLeaf
  extend T::Sig
  extend T::Helpers
  final!

  sig(:final) { returns(Integer) }
  def value
    42
  end
end

module SealedHierarchy
  extend T::Helpers
  sealed!
end

module ClassMethodsMixin
  extend T::Sig

  sig { returns(String) }
  def class_helper
    "class!"
  end
end

module InstanceMethodsMixin
  extend T::Helpers
  mixes_in_class_methods(ClassMethodsMixin)
end

class WithMixedIn
  include InstanceMethodsMixin
end
