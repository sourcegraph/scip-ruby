 # typed: true
 # options: showDocs
 
 require 'def_class1'
#^^^^^^^ reference [..] Kernel#require().
 
 b = C1.new.m1
#^ definition local 2~#119448696
#documentation
#| ```ruby
#| b (T::Boolean)
#| ```
#    ^^ reference [..] C1#
#       ^^^ reference [..] Class#new().
#           ^^ reference [..] C1#m1().
