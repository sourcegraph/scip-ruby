 # typed: true
 # options: showDocs
 
 X = 'X'.freeze
#^ definition [..] X.
#documentation
#| ```ruby
#| ::X (T.untyped)
#| ```
 Y = 'Y'.freeze
#^ definition [..] Y.
#documentation
#| ```ruby
#| ::Y (T.untyped)
#| ```
 A = %w[X Y].freeze
#^ definition [..] A.
#documentation
#| ```ruby
#| ::A (T.untyped)
#| ```
 B = %W[#{X} Y].freeze
#^ definition [..] B.
#documentation
#| ```ruby
#| ::B (T.untyped)
#| ```
#         ^ reference [..] X.
 
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
#  | ::M::Z (T.untyped)
#  | ```
   A = %w[X Y Z].freeze
#  ^ definition [..] M#A.
#  documentation
#  | ```ruby
#  | ::M::A (T.untyped)
#  | ```
   B = %W[#{X} Y Z].freeze
#  ^ definition [..] M#B.
#  documentation
#  | ```ruby
#  | ::M::B (T.untyped)
#  | ```
#           ^ reference [..] X.
 end
