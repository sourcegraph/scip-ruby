 # typed: true
 
 # 3+-level constant qualifier walks in class names, ancestors, and references.
 # Exercises the recursion in saveQualifierReferences.
 
 module Outer
#       ^^^^^ definition [..] Outer#
   module Inner
#         ^^^^^ definition [..] Outer#Inner#
     module Deep
#           ^^^^ definition [..] Outer#Inner#Deep#
       class Base
#            ^^^^ definition [..] Outer#Inner#Deep#Base#
         def m; end
#            ^ definition [..] Outer#Inner#Deep#Base#m().
       end
 
       module Mixin
#             ^^^^^ definition [..] Outer#Inner#Deep#Mixin#
         def helper
#            ^^^^^^ definition [..] Outer#Inner#Deep#Mixin#helper().
           "h"
         end
       end
     end
   end
 end
 
 # 4-level qualifier in class header and in superclass position.
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
 
 # Qualified include in an ancestor expression.
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
