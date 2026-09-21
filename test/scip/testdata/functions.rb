# typed: true

def globalFn1()
  x = 10
  x
end

def globalFn2()
  x = globalFn1()
end

# https://stackoverflow.com/questions/64322636/whats-the-3-dots-method-argument-in-ruby
def loopyDoopy(...)
  loopyDoopy(...)
  return
end
