 # typed: true
 
 class X
#      ^ definition [..] X#
   alias_method :am_aaa, :aaa
#  ^^^^^^^^^^^^ reference [..] Module#alias_method().
   alias :a_aaa :aaa
 
   def aaa
#      ^^^ definition [..] X#aaa().
     puts "AAA"
#    ^^^^ reference [..] Kernel#puts().
   end
 
   def check_alias
#      ^^^^^^^^^^^ definition [..] X#check_alias().
     return [am_aaa, a_aaa]
#            ^^^^^^ reference [..] X#aaa().
#                    ^^^^^ reference [..] X#aaa().
   end
 end
 
 module Mod1
#       ^^^^ definition [..] Mod1#
   ABC = 10
#  ^^^ definition [..] Mod1#ABC.
#  ^^^^^^^^ reference [..] Mod1#ABC.
 end
 
 module Mod2
#       ^^^^ definition [..] Mod2#
   FEG = Mod1::ABC
#  ^^^ definition [..] Mod2#FEG.
#  relation reference=[..] Mod1#ABC.
#        ^^^^ reference [..] Mod1#
#              ^^^ reference [..] Mod1#ABC.
#              ^^^ reference [..] Mod2#FEG.
 end
 
 def myfunction(myparam)
#    ^^^^^^^^^^ definition [..] Object#myfunction().
#               ^^^^^^^ definition local 1$3083414419
   myparam + Mod2::FEG
#  ^^^^^^^ reference local 1$3083414419
#            ^^^^ reference [..] Mod2#
#                  ^^^ reference [..] Mod2#FEG.
 end
 
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
#    relation reference=[..] X#B.
#    ^^^^^ reference [..] Y#E.
#        ^ reference [..] X#B.
   end
 end
