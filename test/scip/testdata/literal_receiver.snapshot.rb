 # typed: true
 # options: showDocs
 
 extend T::Sig
#^^^^^^ reference [..] Kernel#extend().
#       ^ reference [..] T#
#          ^^^ reference [..] T#Sig#
 
 sig { params(part: String).void }
#^^^ reference [..] T#Sig#sig().
#      ^^^^^^ reference [..] T#Private#Methods#DeclBuilder#params().
#                   ^^^^^^ reference [..] String#
#                           ^^^^ reference [..] T#Private#Methods#DeclBuilder#void().
#⌄ enclosing_range_start [..] Object#literal_receiver().
 def literal_receiver(part)
#    ^^^^^^^^^^^^^^^^ definition [..] Object#literal_receiver().
#    documentation
#    | ```ruby
#    | sig { params(part: String).void }
#    | def literal_receiver(part)
#    | ```
#                     ^^^^ definition local 1$2133361660
#                     documentation
#                     | ```ruby
#                     | part (String)
#                     | ```
   plain = String.new
#  ^^^^^ definition local 2$2133361660
#  documentation
#  | ```ruby
#  | plain (String)
#  | ```
#          ^^^^^^ reference [..] String#
#                 ^^^ reference [..] Class#new().
   plain << part
#  ^^^^^ reference local 2$2133361660
#        ^^ reference [..] String#`<<`().
#           ^^^^ reference local 1$2133361660
   literal = +""
#  ^^^^^^^ definition local 4$2133361660
#  documentation
#  | ```ruby
#  | literal (String(""))
#  | ```
#            ^ reference [..] String#`+@`().
   literal << part
#  ^^^^^^^ reference local 4$2133361660
#          ^^ reference [..] String#`<<`().
#             ^^^^ reference local 1$2133361660
   "literal".upcase
#            ^^^^^^ reference [..] String#upcase().
   :name.to_s
#        ^^^^ reference [..] Symbol#to_s().
   42.abs
#     ^^^ reference [..] Integer#abs().
   1.5.floor
#      ^^^^^ reference [..] Float#floor().
 end
#  ⌃ enclosing_range_end [..] Object#literal_receiver().
