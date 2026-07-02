 # typed: strict
 
#⌄ enclosing_range_start [..] X#
#⌄ enclosing_range_start [..] X#serialize().
 class X < T::Enum
#      ^ definition [..] X#
#      ^ definition [..] X#serialize().
#          ^ reference [..] T#
#             ^^^^ reference [..] Module#public().
#             ^^^^ reference [..] String#
#             ^^^^ reference [..] T#Enum#
   enums do
     A = new("A")
#    ^ definition [..] X#A.
#        ^^^ reference [..] Class#new().
     B = new
#    ^ definition [..] X#B.
#        ^^^ reference [..] Class#new().
     C = B
#    ^ definition [..] X#C.
#    relation reference=[..] X#B.
#        ^ reference [..] X#B.
   end
 
   All = T.let([A, B], T::Array[X])
#  ^^^ definition [..] X#All.
#               ^ reference [..] X#A.
#                  ^ reference [..] X#B.
#                         ^^^^^^^^ definition local 4$119448696
#                               ^ reference [..] X#
 end
#  ⌃ enclosing_range_end [..] X#
#  ⌃ enclosing_range_end [..] X#serialize().
 
 # Adding more cases like this is not supported (c.f. isTEnum),
 # but let's at least add a test.
#⌄ enclosing_range_start [..] Y#
 class Y < X
#      ^ definition [..] Y#
#          ^ reference [..] X#
   enums do
     D = new
#    ^ definition [..] Y#D.
#        ^^^ reference [..] Class#new().
     E = B
#    ^ definition [..] Y#E.
#    relation reference=[..] X#B.
#    ^^^^^ reference [..] Y#E.
#        ^ reference [..] X#B.
   end
 end
#  ⌃ enclosing_range_end [..] Y#
 
#⌄ enclosing_range_start [..] Object#use_abc().
 def use_abc
#    ^^^^^^^ definition [..] Object#use_abc().
   x = X::A
#  ^ definition local 1$1971237871
#      ^ reference [..] X#
#         ^ reference [..] X#A.
   return
 end
#  ⌃ enclosing_range_end [..] Object#use_abc().
