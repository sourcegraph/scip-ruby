 # typed: strict
 
 # Exercises abstract!, interface!, final!, sealed!, mixes_in_class_methods.
 
 module Drawable
#       ^^^^^^^^ definition [..] Drawable#
   extend T::Sig
#  ^^^^^^ reference [..] Kernel#extend().
   extend T::Helpers
#  ^^^^^^ reference [..] Kernel#extend().
   interface!
 
   sig { abstract.returns(String) }
#                         ^^^^^^ reference [..] String#
   def draw; end
#      ^^^^ definition [..] Drawable#draw().
 end
 
 class Shape
#      ^^^^^ definition [..] Shape#
   extend T::Sig
#  ^^^^^^ reference [..] Kernel#extend().
   extend T::Helpers
#  ^^^^^^ reference [..] Kernel#extend().
   abstract!
 
   sig { abstract.returns(Integer) }
#                         ^^^^^^^ reference [..] Integer#
   def area; end
#      ^^^^ definition [..] Shape#area().
 end
 
 class Square < Shape
#      ^^^^^^ definition [..] Square#
#               ^^^^^ reference [..] Shape#
   extend T::Sig
#  ^^^^^^ reference [..] Kernel#extend().
   include Drawable
#  ^^^^^^^ reference [..] Module#include().
#          ^^^^^^^^ reference [..] Drawable#
#          ^^^^^^^^ reference [..] Drawable#
 
   sig { override.returns(Integer) }
#                         ^^^^^^^ reference [..] Integer#
   def area
#      ^^^^ definition [..] Square#area().
     16
   end
 
   sig { override.returns(String) }
#                         ^^^^^^ reference [..] String#
   def draw
#      ^^^^ definition [..] Square#draw().
     "square"
   end
 end
 
 class FinalLeaf
#      ^^^^^^^^^ definition [..] FinalLeaf#
   extend T::Sig
#  ^^^^^^ reference [..] Kernel#extend().
   extend T::Helpers
#  ^^^^^^ reference [..] Kernel#extend().
   final!
 
   sig(:final) { returns(Integer) }
#                        ^^^^^^^ reference [..] Integer#
   def value
#      ^^^^^ definition [..] FinalLeaf#value().
     42
   end
 end
 
 module SealedHierarchy
#       ^^^^^^^^^^^^^^^ definition [..] SealedHierarchy#
   extend T::Helpers
#  ^^^^^^ reference [..] Kernel#extend().
   sealed!
 end
 
 module ClassMethodsMixin
#       ^^^^^^^^^^^^^^^^^ definition [..] ClassMethodsMixin#
   extend T::Sig
#  ^^^^^^ reference [..] Kernel#extend().
 
   sig { returns(String) }
#                ^^^^^^ reference [..] String#
   def class_helper
#      ^^^^^^^^^^^^ definition [..] ClassMethodsMixin#class_helper().
     "class!"
   end
 end
 
 module InstanceMethodsMixin
#       ^^^^^^^^^^^^^^^^^^^^ definition [..] InstanceMethodsMixin#
   extend T::Helpers
#  ^^^^^^ reference [..] Kernel#extend().
   mixes_in_class_methods(ClassMethodsMixin)
#                         ^^^^^^^^^^^^^^^^^ reference [..] ClassMethodsMixin#
 end
 
 class WithMixedIn
#      ^^^^^^^^^^^ definition [..] WithMixedIn#
   include InstanceMethodsMixin
#  ^^^^^^^ reference [..] Module#include().
#          ^^^^^^^^^^^^^^^^^^^^ reference [..] InstanceMethodsMixin#
#          ^^^^^^^^^^^^^^^^^^^^ reference [..] InstanceMethodsMixin#
 end
