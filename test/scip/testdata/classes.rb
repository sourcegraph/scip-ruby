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
end