 # typed: true
 
#⌄ enclosing_range_start [..] X#
 class X
#      ^ definition [..] X#
   alias_method :am_aaa, :aaa
#  ^^^^^^^^^^^^ reference [..] Module#alias_method().
   alias :a_aaa :aaa
 
#  ⌄ enclosing_range_start [..] X#aaa().
   def aaa
#      ^^^ definition [..] X#aaa().
     puts "AAA"
#    ^^^^ reference [..] Kernel#puts().
   end
#    ⌃ enclosing_range_end [..] X#aaa().
 
#  ⌄ enclosing_range_start [..] X#check_alias().
   def check_alias
#      ^^^^^^^^^^^ definition [..] X#check_alias().
     return [am_aaa, a_aaa]
#            ^^^^^^ reference [..] X#aaa().
#                    ^^^^^ reference [..] X#aaa().
   end
#    ⌃ enclosing_range_end [..] X#check_alias().
 end
#  ⌃ enclosing_range_end [..] X#
 
#⌄ enclosing_range_start [..] Mod1#
 module Mod1
#       ^^^^ definition [..] Mod1#
   ABC = 10
#  ^^^ definition [..] Mod1#ABC.
#  ^^^^^^^^ reference [..] Mod1#ABC.
 end
#  ⌃ enclosing_range_end [..] Mod1#
 
#⌄ enclosing_range_start [..] Mod2#
 module Mod2
#       ^^^^ definition [..] Mod2#
   FEG = Mod1::ABC
#  ^^^ definition [..] Mod2#FEG.
#  relation reference=[..] Mod1#ABC.
#        ^^^^ reference [..] Mod1#
#              ^^^ reference [..] Mod1#ABC.
#              ^^^ reference [..] Mod2#FEG.
 end
#  ⌃ enclosing_range_end [..] Mod2#
 
#⌄ enclosing_range_start [..] Object#myfunction().
 def myfunction(myparam)
#    ^^^^^^^^^^ definition [..] Object#myfunction().
#               ^^^^^^^ definition local 1$3083414419
   myparam + Mod2::FEG
#  ^^^^^^^ reference local 1$3083414419
#            ^^^^ reference [..] Mod2#
#                  ^^^ reference [..] Mod2#FEG.
 end
#  ⌃ enclosing_range_end [..] Object#myfunction().
 
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
