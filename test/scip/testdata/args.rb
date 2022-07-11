# typed: true

def args(x, y)
  z = x + y
  if x == 2
    z += y
  else
    z += x
  end
  z
end
