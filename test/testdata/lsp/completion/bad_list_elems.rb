# typed: true

def various_bad_commas_in_array(a, b, x, y)
  [, x] # error: unexpected token ","
  #^ completion: a, b, x, y, ...

  # completion results here aren't great because they haven't been tuned.
  # If we decide to make them better, feel free to update this test
  [x y] # error: unexpected token tIDENTIFIER
  # ^ completion: a, b, x, y, ...
  #  ^ completion: a, b, x, y, ...
  #   ^ completion: a, b, x, y, ...

  [x, , y] # error: unexpected token ","
  #   ^ completion: a, b, x, y, ...

  [x, y, ,] # error: unexpected token ","
  #      ^ completion: a, b, x, y, ...
end
