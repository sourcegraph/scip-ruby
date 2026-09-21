# typed: true

def for_loop()
  y = 0
  for x in [1, 2, 3]
    y += x
    for x in [3, 4, 5]
      y += x
    end
  end
  y
end
