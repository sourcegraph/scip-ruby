 # typed: true
 
 # Documents what (if anything) we emit around `yield`. CFGTraversal's switch
 # in SCIPIndexer.cc treats YieldLoadArg / LoadYieldParams / YieldParamPresent
 # as no-ops.
 
 def with_yield(x)
#    ^^^^^^^^^^ definition [..] Object#with_yield().
#               ^ definition local 1$1452685967
   yield x
#        ^ reference local 1$1452685967
   yield x + 1
#        ^ reference local 1$1452685967
 end
 
 def with_yield_no_args
#    ^^^^^^^^^^^^^^^^^^ definition [..] Object#with_yield_no_args().
   yield
   yield
 end
 
 def use_blocks
#    ^^^^^^^^^^ definition [..] Object#use_blocks().
   total = 0
#  ^^^^^ definition local 1$1737801135
   with_yield(10) do |v|
#  ^^^^^^^^^^ reference [..] Object#with_yield().
#                     ^ definition local 2$1737801135
     total += v
#    ^^^^^ reference (write) local 1$1737801135
#    ^^^^^ reference local 1$1737801135
#    ^^^^^^^^^^ reference local 1$1737801135
#             ^ reference local 2$1737801135
   end
   with_yield_no_args { total += 1 }
#  ^^^^^^^^^^^^^^^^^^ reference [..] Object#with_yield_no_args().
#                       ^^^^^ reference (write) local 1$1737801135
#                       ^^^^^ reference local 1$1737801135
#                       ^^^^^^^^^^ reference local 1$1737801135
   total
#  ^^^^^ reference local 1$1737801135
 end
