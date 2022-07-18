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

def keyword_args(w:, x: 3, y: [], **kwargs)
  y << w + x
  y << [a]
  return
end

def use_kwargs
  h = { a: 3 }
  keyword_args(w: 0, **h)
  keyword_args(w: 0, x: 1, y: [2], **h)
  return
end
