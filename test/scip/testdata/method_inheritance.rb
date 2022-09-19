# typed: true

class C1
  def m1
  end

  def m2
  end
end

class C2 < C1
  def m2
  end
  def m3
    m1
    m2
  end
end

class C3 < C2
  def m4
    m1
  end
end
