# typed: true

def globalFn1()
  x = 10
  x
end

def globalFn2()
  x = globalFn1()
end

