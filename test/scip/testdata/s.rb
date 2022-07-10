# typed: true

def case(x, y)
  case x
    when 0
      x = 3
    when (3 == (x = 1))
      x = 0
    else
      x = 1
  end
  return
end
