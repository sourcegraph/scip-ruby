# typed: true

# Documents what (if anything) we emit around `yield`. CFGTraversal's switch
# in SCIPIndexer.cc treats YieldLoadArg / LoadYieldParams / YieldParamPresent
# as no-ops.

def with_yield(x)
  yield x
  yield x + 1
end

def with_yield_no_args
  yield
  yield
end

def use_blocks
  total = 0
  with_yield(10) do |v|
    total += v
  end
  with_yield_no_args { total += 1 }
  total
end
