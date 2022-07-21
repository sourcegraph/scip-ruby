# typed: true
# options: showDocs

# Class doc comment
class C1
  def m1
  end

  sig { returns(T::Boolean) }
  def m2
    true
  end

  sig { params(C, T::Boolean).returns(T::Boolean) }
  def m3(c, b)
    c.m2 || b
  end

  # _This_ is a
  # **doc comment.**
  def m4(xs)
    xs[0]
  end

  # Yet another..
  # ...doc comment
  sig { returns(T::Boolean) }
  def m5
    true
  end

  # And...
  # ...one more doc comment
  sig { params(C, T::Boolean).returns(T::Boolean) }
  def m6(c, b)
    c.m2 || b
  end
end

class C2 # undocumented class
end

# Module doc comment
#
# Some stuff
module M1
  # This class is nested inside M1
  class C3
  end

  # This module is nested inside M1
  module M2
    # This method is inside M1::M2
    sig { returns(T::Boolean) }
    def n1
      true
    end

    # This method is also inside M1::M2
    def n2
    end
  end
end

# This is a global function
def f1
  M1::M2::m6
  M1::M2::m7
end

# Yet another global function
sig { returns(T::Integer) }
def f2
  return 10
end

def f3 # undocumented global function
end

sig { returns(T::Integer) }
def f4 # another undocumented global function
  return 10
end

# Parent class
class K1
  # sets @x and @@y
  def p1
    @x = 10
    @@y = 10
  end

  # lorem ipsum, you get it
  def self.p2
    @z = 10
  end
end

# Subclass
class K2 < K1
  # doc comment on class var ooh
  @z = 9

  # overrides K1's p1
  def p1
    @x = 20
    @@y = 20
    @z += @x
  end
end
