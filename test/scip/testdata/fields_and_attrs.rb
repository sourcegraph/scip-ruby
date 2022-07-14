# typed: true

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
