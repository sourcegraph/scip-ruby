 # typed: true
 
 # From Sorbet docs https://sorbet.org/docs/tstruct
 class S < T::Struct
#      ^ definition [..] S#
#      ^ definition [..] S#initialize().
#          ^ reference [..] T#
#             ^^^^^^ definition [..] T#Struct#
   prop :prop_i, Integer
#        ^^^^^^ definition [..] S#`prop_i=`().
#        ^^^^^^ definition [..] S#prop_i().
#                ^^^^^^^ reference [..] Integer#
   const :const_s, T.nilable(String)
#         ^^^^^^^ definition [..] S#const_s().
#                            ^^^^^^ reference [..] String#
   const :const_f, Float, default: 0.5
#         ^^^^^^^ definition [..] S#const_f().
#                  ^^^^^ reference [..] Float#
 end
 
 def f
#    ^ definition [..] Object#f().
   s = S.new(prop_i: 3)
#  ^ definition local 1~#3809224601
#      ^ reference [..] S#
#        ^^^ reference [..] Class#new().
   _ = s.prop_i.to_s + s.const_s + s.const_f.to_s + s.serialize.to_s
#  ^ definition local 3~#3809224601
#      ^ reference local 1~#3809224601
#        ^^^^^^ reference [..] S#prop_i().
#               ^^^^ reference [..] Integer#to_s().
#                    ^ reference [..] String#+().
#                      ^ reference local 1~#3809224601
#                        ^^^^^^^ reference [..] S#const_s().
#                                ^ reference [..] String#+().
#                                  ^ reference local 1~#3809224601
#                                    ^^^^^^^ reference [..] S#const_f().
#                                            ^^^^ reference [..] Float#to_s().
#                                                 ^ reference [..] String#+().
#                                                   ^ reference local 1~#3809224601
#                                                     ^^^^^^^^^ reference [..] T#Props#Serializable#serialize().
#                                                               ^^^^ reference [..] Kernel#to_s().
   s.prop_i = 4
#  ^ reference local 1~#3809224601
#    ^^^^^^^^ reference [..] S#`prop_i=`().
   return
 end
 
 POINT = Struct.new(:x, :y) do
#^^^^^ definition [..] POINT#
#^^^^^^^^^^^^^^^^^^^^ definition [..] Struct#
#^^^^^^^^^^^^^^^^^^^^ definition local 5~#119448696
#^^^^^^^^^^^^^^^^^^^^ definition [..] POINT#initialize().
#                    ^ definition [..] POINT#`x=`().
#                    ^ definition [..] POINT#x().
#                    ^ reference [..] BasicObject#
#                        ^ definition [..] POINT#`y=`().
#                        ^ definition [..] POINT#y().
#                        ^ reference [..] BasicObject#
   def array
#      ^^^^^ definition [..] POINT#array().
     [x, y]
#     ^ reference [..] POINT#x().
#        ^ reference [..] POINT#y().
   end
 end
 
 def g
#    ^ definition [..] Object#g().
   p = POINT.new(0, 1)
#  ^ definition local 1~#3792446982
#      ^^^^^ reference [..] POINT#
#            ^^^ reference [..] Class#new().
   a = p.array
#  ^ definition local 3~#3792446982
#      ^ reference local 1~#3792446982
#        ^^^^^ reference [..] POINT#array().
   px = p.x
#  ^^ definition local 4~#3792446982
#       ^ reference local 1~#3792446982
#         ^ reference [..] POINT#x().
   return
 end
