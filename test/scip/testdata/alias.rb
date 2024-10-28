# typed: true

class X
  alias_method :am_aaa, :aaa
  alias :a_aaa :aaa

  def aaa
    puts "AAA"
  end

  def check_alias
    return [am_aaa, a_aaa]
  end
end

module Mod1
  ABC = 10
end

module Mod2
  FEG = Mod1::ABC
end

def myfunction(myparam)
  myparam + Mod2::FEG
end

class X < T::Enum
  enums do
    A = new("A")
    B = new
    C = B
  end

  All = T.let([A, B], T::Array[X])
end

# Adding more cases like this is not supported (c.f. isTEnum),
# but let's at least add a test.
class Y < X
  enums do
    D = new
    E = B
  end
end
