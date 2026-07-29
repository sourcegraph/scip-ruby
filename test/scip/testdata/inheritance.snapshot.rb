 # typed: true
 
#⌄ enclosing_range_start [..] Z1#
 class Z1
#      ^^ definition [..] Z1#
   extend T::Sig
#  ^^^^^^ reference [..] Kernel#extend().
 
   sig { params(a: T::Boolean).void }
#                     ^^^^^^^ reference [..] T#Boolean.
#  ⌄ enclosing_range_start [..] Z1#write_f().
   def write_f(a)
#      ^^^^^^^ definition [..] Z1#write_f().
#              ^ definition local 1$1000661517
     @f = a
#    ^^ definition [..] Z1#`@f`.
#    ^^^^^^ reference [..] Z1#`@f`.
#         ^ reference local 1$1000661517
   end
#    ⌃ enclosing_range_end [..] Z1#write_f().
 
   sig { returns(T::Boolean) }
#                   ^^^^^^^ reference [..] T#Boolean.
#  ⌄ enclosing_range_start [..] Z1#`read_f?`().
   def read_f?
#      ^^^^^^^ definition [..] Z1#`read_f?`().
     @f
#    ^^ reference [..] Z1#`@f`.
   end
#    ⌃ enclosing_range_end [..] Z1#`read_f?`().
 end
#  ⌃ enclosing_range_end [..] Z1#
 
#⌄ enclosing_range_start [..] Z2#
 class Z2
#      ^^ definition [..] Z2#
   extend T::Sig
#  ^^^^^^ reference [..] Kernel#extend().
 
   sig { returns(T::Boolean) }
#                   ^^^^^^^ reference [..] T#Boolean.
#  ⌄ enclosing_range_start [..] Z2#`read_f?`().
   def read_f?
#      ^^^^^^^ definition [..] Z2#`read_f?`().
     @f
#    ^^ reference [..] Z2#`@f`.
   end
#    ⌃ enclosing_range_end [..] Z2#`read_f?`().
 
   sig { params(a: T::Boolean).void }
#                     ^^^^^^^ reference [..] T#Boolean.
#  ⌄ enclosing_range_start [..] Z2#write_f().
   def write_f(a)
#      ^^^^^^^ definition [..] Z2#write_f().
#              ^ definition local 1$1000661517
     @f = a
#    ^^ definition [..] Z2#`@f`.
#    ^^^^^^ reference [..] Z2#`@f`.
#         ^ reference local 1$1000661517
   end
#    ⌃ enclosing_range_end [..] Z2#write_f().
 end
#  ⌃ enclosing_range_end [..] Z2#
 
#⌄ enclosing_range_start [..] Z3#
 class Z3 < Z1
#      ^^ definition [..] Z3#
#           ^^ reference [..] Z1#
   extend T::Sig
#  ^^^^^^ reference [..] Kernel#extend().
 
   sig { returns(T::Boolean) }
#                   ^^^^^^^ reference [..] T#Boolean.
#  ⌄ enclosing_range_start [..] Z3#`read_f_plus_1?`().
   def read_f_plus_1?
#      ^^^^^^^^^^^^^^ definition [..] Z3#`read_f_plus_1?`().
     @f + 1
#    ^^ reference [..] Z3#`@f`.
#    relation definition=[..] Z1#`@f`.
   end
#    ⌃ enclosing_range_end [..] Z3#`read_f_plus_1?`().
 end
#  ⌃ enclosing_range_end [..] Z3#
 
#⌄ enclosing_range_start [..] Z4#
 class Z4 < Z3
#      ^^ definition [..] Z4#
#           ^^ reference [..] Z3#
   extend T::Sig
#  ^^^^^^ reference [..] Kernel#extend().
 
   sig { params(a: T::Boolean).void }
#                     ^^^^^^^ reference [..] T#Boolean.
#  ⌄ enclosing_range_start [..] Z4#write_f_plus_1().
   def write_f_plus_1(a)
#      ^^^^^^^^^^^^^^ definition [..] Z4#write_f_plus_1().
#                     ^ definition local 1$3337417690
     write_f(a)
#    ^^^^^^^ reference [..] Z1#write_f().
#            ^ reference local 1$3337417690
     @f = read_f_plus_1?
#    ^^ definition [..] Z4#`@f`.
#    relation definition=[..] Z1#`@f`.
#    ^^^^^^^^^^^^^^^^^^^ reference [..] Z4#`@f`.
#    relation definition=[..] Z1#`@f`.
#         ^^^^^^^^^^^^^^ reference [..] Z3#`read_f_plus_1?`().
   end
#    ⌃ enclosing_range_end [..] Z4#write_f_plus_1().
 end
#  ⌃ enclosing_range_end [..] Z4#
 
 Z5 = Object
#^^ definition [..] Z5.
#relation reference=[..] Object#
#^^^^^^^^^^^ reference [..] Z5.
#     ^^^^^^ reference [..] Object#
 class Z6 < Z5
#      ^^ definition [..] Z6#
 end
 
