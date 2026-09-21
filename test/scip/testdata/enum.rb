# typed: strict

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

def use_abc
  x = X::A
  return
end
