# typed: true

# First, check that instance variables are propagated through
# the inheritance chain.

class C1
  attr_accessor :h
  attr_accessor :i

  def set_ivar
    @f = 1
    return
  end
end

class C2 < C1
  def get_inherited_ivar
    return @f + @h
  end

  def set_inherited_ivar
    @f = 10
    return
  end

  def set_new_ivar
    @g = 1
    return
  end

  def get_new_ivar
    return @g
  end
end

class C3 < C2
  def refs
    @f = @g + @i
    return
  end
end

def c_check
  C1.new.instance_variable_get(:@f)
  C1.new.instance_variable_get(:@h)
  C1.new.instance_variable_get(:@i)

  C2.new.instance_variable_get(:@f)
  C2.new.instance_variable_get(:@g)
  C2.new.instance_variable_get(:@h)
  C2.new.instance_variable_get(:@i)

  C3.new.instance_variable_get(:@f)
  C3.new.instance_variable_get(:@g)
  C3.new.instance_variable_get(:@h)
  C3.new.instance_variable_get(:@i)
  return
end

# Now, check that class variables work as expected.

class D1
  @@d1_v = 0

  def self.set_x
    @@d1_x = @@d1_v
    return
  end

  class << self
    def set_y
      @@d1_y = @@d1_v
    end
  end
end

class D2 < D1
  def self.get
    @@d2_x = @@d1_v + @@d1_x
    @@d1_y + @@d1_z
    return
  end
end

class D3 < D2
  def self.get_2
    @@d1_v + @@d1_x
    @@d1_y + @@d1_z
    @@d2_x
    return
  end
end

def f
  D2.class_variable_get(:@@d1_v)
  D2.class_variable_get(:@@d1_x)
  D2.class_variable_get(:@@d2_x)
  D2.class_variable_get(:@@d1_y)
  D2.class_variable_get(:@@d1_z)

  D3.class_variable_get(:@@d1_v)
  D3.class_variable_get(:@@d1_x)
  D3.class_variable_get(:@@d2_x)
  D3.class_variable_get(:@@d1_y)
  D3.class_variable_get(:@@d1_z)
  return
end

# Class instance variables are not inherited.

class E1
  @x = 0

  def self.set_x
    @x = @y
    return
  end

  def self.set_y
    @y = 10
    return
  end
end

class E2 < E1
  @x = 0

  def self.set_x_2
    @x = @y
    return
  end

  def self.set_y_2
    @y = 10
  end
end

# Declared fields are inherited the same way as undeclared fields

class F1
  def initialize
    @x = T.let(0, Integer)
  end
end

class F2
  def get_x
    @x
  end
end
