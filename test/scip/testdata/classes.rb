# typed: true

_ = 0

class C1
  def f()
    _a = C1.new
    _b = M2::C2.new
    return
  end
end

module M2
  class C2
  end
end
