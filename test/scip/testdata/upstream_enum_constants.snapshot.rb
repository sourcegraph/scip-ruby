 # typed: true
 # check-errors: true
 # Adapted from test/testdata/rewriter/enum_with_constants.rb.
 
#⌄ enclosing_range_start [..] CardSuit#
#⌄ enclosing_range_start [..] CardSuit#serialize().
 class CardSuit < T::Enum
#      ^^^^^^^^ definition [..] CardSuit#
#      ^^^^^^^^ definition [..] CardSuit#serialize().
#                 ^ reference [..] T#
#                    ^^^^ reference [..] Module#public().
#                    ^^^^ reference [..] String#
#                    ^^^^ reference [..] T#Enum#
   extend T::Sig
#  ^^^^^^ reference [..] Kernel#extend().
 
   enums do
     Spades = new
#    ^^^^^^ definition [..] CardSuit#Spades.
#             ^^^ reference [..] Class#new().
     Hearts = new
#    ^^^^^^ definition [..] CardSuit#Hearts.
#             ^^^ reference [..] Class#new().
     Diamonds = new
#    ^^^^^^^^ definition [..] CardSuit#Diamonds.
#               ^^^ reference [..] Class#new().
   end
 
   Reds = T.let([Hearts, Diamonds], T::Array[CardSuit])
#  ^^^^ definition [..] CardSuit#Reds.
#                ^^^^^^ reference [..] CardSuit#Hearts.
#                        ^^^^^^^^ reference [..] CardSuit#Diamonds.
#                                            ^^^^^^^^ reference [..] CardSuit#
   Red = T.type_alias { T.any(Hearts, Diamonds) }
#  ^^^ definition [..] CardSuit#Red.
#                             ^^^^^^ reference [..] CardSuit#Hearts.
#                                     ^^^^^^^^ reference [..] CardSuit#Diamonds.
   Description = "playing cards"
#  ^^^^^^^^^^^ definition [..] CardSuit#Description.
 
   sig { returns(T::Boolean) }
#                   ^^^^^^^ reference [..] T#Boolean.
#  ⌄ enclosing_range_start [..] CardSuit#`red?`().
   def red?
#      ^^^^ definition [..] CardSuit#`red?`().
     Reds.include?(self)
#    ^^^^ reference [..] CardSuit#Reds.
#         ^^^^^^^^ reference [..] Array#`include?`().
   end
#    ⌃ enclosing_range_end [..] CardSuit#`red?`().
 
   sig { params(suit: Red).returns(String) }
#                     ^^^ reference [..] CardSuit#Red.
#                                  ^^^^^^ reference [..] String#
#  ⌄ enclosing_range_start [..] `<Class:CardSuit>`#describe_red().
   def self.describe_red(suit)
#           ^^^^^^^^^^^^ definition [..] `<Class:CardSuit>`#describe_red().
#                        ^^^^ definition local 1$2318149932
     suit.serialize
#    ^^^^ reference local 1$2318149932
#         ^^^^^^^^^ reference [..] CardSuit#serialize().
   end
#    ⌃ enclosing_range_end [..] `<Class:CardSuit>`#describe_red().
 end
#  ⌃ enclosing_range_end [..] CardSuit#
#  ⌃ enclosing_range_end [..] CardSuit#serialize().
 
 CardSuit::Hearts.red?
#^^^^^^^^ reference [..] CardSuit#
#          ^^^^^^ reference [..] CardSuit#Hearts.
#                 ^^^^ reference [..] CardSuit#`red?`().
 CardSuit::Reds.each { |suit| suit.red? }
#^^^^^^^^ reference [..] CardSuit#
#          ^^^^ reference [..] CardSuit#Reds.
#               ^^^^ reference [..] Array#each().
#                       ^^^^ definition local 3$119448696
#                             ^^^^ reference local 3$119448696
#                                  ^^^^ reference [..] CardSuit#`red?`().
 CardSuit::Description.upcase
#^^^^^^^^ reference [..] CardSuit#
#          ^^^^^^^^^^^ reference [..] CardSuit#Description.
#                      ^^^^^^ reference [..] String#upcase().
 CardSuit.describe_red(CardSuit::Diamonds).upcase
#^^^^^^^^ reference [..] CardSuit#
#         ^^^^^^^^^^^^ reference [..] `<Class:CardSuit>`#describe_red().
#                      ^^^^^^^^ reference [..] CardSuit#
#                                ^^^^^^^^ reference [..] CardSuit#Diamonds.
#                                          ^^^^^^ reference [..] String#upcase().
