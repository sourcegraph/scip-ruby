 # typed: true
 
#⌄ enclosing_range_start [..] Object#blk().
 def blk
#    ^^^ definition [..] Object#blk().
   y = 0
#  ^ definition local 1$2822987882
   [].each { |x|
#             ^ definition local 2$2822987882
     y += x
#    ^ reference (write) local 1$2822987882
#    ^ reference local 1$2822987882
#    ^^^^^^ reference local 1$2822987882
#      ^^ reference [..] Integer#+().
#         ^ reference local 2$2822987882
   }
   [].each do |x|
#              ^ definition local 3$2822987882
     y += x
#    ^ reference (write) local 1$2822987882
#    ^ reference local 1$2822987882
#    ^^^^^^ reference local 1$2822987882
#      ^^ reference [..] Integer#+().
#         ^ reference local 3$2822987882
   end
 end
#  ⌃ enclosing_range_end [..] Object#blk().
 
#⌄ enclosing_range_start [..] Object#lam().
 def lam
#    ^^^ definition [..] Object#lam().
   y = 0
#  ^ definition local 1$3374022419
   l1 = ->(x) {
#  ^^ definition local 4$3374022419
#       ^^ reference [..] Kernel#
#       ^^ reference [..] Kernel#lambda().
#          ^ definition local 3$3374022419
     y += x
#    ^ reference (write) local 1$3374022419
#    ^ reference local 1$3374022419
#    ^^^^^^ reference local 1$3374022419
#      ^^ reference [..] Integer#+().
#         ^ reference local 3$3374022419
   }
   l2 = lambda { |x|
#  ^^ definition local 6$3374022419
#       ^^^^^^ reference [..] Kernel#lambda().
#                 ^ definition local 5$3374022419
     y += x
#    ^ reference (write) local 1$3374022419
#    ^ reference local 1$3374022419
#    ^^^^^^ reference local 1$3374022419
#      ^^ reference [..] Integer#+().
#         ^ reference local 5$3374022419
   }
   l3 = ->(x:) {
#  ^^ definition local 9$3374022419
#       ^^ reference [..] Kernel#
#       ^^ reference [..] Kernel#lambda().
#          ^^ definition local 8$3374022419
     y += x
#    ^ reference (write) local 1$3374022419
#    ^ reference local 1$3374022419
#    ^^^^^^ reference local 1$3374022419
#      ^^ reference [..] Integer#+().
#         ^ reference local 8$3374022419
   }
   l4 = lambda { |x:|
#  ^^ definition local 11$3374022419
#       ^^^^^^ reference [..] Kernel#lambda().
#                 ^^ definition local 10$3374022419
     y += x
#    ^ reference (write) local 1$3374022419
#    ^ reference local 1$3374022419
#    ^^^^^^ reference local 1$3374022419
#      ^^ reference [..] Integer#+().
#         ^ reference local 10$3374022419
   }
   l1.call(1)
#  ^^ reference local 4$3374022419
#     ^^^^ reference [..] Proc1#call().
   l2.call(2)
#  ^^ reference local 6$3374022419
#     ^^^^ reference [..] Proc1#call().
   l3.call(x: 3)
#  ^^ reference local 9$3374022419
#     ^^^^ reference [..] Proc#call().
   l4.call(x: 4)
#  ^^ reference local 11$3374022419
#     ^^^^ reference [..] Proc#call().
 end
#  ⌃ enclosing_range_end [..] Object#lam().
 
#⌄ enclosing_range_start [..] Object#prc().
 def prc
#    ^^^ definition [..] Object#prc().
   y = 0
#  ^ definition local 1$1364318174
   p1 = Proc.new { |x|
#  ^^ definition local 4$1364318174
#       ^^^^ reference [..] Proc#
#            ^^^ reference [..] `<Class:Proc>`#new().
#                   ^ definition local 3$1364318174
     y += x
#    ^ reference (write) local 1$1364318174
#    ^ reference local 1$1364318174
#    ^^^^^^ reference local 1$1364318174
#      ^^ reference [..] Integer#+().
#         ^ reference local 3$1364318174
   }
   p2 = proc { |x|
#  ^^ definition local 6$1364318174
#       ^^^^ reference [..] Kernel#proc().
#               ^ definition local 5$1364318174
     y += x
#    ^ reference (write) local 1$1364318174
#    ^ reference local 1$1364318174
#    ^^^^^^ reference local 1$1364318174
#      ^^ reference [..] Integer#+().
#         ^ reference local 5$1364318174
   }
   p3 = Proc.new { |x:|
#  ^^ definition local 9$1364318174
#       ^^^^ reference [..] Proc#
#            ^^^ reference [..] `<Class:Proc>`#new().
#                   ^^ definition local 8$1364318174
     y += x
#    ^ reference (write) local 1$1364318174
#    ^ reference local 1$1364318174
#    ^^^^^^ reference local 1$1364318174
#      ^^ reference [..] Integer#+().
#         ^ reference local 8$1364318174
   }
   p4 = proc { |x:|
#  ^^ definition local 11$1364318174
#       ^^^^ reference [..] Kernel#proc().
#               ^^ definition local 10$1364318174
     y += x
#    ^ reference (write) local 1$1364318174
#    ^ reference local 1$1364318174
#    ^^^^^^ reference local 1$1364318174
#      ^^ reference [..] Integer#+().
#         ^ reference local 10$1364318174
   }
   p1.call(1)
#  ^^ reference local 4$1364318174
#     ^^^^ reference [..] Proc#call().
   p2.call(2)
#  ^^ reference local 6$1364318174
#     ^^^^ reference [..] Proc1#call().
   p3.call(x: 3)
#  ^^ reference local 9$1364318174
#     ^^^^ reference [..] Proc#call().
   p4.call(x: 4)
#  ^^ reference local 11$1364318174
#     ^^^^ reference [..] Proc#call().
 end
#  ⌃ enclosing_range_end [..] Object#prc().
 
#⌄ enclosing_range_start [..] Object#call_block().
 def call_block(&blk)
#    ^^^^^^^^^^ definition [..] Object#call_block().
#                ^^^ definition local 1$2502097765
   blk.call
#  ^^^ reference local 1$2502097765
 end
#  ⌃ enclosing_range_end [..] Object#call_block().
 
#⌄ enclosing_range_start [..] Object#use_block_with_defaults().
 def use_block_with_defaults
#    ^^^^^^^^^^^^^^^^^^^^^^^ definition [..] Object#use_block_with_defaults().
   call_block do |oops: nil|
#  ^^^^^^^^^^ reference [..] Object#call_block().
#                 ^^^^^ definition local 1$1358758412
   end
 
   call_block do |oops = "nil"|
#  ^^^^^^^^^^ reference [..] Object#call_block().
#                 ^^^^ definition local 2$1358758412
   end
 end
#  ⌃ enclosing_range_end [..] Object#use_block_with_defaults().
