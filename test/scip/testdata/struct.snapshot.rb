 # typed: true
 
 # From Sorbet docs https://sorbet.org/docs/tstruct
 class S < T::Struct
#      ^ definition [..] S#
#          ^ reference [..] T#
#             ^^^^^^ reference [..] T#Private#Methods#DeclBuilder#params().
#             ^^^^^^ reference [..] Sorbet#Private#`<Class:Static>`#sig().
#             ^^^^^^ reference [..] Sorbet#Private#Static#
#             ^^^^^^ definition [..] S#initialize().
#             ^^^^^^ definition [..] T#Struct#
#             ^^^^^^ reference [..] T#Private#Methods#DeclBuilder#void().
   prop :prop_i, Integer
#  ^^^^^^^^^^^^^^^^^^^^^ reference [..] Sorbet#Private#Static#
#  ^^^^^^^^^^^^^^^^^^^^^ reference [..] T#Private#Methods#DeclBuilder#returns().
#  ^^^^^^^^^^^^^^^^^^^^^ reference [..] T#Private#Methods#DeclBuilder#params().
#  ^^^^^^^^^^^^^^^^^^^^^ reference [..] Sorbet#Private#`<Class:Static>`#sig().
#  ^^^^^^^^^^^^^^^^^^^^^ reference [..] T#Private#Methods#DeclBuilder#returns().
#  ^^^^^^^^^^^^^^^^^^^^^ reference [..] Sorbet#Private#`<Class:Static>`#sig().
#  ^^^^^^^^^^^^^^^^^^^^^ reference [..] Sorbet#Private#Static#
#        ^^^^^^ definition [..] S#`prop_i=`().
#        ^^^^^^ definition [..] S#prop_i().
#                ^^^^^^^ reference [..] Integer#
#                ^^^^^^^ reference [..] Integer#
#                ^^^^^^^ reference [..] Integer#
#                ^^^^^^^ reference [..] Integer#
#                ^^^^^^^ reference [..] Integer#
   const :const_s, T.nilable(String)
#  ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ reference [..] T#Private#Methods#DeclBuilder#returns().
#  ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ reference [..] Sorbet#Private#`<Class:Static>`#sig().
#  ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ reference [..] Sorbet#Private#Static#
#         ^^^^^^^ definition [..] S#const_s().
#                  ^ reference [..] T#
#                  ^ reference [..] T#
#                  ^ reference [..] T#
#                    ^^^^^^^ reference [..] `<Class:T>`#nilable().
#                    ^^^^^^^ reference [..] `<Class:T>`#nilable().
#                    ^^^^^^^ reference [..] `<Class:T>`#nilable().
#                            ^^^^^^ reference [..] String#
#                            ^^^^^^ reference [..] String#
#                            ^^^^^^ reference [..] String#
   const :const_f, Float, default: 0.5
#  ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ reference [..] T#Private#Methods#DeclBuilder#returns().
#  ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ reference [..] Sorbet#Private#`<Class:Static>`#sig().
#  ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ reference [..] Sorbet#Private#Static#
#         ^^^^^^^ definition [..] S#const_f().
#                  ^^^^^ reference [..] Float#
#                  ^^^^^ reference [..] Float#
#                  ^^^^^ reference [..] Float#
 end
 
 def f
#    ^ definition [..] Object#f().
   s = S.new(prop_i: 3)
#  ^ definition local 1~#3809224601
#      ^ reference [..] S#
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
   s.prop_i = 4
#  ^ reference local 1~#3809224601
#    ^^^^^^^^ reference [..] S#`prop_i=`().
   return
 end
 
 POINT = Struct.new(:x, :y) do
#^^^^^ definition [..] POINT#
#^^^^^^^^^^^^^^^^^^^^ definition [..] Struct#
#^^^^^^^^^^^^^^^^^^^^ definition [..] POINT#initialize().
#^^^^^^^^^^^^^^^^^^^^ reference [..] `<Class:T>`#untyped().
#^^^^^^^^^^^^^^^^^^^^ reference [..] T#
#^^^^^^^^^^^^^^^^^^^^ reference [..] T#Private#Methods#DeclBuilder#void().
#^^^^^^^^^^^^^^^^^^^^ reference [..] T#Private#Methods#DeclBuilder#params().
#^^^^^^^^^^^^^^^^^^^^ reference [..] Sorbet#Private#`<Class:Static>`#sig().
#^^^^^^^^^^^^^^^^^^^^ reference [..] Sorbet#Private#Static#
#^^^^^^^^^^^^^^^^^^^^ definition local 5~#119448696
#                    ^ definition [..] POINT#x().
#                    ^ definition [..] POINT#`x=`().
#                    ^ reference [..] BasicObject#
#                        ^ definition [..] POINT#y().
#                        ^ definition [..] POINT#`y=`().
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
