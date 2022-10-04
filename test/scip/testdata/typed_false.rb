# typed: false

class C
  def f
    @f = 0
  end

  def g(x)
    x + @f + f
  end
end
