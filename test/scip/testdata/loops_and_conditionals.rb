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
end
