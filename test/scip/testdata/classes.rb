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

class M3::C3
end

def local_class()
  localClass = Class.new
  # Technically, this is not supported by Sorbet (https://srb.help/3001),
  # but make sure we don't crash or do something weird.
  def localClass.myMethod()
    ":)"
  end
  _c = localClass.new
  _m = localClass.myMethod
  return
end

module M4
  K = 0
end

def module_access()
  _ = M4::K
  return
end

module M5
  module M6
    def self.g()
    end
  end

  def self.h()
    M6.g()
    return
  end
end

class C7
  module M8
    def self.i()
    end
  end

  def j()
    M8.j()
    return
  end
end
