 # typed: strict
 
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
#        ^ reference [..] X#B.
   end
 
   All = T.let([A, B], T::Array[X])
#  ^^^ definition [..] X#All.
#               ^ reference [..] X#A.
#                  ^ reference [..] X#B.
#                         ^^^^^^^^ definition local 4~#119448696
#                               ^ reference [..] X#
 end
 
 # Adding more cases like this is not supported (c.f. isTEnum),
 # but let's at least add a test.
 class Y < X
#      ^ definition [..] Y#
#          ^ reference [..] X#
   enums do
     D = new
#    ^ definition [..] Y#D.
#        ^^^ reference [..] Class#new().
     E = B
#    ^ definition [..] Y#E.
#    ^^^^^ reference [..] Y#E.
#        ^ reference [..] X#B.
   end
 end
 
 def use_abc
#    ^^^^^^^ definition [..] Object#use_abc().
   x = X::A
#  ^ definition local 1~#1971237871
#      ^ reference [..] X#
#         ^ reference [..] X#A.
   return
 end
