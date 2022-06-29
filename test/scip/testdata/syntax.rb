# typed: true

_ = 0 # stub for global <static-init>

def globalFn1()
  x = 10
  x
end

def globalFn2()
  x = globalFn1()
end

def args(x, y)
  z = x + y
  if x == 2
    z += y
  else
    z += x
  end
  z
end

def arrays(a, i)
  a[0] = 0
  a[1] = a[2]
  a[i] = a[i + 1]
  b = a[2..-1]
  a << a[-1]
end

def hashes(h, k)
  h["hello"] = "world"
  old = h["world"]
  h[k] = h[old]
end