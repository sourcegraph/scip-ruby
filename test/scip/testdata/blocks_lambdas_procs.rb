# typed: true

def blk
  y = 0
  [].each { |x|
    y += x
  }
  [].each do |x|
    y += x
  end
end

def lam
  y = 0
  l1 = ->(x) {
    y += x
  }
  l2 = lambda { |x|
    y += x
  }
  l3 = ->(x:) {
    y += x
  }
  l4 = lambda { |x:|
    y += x
  }
  l1.call(1)
  l2.call(2)
  l3.call(x: 3)
  l4.call(x: 4)
end

def prc
  y = 0
  p1 = Proc.new { |x|
    y += x
  }
  p2 = proc { |x|
    y += x
  }
  p3 = Proc.new { |x:|
    y += x
  }
  p4 = proc { |x:|
    y += x
  }
  p1.call(1)
  p2.call(2)
  p3.call(x: 3)
  p4.call(x: 4)
end

def call_block(&blk)
  blk.call
end

def use_block_with_defaults
  call_block do |oops: nil|
  end

  call_block do |oops = "nil"|
  end
end
