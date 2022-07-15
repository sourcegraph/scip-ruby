# typed: true

# Useful SO discussion with examples for class variables and instance variables,
# and how they interact with inheritance: https://stackoverflow.com/a/15773671/2682729

class K
  def m1
    @f = 0
    @g = @f
    return
  end
  def m2
    @f = @g
    return
  end
end

# Extended
class K
  def m3
    @g = @f
    return
  end
end

# Class instance var
class L
  @x = 10
  @y = 9
  def self.m1
    @y = @x
    return
  end

  def m2
    # FIXME: Missing references
    self.class.y = self.class.x
    return
  end
end

# Class var
class N
  @@a = 0
  @@b = 1
  def self.m1
    @@b = @@a
    return
  end

  def m2
    @@b = @@a
    return
  end

  def m3
    # FIXME: Missing references
    self.class.b = self.class.a
  end
end

# Accessors
class P
  attr_accessor :a
  attr_reader :r
  attr_writer :w

  def init
    self.a = self.r
    self.w = self.a
  end

  def wrong_init
    # Check that 'r' is a method access but 'a' and 'w' are locals
    a = r
    w = a
  end
end

def useP
  p = P.new
  p.a = p.r
  p.w = p.a
end