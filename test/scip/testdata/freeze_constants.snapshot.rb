 # typed: true
 # options: showDocs
 
 X = 'X'.freeze
#^ definition [..] X.
#documentation
#| ```ruby
#| X (T.untyped)
#| ```
#        ^^^^^^ reference [..] String#freeze().
 Y = 'Y'.freeze
#^ definition [..] Y.
#documentation
#| ```ruby
#| Y (T.untyped)
#| ```
#        ^^^^^^ reference [..] String#freeze().
 A = %w[X Y].freeze
#^ definition [..] A.
#documentation
#| ```ruby
#| A ([String, String])
#| ```
#            ^^^^^^ reference [..] Kernel#freeze().
 B = %W[#{X} Y].freeze
#^ definition [..] B.
#documentation
#| ```ruby
#| B ([String, String])
#| ```
#         ^ reference [..] X.
#               ^^^^^^ reference [..] Kernel#freeze().
 
#⌄ enclosing_range_start [..] M#
 module M
#       ^ definition [..] M#
#       documentation
#       | ```ruby
#       | module M
#       | ```
   Z = 'Z'.freeze
#  ^ definition [..] M#Z.
#  documentation
#  | ```ruby
#  | Z (T.untyped)
#  | ```
#          ^^^^^^ reference [..] String#freeze().
   A = %w[X Y Z].freeze
#  ^ definition [..] M#A.
#  documentation
#  | ```ruby
#  | A ([String, String, String])
#  | ```
#                ^^^^^^ reference [..] Kernel#freeze().
   B = %W[#{X} Y Z].freeze
#  ^ definition [..] M#B.
#  documentation
#  | ```ruby
#  | B ([String, String, String])
#  | ```
#           ^ reference [..] X.
#                   ^^^^^^ reference [..] Kernel#freeze().
 end
#  ⌃ enclosing_range_end [..] M#
