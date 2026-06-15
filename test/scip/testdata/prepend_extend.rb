# typed: true

# Exercises prepend and user-level extend mixin relationships;
# the existing mixin.rb only covers include. Shared @field is used so the
# field-inheritance / mixin-transitive code paths get a chance to surface
# `is_reference` relationships for prepend/extend.

module Greeter
  def hello
    "hi"
  end

  def set_via_greeter
    @field = "g"
  end
end

module PrependedMod
  def hello
    "prepended " + super
  end

  def set_via_prepend
    @field = "p"
  end
end

module ClassyMethods
  def klass_hi
    "class hi"
  end
end

class CombinedMix
  include Greeter
  prepend PrependedMod
  extend ClassyMethods

  def read_field
    @field
  end
end

def use_combined
  c = CombinedMix.new
  c.set_via_greeter
  c.set_via_prepend
  _ = c.hello
  _ = c.read_field
  _ = CombinedMix.klass_hi
  return
end
