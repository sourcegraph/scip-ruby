# typed: true

def if_elsif_else()
  x = 0
  y = 0
  # Basic stuff
  if x == 1
    y = 2
  elsif x == 2
    y = 3
  else
    y = x
  end

  # More complex expressiosn
  z =
    if if x == 0 then x+1 else x+2 end == 1
      x
    else
      x+1
    end
  z = z if z != 10

  return
end

def unless()
  z = 0
  x = 1
  unless z == 9
    z = 9
  end

  unless x == 10
    x = 3
  else
    x = 2
  end
  return
end

def case(x, y)
  case x
    when 0
      x = 3
    when y
      x = 2
    when (3 == (x = 1))
      x = 0
    else
      x = 1
  end
  return
end

def for(xs)
  for e in xs
    puts e
  end

  for f in xs
    g = f+1
    next if g == 0
    next g+1 if g == 1
    break if g == 2
    break g+1 if g == 3
    redo if g == 4
  end
end
