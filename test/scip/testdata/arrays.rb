# typed: true

def arrays(a, i)
  a[0] = 0
  a[1] = a[2]
  a[i] = a[i + 1]
  b = a[2..-1]
  a << a[-1]
end
