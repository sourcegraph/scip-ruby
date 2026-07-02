 # typed: true
 
 # Exercises prepend and user-level extend mixin relationships;
 # the existing mixin.rb only covers include. Shared @field is used so the
 # field-inheritance / mixin-transitive code paths get a chance to surface
 # `is_reference` relationships for prepend/extend.
 
#⌄ enclosing_range_start [..] Greeter#
 module Greeter
#       ^^^^^^^ definition [..] Greeter#
#  ⌄ enclosing_range_start [..] Greeter#hello().
   def hello
#      ^^^^^ definition [..] Greeter#hello().
     "hi"
   end
#    ⌃ enclosing_range_end [..] Greeter#hello().
 
#  ⌄ enclosing_range_start [..] Greeter#set_via_greeter().
   def set_via_greeter
#      ^^^^^^^^^^^^^^^ definition [..] Greeter#set_via_greeter().
     @field = "g"
#    ^^^^^^ definition [..] Greeter#`@field`.
#    ^^^^^^^^^^^^ reference [..] Greeter#`@field`.
   end
#    ⌃ enclosing_range_end [..] Greeter#set_via_greeter().
 end
#  ⌃ enclosing_range_end [..] Greeter#
 
#⌄ enclosing_range_start [..] PrependedMod#
 module PrependedMod
#       ^^^^^^^^^^^^ definition [..] PrependedMod#
#  ⌄ enclosing_range_start [..] PrependedMod#hello().
   def hello
#      ^^^^^ definition [..] PrependedMod#hello().
     "prepended " + super
   end
#    ⌃ enclosing_range_end [..] PrependedMod#hello().
 
#  ⌄ enclosing_range_start [..] PrependedMod#set_via_prepend().
   def set_via_prepend
#      ^^^^^^^^^^^^^^^ definition [..] PrependedMod#set_via_prepend().
     @field = "p"
#    ^^^^^^ definition [..] PrependedMod#`@field`.
#    ^^^^^^^^^^^^ reference [..] PrependedMod#`@field`.
   end
#    ⌃ enclosing_range_end [..] PrependedMod#set_via_prepend().
 end
#  ⌃ enclosing_range_end [..] PrependedMod#
 
#⌄ enclosing_range_start [..] ClassyMethods#
 module ClassyMethods
#       ^^^^^^^^^^^^^ definition [..] ClassyMethods#
#  ⌄ enclosing_range_start [..] ClassyMethods#klass_hi().
   def klass_hi
#      ^^^^^^^^ definition [..] ClassyMethods#klass_hi().
     "class hi"
   end
#    ⌃ enclosing_range_end [..] ClassyMethods#klass_hi().
 end
#  ⌃ enclosing_range_end [..] ClassyMethods#
 
#⌄ enclosing_range_start [..] CombinedMix#
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
 
#  ⌄ enclosing_range_start [..] CombinedMix#read_field().
   def read_field
#      ^^^^^^^^^^ definition [..] CombinedMix#read_field().
     @field
#    ^^^^^^ reference [..] CombinedMix#`@field`.
   end
#    ⌃ enclosing_range_end [..] CombinedMix#read_field().
 end
#  ⌃ enclosing_range_end [..] CombinedMix#
 
#⌄ enclosing_range_start [..] Object#use_combined().
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
#  ⌃ enclosing_range_end [..] Object#use_combined().
