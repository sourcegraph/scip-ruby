# typed: true

# Methods and class instance variables defined inside `class << self`.
# Currently noted as "BUG: Emitting a definition for 'self' here seems wrong."
# in field_inheritance.rb. This fixture captures the current behavior so a
# future fix has a regression target.

class K
  class << self
    def class_method
      @counter = 0
    end

    def read_counter
      @counter
    end

    attr_accessor :name
  end
end

def use_K
  K.class_method
  _ = K.read_counter
  K.name = "k"
  _ = K.name
  return
end
