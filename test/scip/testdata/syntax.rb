# typed: true

a = [57, 33]
i = 0
a[i] # a.[](i)
a << 970 # a.push(970)
a[2..-1]

def globalFn1()
  x = 10
  x
end

def globalFn2()
  x = globalFn1()
end
