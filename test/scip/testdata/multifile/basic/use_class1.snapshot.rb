 # typed: true
 # options: showDocs
 
 require 'def_class1'
 
 b = C1.new.m1
#^ definition local 2~#119448696
#documentation
#| ```ruby
#| b = T.let(_, T::Boolean)
#| ```
#    ^^ reference [..] C1#
#           ^^ reference [..] C1#m1().
