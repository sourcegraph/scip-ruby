# typed: true

# From Sorbet docs https://sorbet.org/docs/tstruct
class S < T::Struct
  prop :prop_i, Integer
  const :const_s, T.nilable(String)
  const :const_f, Float, default: 0.5
end

def f
  s = S.new(prop_i: 3)
  _ = s.prop_i.to_s + s.const_s + s.const_f.to_s + s.serialize.to_s
  s.prop_i = 4
  return
end

POINT = Struct.new(:x, :y) do
  def array
    [x, y]
  end
end

def g
  p = POINT.new(0, 1)
  a = p.array
  px = p.x
  return
end
