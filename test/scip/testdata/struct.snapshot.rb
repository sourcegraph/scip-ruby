 # typed: true
 
 # From Sorbet docs https://sorbet.org/docs/tstruct
#⌄ enclosing_range_start [..] S#
#⌄ enclosing_range_start [..] S#initialize().
 class S < T::Struct
#      ^ definition [..] S#
#      ^ definition [..] S#initialize().
#          ^ reference [..] T#
#             ^^^^^^ reference [..] T#Struct#
#  ⌄ enclosing_range_start [..] S#`prop_i=`().
#  ⌄ enclosing_range_start [..] S#prop_i().
   prop :prop_i, Integer
#        ^^^^^^ definition [..] S#`prop_i=`().
#        ^^^^^^ definition [..] S#prop_i().
#                ^^^^^^^ reference [..] Integer#
#                      ⌃ enclosing_range_end [..] S#`prop_i=`().
#                      ⌃ enclosing_range_end [..] S#prop_i().
#  ⌄ enclosing_range_start [..] S#const_s().
   const :const_s, T.nilable(String)
#         ^^^^^^^ definition [..] S#const_s().
#                            ^^^^^^ reference [..] String#
#                                  ⌃ enclosing_range_end [..] S#const_s().
#  ⌄ enclosing_range_start [..] S#const_f().
   const :const_f, Float, default: 0.5
#         ^^^^^^^ definition [..] S#const_f().
#                  ^^^^^ reference [..] Float#
#                                    ⌃ enclosing_range_end [..] S#const_f().
 end
#  ⌃ enclosing_range_end [..] S#
#  ⌃ enclosing_range_end [..] S#initialize().
 
#⌄ enclosing_range_start [..] Object#f().
 def f
#    ^ definition [..] Object#f().
   s = S.new(prop_i: 3)
#  ^ definition local 1$3809224601
#      ^ reference [..] S#
#        ^^^ reference [..] Class#new().
   _ = s.prop_i.to_s + s.const_s + s.const_f.to_s + s.serialize.to_s
#  ^ definition local 3$3809224601
#      ^ reference local 1$3809224601
#        ^^^^^^ reference [..] S#prop_i().
#               ^^^^ reference [..] Integer#to_s().
#                    ^ reference [..] String#+().
#                      ^ reference local 1$3809224601
#                        ^^^^^^^ reference [..] S#const_s().
#                                ^ reference [..] String#+().
#                                  ^ reference local 1$3809224601
#                                    ^^^^^^^ reference [..] S#const_f().
#                                            ^^^^ reference [..] Float#to_s().
#                                                 ^ reference [..] String#+().
#                                                   ^ reference local 1$3809224601
#                                                     ^^^^^^^^^ reference [..] T#Props#Serializable#serialize().
#                                                               ^^^^ reference [..] Kernel#to_s().
   s.prop_i = 4
#  ^ reference local 1$3809224601
#    ^^^^^^^^ reference [..] S#`prop_i=`().
   return
 end
#  ⌃ enclosing_range_end [..] Object#f().
 
#⌄ enclosing_range_start [..] POINT#
#⌄ enclosing_range_start [..] POINT#
#                    ⌄ enclosing_range_start [..] POINT#`x=`().
#                    ⌄ enclosing_range_start [..] POINT#x().
#                        ⌄ enclosing_range_start [..] POINT#`y=`().
#                        ⌄ enclosing_range_start [..] POINT#y().
 POINT = Struct.new(:x, :y) do
#^^^^^ reference [..] POINT#
#^^^^^ definition [..] POINT#
#^^^^^ definition [..] POINT#
#                    ^ definition [..] POINT#`x=`().
#                    ^ definition [..] POINT#x().
#                    ^ reference [..] BasicObject#
#                        ^ definition [..] POINT#`y=`().
#                        ^ definition [..] POINT#y().
#                        ^ reference [..] BasicObject#
#                    ⌃ enclosing_range_end [..] POINT#`x=`().
#                    ⌃ enclosing_range_end [..] POINT#x().
#                        ⌃ enclosing_range_end [..] POINT#`y=`().
#                        ⌃ enclosing_range_end [..] POINT#y().
#  ⌄ enclosing_range_start [..] POINT#array().
   def array
#      ^^^^^ definition [..] POINT#array().
     [x, y]
#     ^ reference [..] POINT#x().
#        ^ reference [..] POINT#y().
   end
#    ⌃ enclosing_range_end [..] POINT#array().
 end
#  ⌃ enclosing_range_end [..] POINT#
#  ⌃ enclosing_range_end [..] POINT#
 
#⌄ enclosing_range_start [..] Object#g().
 def g
#    ^ definition [..] Object#g().
   p = POINT.new(0, 1)
#  ^ definition local 1$3792446982
#      ^^^^^ reference [..] POINT#
#            ^^^ reference [..] Class#new().
   a = p.array
#  ^ definition local 3$3792446982
#      ^ reference local 1$3792446982
#        ^^^^^ reference [..] POINT#array().
   px = p.x
#  ^^ definition local 4$3792446982
#       ^ reference local 1$3792446982
#         ^ reference [..] POINT#x().
   return
 end
#  ⌃ enclosing_range_end [..] Object#g().
