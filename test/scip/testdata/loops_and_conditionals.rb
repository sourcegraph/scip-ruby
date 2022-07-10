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
    # NOTE: redo is unsupported (https://srb.help/3003)
    # but emitting a reference here does work
    redo if g == 4
  end
end

def while(xs)
  i = 0
  while i < 10
    puts xs[i]
  end

  j = 0
  while j < 10
    g = xs[j]
    next if g == 0
    next g+1 if g == 1
    break if g == 2
    break g+1 if g == 3
    # NOTE: redo is unsupported (https://srb.help/3003)
    # but emitting a reference here does work
    redo if g == 4
  end
end

def until(xs)
  i = 0
  until i > 10
    puts xs[i]
  end

  j = 0
  until j > 10
    g = xs[j]
    next if g == 0
    next g+1 if g == 1
    break if g == 2
    break g+1 if g == 3
    # NOTE: redo is unsupported (https://srb.help/3003)
    # but emitting a reference here does work
    redo if g == 4
  end
end

def flip_flop(xs)
  # NOTE: flip-flops are unsupported (https://srb.help/3003)
  # Unlike redo, which somehow works, we fail to emit references
  # for the conditions.
  # Keep this test anyways to check that we don't crash/mess something up
  for x in xs
    puts x if x==2..x==8
    puts x+1 if x==4...x==6
  end
end
