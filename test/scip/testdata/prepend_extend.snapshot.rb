 # typed: true
 
 # Exercises prepend and user-level extend mixin relationships;
 # the existing mixin.rb only covers include. Shared @field is used so the
 # field-inheritance / mixin-transitive code paths get a chance to surface
 # `is_reference` relationships for prepend/extend.
 
 module Greeter
#       ^^^^^^^ definition [..] Greeter#
   def hello
#      ^^^^^ definition [..] Greeter#hello().
     "hi"
   end
 
   def set_via_greeter
#      ^^^^^^^^^^^^^^^ definition [..] Greeter#set_via_greeter().
     @field = "g"
#    ^^^^^^ definition [..] Greeter#`@field`.
#    ^^^^^^^^^^^^ reference [..] Greeter#`@field`.
   end
 end
 
 module PrependedMod
#       ^^^^^^^^^^^^ definition [..] PrependedMod#
   def hello
#      ^^^^^ definition [..] PrependedMod#hello().
     "prepended " + super
   end
 
   def set_via_prepend
#      ^^^^^^^^^^^^^^^ definition [..] PrependedMod#set_via_prepend().
     @field = "p"
#    ^^^^^^ definition [..] PrependedMod#`@field`.
#    ^^^^^^^^^^^^ reference [..] PrependedMod#`@field`.
   end
 end
 
 module ClassyMethods
#       ^^^^^^^^^^^^^ definition [..] ClassyMethods#
   def klass_hi
#      ^^^^^^^^ definition [..] ClassyMethods#klass_hi().
     "class hi"
   end
 end
 
 class CombinedMix
#      ^^^^^^^^^^^ definition [..] CombinedMix#
   include Greeter
#  ^^^^^^^ reference [..] Module#include().
#          ^^^^^^^ reference [..] Greeter#
#          ^^^^^^^ reference [..] Greeter#
   prepend PrependedMod
#  ^^^^^^^ reference [..] Module#prepend().
#          ^^^^^^^^^^^^ reference [..] PrependedMod#
   extend ClassyMethods
#  ^^^^^^ reference [..] Kernel#extend().
#         ^^^^^^^^^^^^^ reference [..] ClassyMethods#
 
   def read_field
#      ^^^^^^^^^^ definition [..] CombinedMix#read_field().
     @field
#    ^^^^^^ reference [..] CombinedMix#`@field`.
   end
 end
 
 def use_combined
#    ^^^^^^^^^^^^ definition [..] Object#use_combined().
   c = CombinedMix.new
#  ^ definition local 1$1415327550
#      ^^^^^^^^^^^ reference [..] CombinedMix#
#                  ^^^ reference [..] Class#new().
   c.set_via_greeter
#  ^ reference local 1$1415327550
#    ^^^^^^^^^^^^^^^ reference [..] Greeter#set_via_greeter().
   c.set_via_prepend
#  ^ reference local 1$1415327550
   _ = c.hello
#  ^ definition local 3$1415327550
#      ^ reference local 1$1415327550
#        ^^^^^ reference [..] Greeter#hello().
   _ = c.read_field
#  ^ reference (write) local 3$1415327550
#      ^ reference local 1$1415327550
#        ^^^^^^^^^^ reference [..] CombinedMix#read_field().
   _ = CombinedMix.klass_hi
#  ^ reference (write) local 3$1415327550
#      ^^^^^^^^^^^ reference [..] CombinedMix#
#                  ^^^^^^^^ reference [..] ClassyMethods#klass_hi().
   return
 end
