 # typed: true
 
 def blk
#    ^^^ definition [..] Object#blk().
   y = 0
#  ^ definition local 1~#1472469056
   [].each { |x|
#             ^ definition local 2~#1472469056
     y += x
#    ^ reference local 1~#1472469056
#    ^ reference (write) local 1~#1472469056
#    ^^^^^^ reference local 1~#1472469056
#         ^ reference local 2~#1472469056
   }
   [].each do |x|
#              ^ definition local 3~#1472469056
     y += x
#    ^ reference local 1~#1472469056
#    ^ reference (write) local 1~#1472469056
#    ^^^^^^ reference local 1~#1472469056
#         ^ reference local 3~#1472469056
   end
 end
 
 def lam
#    ^^^ definition [..] Object#lam().
   y = 0
#  ^ definition local 1~#1499497673
   l1 = ->(x) {
#  ^^ definition local 4~#1499497673
#       ^^ reference [..] Kernel#
#       ^^ reference [..] Kernel#lambda().
#          ^ definition local 3~#1499497673
     y += x
#    ^ reference local 1~#1499497673
#    ^ reference (write) local 1~#1499497673
#    ^^^^^^ reference local 1~#1499497673
#         ^ reference local 3~#1499497673
   }
   l2 = lambda { |x|
#  ^^ definition local 6~#1499497673
#       ^^^^^^ reference [..] Kernel#lambda().
#                 ^ definition local 5~#1499497673
     y += x
#    ^ reference (write) local 1~#1499497673
#    ^ reference local 1~#1499497673
#    ^^^^^^ reference local 1~#1499497673
#         ^ reference local 5~#1499497673
   }
   l3 = ->(x:) {
#  ^^ definition local 9~#1499497673
#       ^^ reference [..] Kernel#
#       ^^ reference [..] Kernel#lambda().
#          ^^ definition local 8~#1499497673
     y += x
#    ^ reference local 1~#1499497673
#    ^ reference (write) local 1~#1499497673
#    ^^^^^^ reference local 1~#1499497673
#         ^ reference local 8~#1499497673
   }
   l4 = lambda { |x:|
#  ^^ definition local 11~#1499497673
#       ^^^^^^ reference [..] Kernel#lambda().
#                 ^^ definition local 10~#1499497673
     y += x
#    ^ reference local 1~#1499497673
#    ^ reference (write) local 1~#1499497673
#    ^^^^^^ reference local 1~#1499497673
#         ^ reference local 10~#1499497673
   }
   l1.call(1)
#  ^^ reference local 4~#1499497673
#     ^^^^ reference [..] Proc1#call().
   l2.call(2)
#  ^^ reference local 6~#1499497673
#     ^^^^ reference [..] Proc1#call().
   l3.call(x: 3)
#  ^^ reference local 9~#1499497673
#     ^^^^ reference [..] Proc#call().
   l4.call(x: 4)
#  ^^ reference local 11~#1499497673
#     ^^^^ reference [..] Proc#call().
 end
 
 def prc
#    ^^^ definition [..] Object#prc().
   y = 0
#  ^ definition local 1~#1283111692
   p1 = Proc.new { |x|
#  ^^ definition local 4~#1283111692
#       ^^^^ reference [..] Proc#
#            ^^^ reference [..] `<Class:Proc>`#new().
#                   ^ definition local 3~#1283111692
     y += x
#    ^ reference local 1~#1283111692
#    ^ reference (write) local 1~#1283111692
#    ^^^^^^ reference local 1~#1283111692
#         ^ reference local 3~#1283111692
   }
   p2 = proc { |x|
#  ^^ definition local 6~#1283111692
#       ^^^^ reference [..] Kernel#proc().
#               ^ definition local 5~#1283111692
     y += x
#    ^ reference local 1~#1283111692
#    ^ reference (write) local 1~#1283111692
#    ^^^^^^ reference local 1~#1283111692
#         ^ reference local 5~#1283111692
   }
   p3 = Proc.new { |x:|
#  ^^ definition local 9~#1283111692
#       ^^^^ reference [..] Proc#
#            ^^^ reference [..] `<Class:Proc>`#new().
#                   ^^ definition local 8~#1283111692
     y += x
#    ^ reference local 1~#1283111692
#    ^ reference (write) local 1~#1283111692
#    ^^^^^^ reference local 1~#1283111692
#         ^ reference local 8~#1283111692
   }
   p4 = proc { |x:|
#  ^^ definition local 11~#1283111692
#       ^^^^ reference [..] Kernel#proc().
#               ^^ definition local 10~#1283111692
     y += x
#    ^ reference local 1~#1283111692
#    ^ reference (write) local 1~#1283111692
#    ^^^^^^ reference local 1~#1283111692
#         ^ reference local 10~#1283111692
   }
   p1.call(1)
#  ^^ reference local 4~#1283111692
#     ^^^^ reference [..] Proc#call().
   p2.call(2)
#  ^^ reference local 6~#1283111692
#     ^^^^ reference [..] Proc1#call().
   p3.call(x: 3)
#  ^^ reference local 9~#1283111692
#     ^^^^ reference [..] Proc#call().
   p4.call(x: 4)
#  ^^ reference local 11~#1283111692
#     ^^^^ reference [..] Proc#call().
 end
