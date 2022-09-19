 # typed: true
 
 class Z1
#      ^^ definition [..] Z1#
   extend T::Sig
#  ^^^^^^ reference [..] Kernel#extend().
 
   sig { params(a: T::Boolean).void }
#                     ^^^^^^^ reference [..] T#Boolean.
   def write_f(a)
#      ^^^^^^^ definition [..] Z1#write_f().
#              ^ definition local 1~#1000661517
     @f = a
#    ^^ definition [..] Z1#`@f`.
#    ^^^^^^ reference [..] Z1#`@f`.
#         ^ reference local 1~#1000661517
   end
 
   sig { returns(T::Boolean) }
#                   ^^^^^^^ reference [..] T#Boolean.
   def read_f?
#      ^^^^^^^ definition [..] Z1#`read_f?`().
     @f
#    ^^ reference [..] Z1#`@f`.
   end
 end
 
 class Z2
#      ^^ definition [..] Z2#
   extend T::Sig
#  ^^^^^^ reference [..] Kernel#extend().
 
   sig { returns(T::Boolean) }
#                   ^^^^^^^ reference [..] T#Boolean.
   def read_f?
#      ^^^^^^^ definition [..] Z2#`read_f?`().
     @f
#    ^^ reference [..] Z2#`@f`.
   end
 
   sig { params(a: T::Boolean).void }
#                     ^^^^^^^ reference [..] T#Boolean.
   def write_f(a)
#      ^^^^^^^ definition [..] Z2#write_f().
#              ^ definition local 1~#1000661517
     @f = a
#    ^^ definition [..] Z2#`@f`.
#    ^^^^^^ reference [..] Z2#`@f`.
#         ^ reference local 1~#1000661517
   end
 end
 
 class Z3 < Z1
#      ^^ definition [..] Z3#
#           ^^ definition [..] Z1#
   extend T::Sig
#  ^^^^^^ reference [..] Kernel#extend().
 
   sig { returns(T::Boolean) }
#                   ^^^^^^^ reference [..] T#Boolean.
   def read_f_plus_1?
#      ^^^^^^^^^^^^^^ definition [..] Z3#`read_f_plus_1?`().
     @f + 1
#    ^^ reference [..] Z1#`@f`.
   end
 end
 
 class Z4 < Z3
#      ^^ definition [..] Z4#
#           ^^ definition [..] Z3#
   extend T::Sig
#  ^^^^^^ reference [..] Kernel#extend().
 
   sig { params(a: T::Boolean).void }
#                     ^^^^^^^ reference [..] T#Boolean.
   def write_f_plus_1(a)
#      ^^^^^^^^^^^^^^ definition [..] Z4#write_f_plus_1().
#                     ^ definition local 1~#3337417690
     write_f(a)
#    ^^^^^^^ reference [..] Z1#write_f().
#            ^ reference local 1~#3337417690
     @f = read_f_plus_1?
#    ^^ definition [..] Z1#`@f`.
#    ^^^^^^^^^^^^^^^^^^^ reference [..] Z1#`@f`.
#         ^^^^^^^^^^^^^^ reference [..] Z3#`read_f_plus_1?`().
   end
 end
 
