 # typed: true
 
 # 3+-level constant qualifier walks in class names, ancestors, and references.
 # Exercises the recursion in saveQualifierReferences.
 
#⌄ enclosing_range_start [..] Outer#
 module Outer
#       ^^^^^ definition [..] Outer#
#  ⌄ enclosing_range_start [..] Outer#Inner#
   module Inner
#         ^^^^^ definition [..] Outer#Inner#
#    ⌄ enclosing_range_start [..] Outer#Inner#Deep#
     module Deep
#           ^^^^ definition [..] Outer#Inner#Deep#
#      ⌄ enclosing_range_start [..] Outer#Inner#Deep#Base#
       class Base
#            ^^^^ definition [..] Outer#Inner#Deep#Base#
#        ⌄ enclosing_range_start [..] Outer#Inner#Deep#Base#m().
         def m; end
#            ^ definition [..] Outer#Inner#Deep#Base#m().
#                 ⌃ enclosing_range_end [..] Outer#Inner#Deep#Base#m().
       end
#        ⌃ enclosing_range_end [..] Outer#Inner#Deep#Base#
 
#      ⌄ enclosing_range_start [..] Outer#Inner#Deep#Mixin#
       module Mixin
#             ^^^^^ definition [..] Outer#Inner#Deep#Mixin#
#        ⌄ enclosing_range_start [..] Outer#Inner#Deep#Mixin#helper().
         def helper
#            ^^^^^^ definition [..] Outer#Inner#Deep#Mixin#helper().
           "h"
         end
#          ⌃ enclosing_range_end [..] Outer#Inner#Deep#Mixin#helper().
       end
#        ⌃ enclosing_range_end [..] Outer#Inner#Deep#Mixin#
     end
#      ⌃ enclosing_range_end [..] Outer#Inner#Deep#
   end
#    ⌃ enclosing_range_end [..] Outer#Inner#
 end
#  ⌃ enclosing_range_end [..] Outer#
 
 # 4-level qualifier in class header and in superclass position.
#⌄ enclosing_range_start [..] Outer#Inner#Deep#Derived#
 class Outer::Inner::Deep::Derived < Outer::Inner::Deep::Base
#      ^^^^^ reference [..] Outer#
#             ^^^^^ reference [..] Outer#Inner#
#                    ^^^^ reference [..] Outer#Inner#Deep#
#                          ^^^^^^^ definition [..] Outer#Inner#Deep#Derived#
#                                    ^^^^^ reference [..] Outer#
#                                           ^^^^^ reference [..] Outer#Inner#
#                                                  ^^^^ reference [..] Outer#Inner#Deep#
#                                                        ^^^^ reference [..] Outer#Inner#Deep#Base#
 end
#  ⌃ enclosing_range_end [..] Outer#Inner#Deep#Derived#
 
 # Qualified include in an ancestor expression.
#⌄ enclosing_range_start [..] WithDeepMixin#
 class WithDeepMixin
#      ^^^^^^^^^^^^^ definition [..] WithDeepMixin#
   include Outer::Inner::Deep::Mixin
#  ^^^^^^^ reference [..] Module#include().
#          ^^^^^ reference [..] Outer#
#                 ^^^^^ reference [..] Outer#Inner#
#                 ^^^^^ reference [..] Outer#Inner#
#                        ^^^^ reference [..] Outer#Inner#Deep#
#                        ^^^^ reference [..] Outer#Inner#Deep#
#                              ^^^^^ reference [..] Outer#Inner#Deep#Mixin#
#                              ^^^^^ reference [..] Outer#Inner#Deep#Mixin#
 end
#  ⌃ enclosing_range_end [..] WithDeepMixin#
 
#⌄ enclosing_range_start [..] Object#use_nested().
 def use_nested
#    ^^^^^^^^^^ definition [..] Object#use_nested().
   _ = Outer::Inner::Deep::Base.new
#  ^ definition local 1$4031378110
#      ^^^^^ reference [..] Outer#
#             ^^^^^ reference [..] Outer#Inner#
#                    ^^^^ reference [..] Outer#Inner#Deep#
#                          ^^^^ reference [..] Outer#Inner#Deep#Base#
#                               ^^^ reference [..] Class#new().
   _ = WithDeepMixin.new.helper
#  ^ reference (write) local 1$4031378110
#      ^^^^^^^^^^^^^ reference [..] WithDeepMixin#
#                    ^^^ reference [..] Class#new().
#                        ^^^^^^ reference [..] Outer#Inner#Deep#Mixin#helper().
   return
 end
#  ⌃ enclosing_range_end [..] Object#use_nested().
