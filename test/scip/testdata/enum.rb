# typed: struct

class X < T::Enum
  enums do
    A = new("A")
    B = new
  end

  All = T.let([A, B], T::Array[X])
end
