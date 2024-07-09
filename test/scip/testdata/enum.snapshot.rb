 # typed: struct
 
 class X < T::Enum
#      ^ reference [..] X#
#      ^ definition [..] X#
#      ^ definition [..] X#serialize().
#          ^ reference [..] T#
#             ^^^^ reference [..] Module#public().
#             ^^^^ reference [..] String#
#             ^^^^ reference [..] T#Enum#
   enums do
     A = new("A")
#    ^ definition local 2~#119448696
#    ^ definition [..] X#A#
#    ^ reference [..] X#A#
#    ^ reference [..] X#A.
#        ^^^ reference [..] Class#new().
     B = new
#    ^ definition local 5~#119448696
#    ^ definition [..] X#B#
#    ^ reference [..] X#B#
#    ^ reference [..] X#B.
#        ^^^ reference [..] Class#new().
   end
 
   All = T.let([A, B], T::Array[X])
#  ^^^ definition [..] X#All.
#               ^ reference [..] X#A.
#                  ^ reference [..] X#B.
#                         ^^^^^^^^ definition local 8~#119448696
#                               ^ reference [..] X#
 end
