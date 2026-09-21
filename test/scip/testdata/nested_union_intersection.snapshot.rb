 # typed: true
 
#⌄ enclosing_range_start [..] Labeled#
 module Labeled
#       ^^^^^^^ definition [..] Labeled#
   include Kernel
#  ^^^^^^^ reference [..] Module#include().
#          ^^^^^^ reference [..] Kernel#
#          ^^^^^^ reference [..] Kernel#
 
#  ⌄ enclosing_range_start [..] Labeled#label().
   def label
#      ^^^^^ definition [..] Labeled#label().
     "labeled"
   end
#    ⌃ enclosing_range_end [..] Labeled#label().
 end
#  ⌃ enclosing_range_end [..] Labeled#
 
#⌄ enclosing_range_start [..] Tagged#
 module Tagged
#       ^^^^^^ definition [..] Tagged#
   include Kernel
#  ^^^^^^^ reference [..] Module#include().
#          ^^^^^^ reference [..] Kernel#
#          ^^^^^^ reference [..] Kernel#
 
#  ⌄ enclosing_range_start [..] Tagged#label().
   def label
#      ^^^^^ definition [..] Tagged#label().
     "tagged"
   end
#    ⌃ enclosing_range_end [..] Tagged#label().
 end
#  ⌃ enclosing_range_end [..] Tagged#
 
#⌄ enclosing_range_start [..] Spare#
 class Spare
#      ^^^^^ definition [..] Spare#
 end
#  ⌃ enclosing_range_end [..] Spare#
 
#⌄ enclosing_range_start [..] ToySelection#
 class ToySelection
#      ^^^^^^^^^^^^ definition [..] ToySelection#
   extend T::Sig
#  ^^^^^^ reference [..] Kernel#extend().
 
   sig do
     params(entry: T.any(Labeled, Spare, Tagged), fallback: T.any(Labeled, Tagged)).void
#                        ^^^^^^^ reference [..] Labeled#
#                                 ^^^^^ reference [..] Spare#
#                                        ^^^^^^ reference [..] Tagged#
#                                                                 ^^^^^^^ reference [..] Labeled#
#                                                                          ^^^^^^ reference [..] Tagged#
   end
#  ⌄ enclosing_range_start [..] `<Class:ToySelection>`#describe().
   def self.describe(entry, fallback)
#           ^^^^^^^^ definition [..] `<Class:ToySelection>`#describe().
#                    ^^^^^ definition local 1$3187496317
#                           ^^^^^^^^ definition local 2$3187496317
     selected = if entry.nil?
#    ^^^^^^^^ definition local 3$3187496317
#                  ^^^^^ reference local 1$3187496317
#                        ^^^^ reference [..] Kernel#`nil?`().
       entry
#      ^^^^^ reference local 1$3187496317
     else
       fallback
#      ^^^^^^^^ reference local 2$3187496317
     end
     selected.label
#    ^^^^^^^^ reference local 3$3187496317
#             ^^^^^ reference [..] Labeled#label().
#             ^^^^^ reference [..] Tagged#label().
   end
#    ⌃ enclosing_range_end [..] `<Class:ToySelection>`#describe().
 end
#  ⌃ enclosing_range_end [..] ToySelection#
