# typed: true

module M
  def f; puts 'M.f'; end
end

class C1
  include M
  def f; puts 'C1.f'; end
end

# f refers to C1.f
class C2 < C1
end

# f refers to C1.f
class C3 < C1
  include M
end

class D1
  def f; puts 'D1.f'; end
end

class D2
  include M
end

C1.new.f # C1.f
C2.new.f # C1.f
C3.new.f # C1.f

D1.new.f # D1.f
D2.new.f # M.f

# Definition in directly included module and Self

module T0
  module M
    def set_f_0; @f = 0; end
  end

  class C
    include M
    def set_f_1; @f = 1; end
    def get_f; @f; end
  end
end

# Definition in transitively included module and Self

module T1
  module M0
    def set_f_0; @f = 0; end
  end

  module M1
    include M0
  end

  class C
    include M1
    def set_f_1; @f = 1; end
    def get_f; @f; end
  end
end

# Definition in directly included module only

module T2
  module M
    def set_f_0; @f = 0; end
  end

  class C
    include M
    def get_f; @f; end
  end
end

# Definition in transitively included module only

module T3
  module M0
    def set_f_0; @f = 0; end
  end

  module M1
    include M0
  end

  class C
    include M1
    def get_f; @f; end
  end
end

# Definition in directly included module & superclass & Self

module T0
  module M
    def set_f_0; @f = 0; end
  end

  class C0
    def set_f_2; @f = 2; end
  end

  class C1 < C0
    include M
    def set_f_1; @f = 1; end
    def get_f; @f; end
  end
end

# Definition in transitively included module & superclass & Self

module T3
  module M0
    def set_f_0; @f = 0; end
  end

  module M1
    include M0
  end

  class C0
    def set_f_2; @f = 2; end
  end

  class C1 < C0
    include M
    def set_f_1; @f = 1; end
    def get_f; @f; end
  end
end

# Definition in directly included module & superclass only

module T4
  module M
    def set_f_0; @f = 0; end
  end

  class C0
    def set_f_1; @f = 1; end
  end

  class C1 < C0
    def get_f; @f; end
  end
end

# Definition in transitively included module & superclass only

module T5
  module M0
    def set_f_0; @f = 0; end
  end

  module M1
    include M0
  end

  class C0
    def set_f_1; @f = 1; end
  end

  class C1 < C0
    def get_f; @f; end
  end
end

# Definition in module included via superclass & superclass & Self

module T6
  module M
    def set_f_0; @f = 0; end
  end

  class C0
    include M
    def set_f_1; @f = 1; end
  end

  class C1 < C0
    def set_f_2; @f = 2; end
    def get_f; @f; end
  end
end

# Definition in module included via superclass & superclass only

module T7
  module M
    def set_f_0; @f = 0; end
  end

  class C0
    include M
    def set_f_1; @f = 1; end
  end

  class C1 < C0
    def get_f; @f; end
  end
end

# Definition in module included via superclass & Self

module T8
  module M
    def set_f_0; @f = 0; end
  end

  class C0
    include M
  end

  class C1 < C0
    def set_f_2; @f = 2; end
    def get_f; @f; end
  end
end

# Definition in module included via superclass only

module T9
  module M
    def set_f_0; @f = 0; end
  end

  class C0
    include M
  end

  class C1 < C0
    def get_f; @f; end
  end
end

# Definition in multiple transitively included modules & common child & Self

module T10
  module M0
    def set_f_0; @f = 0; end
  end

  module M1
    def set_f_1; @f = 1; end
  end

  module M2
    include M0
    include M1
    def set_f_2; @f = 2; end
  end

  class C
    include M2
    def set_f_3; @f = 3; end
    def get_f; @f; end
  end
end

# Definition in multiple transitively included modules & common child only

module T11
  module M0
    def set_f_0; @f = 0; end
  end

  module M1
    def set_f_1; @f = 1; end
  end

  module M2
    include M0
    include M1
    def set_f_2; @f = 2; end
  end

  class C
    include M2
    def get_f; @f; end
  end
end

# Definition in multiple transitively included modules & Self

module T12
  module M0
    def set_f_0; @f = 0; end
  end

  module M1
    def set_f_1; @f = 1; end
  end

  module M2
    include M0
    include M1
  end

  class C
    include M2
    def set_f_3; @f = 3; end
    def get_f; @f; end
  end
end

# Definition in multiple transitively included modules only

module T13
  module M0
    def set_f_0; @f = 0; end
  end

  module M1
    def set_f_1; @f = 1; end
  end

  module M2
    include M0
    include M1
  end

  class C
    include M2
    def get_f; @f; end
  end
end

# Definition in multiple directly included modules & Self

module T14
  module M0
    def set_f_0; @f = 0; end
  end

  module M1
    def set_f_1; @f = 1; end
  end

  class C
    include M0
    include M1
    def set_f_2; @f = 2; end
    def get_f; @f; end
  end
end

# Definition in multiple directly included modules only

module T15
  module M0
    def set_f_0; @f = 0; end
  end

  module M1
    def set_f_1; @f = 1; end
  end

  class C
    include M0
    include M1
    def get_f; @f; end
  end
end

# OKAY! Now for the more "weird" situations
# Before this, all the tests had a definition come "before" use.
# Let's see what happens if there is a use before any definition.

# Reference in directly included module with def in Self

module W0
  module M
    def get_f; @f; end
  end

  class C
    include M
    def set_f; @f = 0; end
  end
end

# Reference in transitively included module with def in Self

module W1
  module M0
    def get_f; @f; end
  end
  
  module M1
    include M0
  end

  class C
    include M1
    def set_f; @f = 0; end
  end
end

# Reference in superclass with def in directly included module

module W2
  module M
    def set_f; @f = 0; end
  end

  class C0
    def get_f; @f; end
  end

  class C1 < C0
    include M
    def get_fp1; @f + 1; end
  end
end

# Reference in directly included module with def in superclass

module W2
  module M
    def get_f; @f; end
  end

  class C0
    def set_f; @f = 0; end
  end

  class C1 < C0
    include M
    def get_fp1; @f + 1; end
  end
end

# Reference in transitively included module with def in in-between module

module W3
  module M0
    def get_f; @f; end
  end

  module M1
    include M0
    def set_f; @f = 0; end
  end

  class C
    include M1
    def get_fp1; @f + 1; end
  end
end

# Reference in one directly included module with def in other directly included module

module W4
  module M0
    def get_f; @f; end
  end

  module M1
    def set_f; @f + 1; end
  end

  class C
    include M0
    include M1
    def get_fp1; @f + 1; end
  end
end

