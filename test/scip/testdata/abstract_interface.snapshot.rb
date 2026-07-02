 # typed: strict
 
 # Exercises abstract!, interface!, final!, sealed!, mixes_in_class_methods.
 
#⌄ enclosing_range_start [..] Drawable#
 module Drawable
#       ^^^^^^^^ definition [..] Drawable#
   extend T::Sig
#  ^^^^^^ reference [..] Kernel#extend().
   extend T::Helpers
#  ^^^^^^ reference [..] Kernel#extend().
   interface!
 
   sig { abstract.returns(String) }
#                         ^^^^^^ reference [..] String#
#  ⌄ enclosing_range_start [..] Drawable#draw().
   def draw; end
#      ^^^^ definition [..] Drawable#draw().
#              ⌃ enclosing_range_end [..] Drawable#draw().
 end
#  ⌃ enclosing_range_end [..] Drawable#
 
#⌄ enclosing_range_start [..] Shape#
 class Shape
#      ^^^^^ definition [..] Shape#
   extend T::Sig
#  ^^^^^^ reference [..] Kernel#extend().
   extend T::Helpers
#  ^^^^^^ reference [..] Kernel#extend().
   abstract!
 
   sig { abstract.returns(Integer) }
#                         ^^^^^^^ reference [..] Integer#
#  ⌄ enclosing_range_start [..] Shape#area().
   def area; end
#      ^^^^ definition [..] Shape#area().
#              ⌃ enclosing_range_end [..] Shape#area().
 end
#  ⌃ enclosing_range_end [..] Shape#
 
#⌄ enclosing_range_start [..] Square#
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
#  ⌄ enclosing_range_start [..] Square#area().
   def area
#      ^^^^ definition [..] Square#area().
     16
   end
#    ⌃ enclosing_range_end [..] Square#area().
 
   sig { override.returns(String) }
#                         ^^^^^^ reference [..] String#
#  ⌄ enclosing_range_start [..] Square#draw().
   def draw
#      ^^^^ definition [..] Square#draw().
     "square"
   end
#    ⌃ enclosing_range_end [..] Square#draw().
 end
#  ⌃ enclosing_range_end [..] Square#
 
#⌄ enclosing_range_start [..] FinalLeaf#
 class FinalLeaf
#      ^^^^^^^^^ definition [..] FinalLeaf#
   extend T::Sig
#  ^^^^^^ reference [..] Kernel#extend().
   extend T::Helpers
#  ^^^^^^ reference [..] Kernel#extend().
   final!
 
   sig(:final) { returns(Integer) }
#                        ^^^^^^^ reference [..] Integer#
#  ⌄ enclosing_range_start [..] FinalLeaf#value().
   def value
#      ^^^^^ definition [..] FinalLeaf#value().
     42
   end
#    ⌃ enclosing_range_end [..] FinalLeaf#value().
 end
#  ⌃ enclosing_range_end [..] FinalLeaf#
 
#⌄ enclosing_range_start [..] SealedHierarchy#
 module SealedHierarchy
#       ^^^^^^^^^^^^^^^ definition [..] SealedHierarchy#
   extend T::Helpers
#  ^^^^^^ reference [..] Kernel#extend().
   sealed!
 end
#  ⌃ enclosing_range_end [..] SealedHierarchy#
 
#⌄ enclosing_range_start [..] ClassMethodsMixin#
 module ClassMethodsMixin
#       ^^^^^^^^^^^^^^^^^ definition [..] ClassMethodsMixin#
   extend T::Sig
#  ^^^^^^ reference [..] Kernel#extend().
 
   sig { returns(String) }
#                ^^^^^^ reference [..] String#
#  ⌄ enclosing_range_start [..] ClassMethodsMixin#class_helper().
   def class_helper
#      ^^^^^^^^^^^^ definition [..] ClassMethodsMixin#class_helper().
     "class!"
   end
#    ⌃ enclosing_range_end [..] ClassMethodsMixin#class_helper().
 end
#  ⌃ enclosing_range_end [..] ClassMethodsMixin#
 
#⌄ enclosing_range_start [..] InstanceMethodsMixin#
 module InstanceMethodsMixin
#       ^^^^^^^^^^^^^^^^^^^^ definition [..] InstanceMethodsMixin#
   extend T::Helpers
#  ^^^^^^ reference [..] Kernel#extend().
   mixes_in_class_methods(ClassMethodsMixin)
#                         ^^^^^^^^^^^^^^^^^ reference [..] ClassMethodsMixin#
 end
#  ⌃ enclosing_range_end [..] InstanceMethodsMixin#
 
#⌄ enclosing_range_start [..] WithMixedIn#
 class WithMixedIn
#      ^^^^^^^^^^^ definition [..] WithMixedIn#
   include InstanceMethodsMixin
#  ^^^^^^^ reference [..] Module#include().
#          ^^^^^^^^^^^^^^^^^^^^ reference [..] InstanceMethodsMixin#
#          ^^^^^^^^^^^^^^^^^^^^ reference [..] InstanceMethodsMixin#
 end
#  ⌃ enclosing_range_end [..] WithMixedIn#
