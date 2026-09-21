 # typed: true
 # check-errors: true
 
#⌄ enclosing_range_start [..] Types#
 module Types
#       ^^^^^ definition [..] Types#
   Text = T.type_alias { String }
#  ^^^^ definition [..] Types#Text.
#                        ^^^^^^ reference [..] String#
   Checked = T.type_alias { Text }.checked(:never)
#  ^^^^^^^ definition [..] Types#Checked.
#                           ^^^^ reference [..] Types#Text.
   Other = T.type_alias { Integer }
#  ^^^^^ definition [..] Types#Other.
#                         ^^^^^^^ reference [..] Integer#
 
#  ⌄ enclosing_range_start [..] Types#Box#
   class Box
#        ^^^ definition [..] Types#Box#
     extend T::Sig, T::Generic
#    ^^^^^^ reference [..] Kernel#extend().
     Elem = type_member
#    ^^^^ definition [..] Types#Box#Elem#
   end
#    ⌃ enclosing_range_end [..] Types#Box#
 end
#  ⌃ enclosing_range_end [..] Types#
 
#⌄ enclosing_range_start [..] OtherTypes#
 module OtherTypes
#       ^^^^^^^^^^ definition [..] OtherTypes#
   Text = T.type_alias { Integer }
#  ^^^^ definition [..] OtherTypes#Text.
#                        ^^^^^^^ reference [..] Integer#
 end
#  ⌃ enclosing_range_end [..] OtherTypes#
