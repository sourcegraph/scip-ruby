 # typed: true
 # check-errors: true
 # Adapted from test/testdata/infer/t_module_all.rb and any_all_module_type_parameter.rb.
 
#⌄ enclosing_range_start [..] IntersectionLeft#
 module IntersectionLeft
#       ^^^^^^^^^^^^^^^^ definition [..] IntersectionLeft#
   extend T::Sig
#  ^^^^^^ reference [..] Kernel#extend().
 
   sig { params(value: String, block: T.nilable(T.proc.returns(String))).returns(String) }
#                      ^^^^^^ reference [..] String#
#                                                              ^^^^^^ reference [..] String#
#                                                                                ^^^^^^ reference [..] String#
#  ⌄ enclosing_range_start [..] IntersectionLeft#left().
   def left(value, &block)
#      ^^^^ definition [..] IntersectionLeft#left().
#           ^^^^^ definition local 1$1752170827
     value
#    ^^^^^ reference local 1$1752170827
   end
#    ⌃ enclosing_range_end [..] IntersectionLeft#left().
 
   sig { params(key: String).returns(String) }
#                    ^^^^^^ reference [..] String#
#                                    ^^^^^^ reference [..] String#
#  ⌄ enclosing_range_start [..] IntersectionLeft#shared().
   def shared(key:)
#      ^^^^^^ definition [..] IntersectionLeft#shared().
#             ^^^ definition [..] IntersectionLeft#shared().(key)
     key
#    ^^^ reference [..] IntersectionLeft#shared().(key)
   end
#    ⌃ enclosing_range_end [..] IntersectionLeft#shared().
 
   sig { returns(String) }
#                ^^^^^^ reference [..] String#
#  ⌄ enclosing_range_start [..] IntersectionLeft#title().
   def title
#      ^^^^^ definition [..] IntersectionLeft#title().
     "left"
   end
#    ⌃ enclosing_range_end [..] IntersectionLeft#title().
 
   sig { params(index: Integer).returns(String) }
#                      ^^^^^^^ reference [..] Integer#
#                                       ^^^^^^ reference [..] String#
#  ⌄ enclosing_range_start [..] IntersectionLeft#`[]`().
   def [](index)
#      ^^ definition [..] IntersectionLeft#`[]`().
     "left"
   end
#    ⌃ enclosing_range_end [..] IntersectionLeft#`[]`().
 
   alias copied left
 end
#  ⌃ enclosing_range_end [..] IntersectionLeft#
 
#⌄ enclosing_range_start [..] IntersectionRight#
 module IntersectionRight
#       ^^^^^^^^^^^^^^^^^ definition [..] IntersectionRight#
   extend T::Sig
#  ^^^^^^ reference [..] Kernel#extend().
 
   sig { params(value: String).returns(String) }
#                      ^^^^^^ reference [..] String#
#                                      ^^^^^^ reference [..] String#
#  ⌄ enclosing_range_start [..] IntersectionRight#right().
   def right(value)
#      ^^^^^ definition [..] IntersectionRight#right().
#            ^^^^^ definition local 1$2927309087
     value
#    ^^^^^ reference local 1$2927309087
   end
#    ⌃ enclosing_range_end [..] IntersectionRight#right().
 
   sig { params(key: String).returns(String) }
#                    ^^^^^^ reference [..] String#
#                                    ^^^^^^ reference [..] String#
#  ⌄ enclosing_range_start [..] IntersectionRight#shared().
   def shared(key:)
#      ^^^^^^ definition [..] IntersectionRight#shared().
#             ^^^ definition [..] IntersectionRight#shared().(key)
     key
#    ^^^ reference [..] IntersectionRight#shared().(key)
   end
#    ⌃ enclosing_range_end [..] IntersectionRight#shared().
 
   sig { params(index: Integer, value: String).void }
#                      ^^^^^^^ reference [..] Integer#
#                                      ^^^^^^ reference [..] String#
#  ⌄ enclosing_range_start [..] IntersectionRight#`[]=`().
   def []=(index, value)
#      ^^^ definition [..] IntersectionRight#`[]=`().
   end
#    ⌃ enclosing_range_end [..] IntersectionRight#`[]=`().
 end
#  ⌃ enclosing_range_end [..] IntersectionRight#
 
#⌄ enclosing_range_start [..] IntersectionThird#
 module IntersectionThird
#       ^^^^^^^^^^^^^^^^^ definition [..] IntersectionThird#
   extend T::Sig
#  ^^^^^^ reference [..] Kernel#extend().
   sig { params(key: String).returns(String) }
#                    ^^^^^^ reference [..] String#
#                                    ^^^^^^ reference [..] String#
#  ⌄ enclosing_range_start [..] IntersectionThird#shared().
   def shared(key:)
#      ^^^^^^ definition [..] IntersectionThird#shared().
#             ^^^ definition [..] IntersectionThird#shared().(key)
     key
#    ^^^ reference [..] IntersectionThird#shared().(key)
   end
#    ⌃ enclosing_range_end [..] IntersectionThird#shared().
 end
#  ⌃ enclosing_range_end [..] IntersectionThird#
 
#⌄ enclosing_range_start [..] IntersectionMarker#
 module IntersectionMarker
#       ^^^^^^^^^^^^^^^^^^ definition [..] IntersectionMarker#
 end
#  ⌃ enclosing_range_end [..] IntersectionMarker#
 
#⌄ enclosing_range_start [..] IntersectionParent#
 module IntersectionParent
#       ^^^^^^^^^^^^^^^^^^ definition [..] IntersectionParent#
   extend T::Sig
#  ^^^^^^ reference [..] Kernel#extend().
   sig { returns(String) }
#                ^^^^^^ reference [..] String#
#  ⌄ enclosing_range_start [..] IntersectionParent#inherited().
   def inherited
#      ^^^^^^^^^ definition [..] IntersectionParent#inherited().
     "parent"
   end
#    ⌃ enclosing_range_end [..] IntersectionParent#inherited().
 end
#  ⌃ enclosing_range_end [..] IntersectionParent#
 
#⌄ enclosing_range_start [..] IntersectionChildA#
 module IntersectionChildA
#       ^^^^^^^^^^^^^^^^^^ definition [..] IntersectionChildA#
   include IntersectionParent
#  ^^^^^^^ reference [..] Module#include().
#          ^^^^^^^^^^^^^^^^^^ reference [..] IntersectionParent#
#          ^^^^^^^^^^^^^^^^^^ reference [..] IntersectionParent#
 end
#  ⌃ enclosing_range_end [..] IntersectionChildA#
 
#⌄ enclosing_range_start [..] IntersectionChildB#
 module IntersectionChildB
#       ^^^^^^^^^^^^^^^^^^ definition [..] IntersectionChildB#
   include IntersectionParent
#  ^^^^^^^ reference [..] Module#include().
#          ^^^^^^^^^^^^^^^^^^ reference [..] IntersectionParent#
#          ^^^^^^^^^^^^^^^^^^ reference [..] IntersectionParent#
 end
#  ⌃ enclosing_range_end [..] IntersectionChildB#
 
#⌄ enclosing_range_start [..] IntersectionCalls#
 class IntersectionCalls
#      ^^^^^^^^^^^^^^^^^ definition [..] IntersectionCalls#
   extend T::Sig
#  ^^^^^^ reference [..] Kernel#extend().
 
   sig { params(value: T.all(IntersectionLeft, IntersectionRight)).void }
#                            ^^^^^^^^^^^^^^^^ reference [..] IntersectionLeft#
#                                              ^^^^^^^^^^^^^^^^^ reference [..] IntersectionRight#
#  ⌄ enclosing_range_start [..] IntersectionCalls#overlap().
   def overlap(value)
#      ^^^^^^^ definition [..] IntersectionCalls#overlap().
#              ^^^^^ definition local 1$1164048121
     value.left("a").upcase
#    ^^^^^ reference local 1$1164048121
#          ^^^^ reference [..] IntersectionLeft#left().
#                    ^^^^^^ reference [..] String#upcase().
     value.right("b").upcase
#    ^^^^^ reference local 1$1164048121
#          ^^^^^ reference [..] IntersectionRight#right().
#                     ^^^^^^ reference [..] String#upcase().
     value.shared(key: "overlap").upcase
#    ^^^^^ reference local 1$1164048121
#          ^^^^^^ reference [..] IntersectionLeft#shared().
#          ^^^^^^ reference [..] IntersectionRight#shared().
#                 ^^^ reference [..] IntersectionLeft#shared().(key)
#                 ^^^ reference [..] IntersectionRight#shared().(key)
#                                 ^^^^^^ reference [..] String#upcase().
     value.copied("c")
#    ^^^^^ reference local 1$1164048121
#          ^^^^^^ reference [..] IntersectionLeft#left().
   end
#    ⌃ enclosing_range_end [..] IntersectionCalls#overlap().
 
   sig { params(value: T.all(IntersectionChildA, IntersectionChildB)).void }
#                            ^^^^^^^^^^^^^^^^^^ reference [..] IntersectionChildA#
#                                                ^^^^^^^^^^^^^^^^^^ reference [..] IntersectionChildB#
#  ⌄ enclosing_range_start [..] IntersectionCalls#inherited().
   def inherited(value)
#      ^^^^^^^^^ definition [..] IntersectionCalls#inherited().
#                ^^^^^ definition local 1$3889930068
     value.inherited.upcase
#    ^^^^^ reference local 1$3889930068
#          ^^^^^^^^^ reference [..] IntersectionParent#inherited().
#                    ^^^^^^ reference [..] String#upcase().
   end
#    ⌃ enclosing_range_end [..] IntersectionCalls#inherited().
 
   sig { params(value: T.all(T.any(IntersectionLeft, IntersectionMarker), IntersectionRight)).void }
#                                  ^^^^^^^^^^^^^^^^ reference [..] IntersectionLeft#
#                                                    ^^^^^^^^^^^^^^^^^^ reference [..] IntersectionMarker#
#                                                                         ^^^^^^^^^^^^^^^^^ reference [..] IntersectionRight#
#  ⌄ enclosing_range_start [..] IntersectionCalls#incomplete_branch().
   def incomplete_branch(value)
#      ^^^^^^^^^^^^^^^^^ definition [..] IntersectionCalls#incomplete_branch().
#                        ^^^^^ definition local 1$3666353779
     # Distribution keeps Right in both branches and Left in the overlapping branch.
     value.shared(key: "discard-left")
#    ^^^^^ reference local 1$3666353779
#          ^^^^^^ reference [..] IntersectionLeft#shared().
#          ^^^^^^ reference [..] IntersectionRight#shared().
#                 ^^^ reference [..] IntersectionLeft#shared().(key)
#                 ^^^ reference [..] IntersectionRight#shared().(key)
   end
#    ⌃ enclosing_range_end [..] IntersectionCalls#incomplete_branch().
 
   sig { params(value: T.all(IntersectionRight, T.any(IntersectionLeft, IntersectionMarker))).void }
#                            ^^^^^^^^^^^^^^^^^ reference [..] IntersectionRight#
#                                                     ^^^^^^^^^^^^^^^^ reference [..] IntersectionLeft#
#                                                                       ^^^^^^^^^^^^^^^^^^ reference [..] IntersectionMarker#
#  ⌄ enclosing_range_start [..] IntersectionCalls#reversed_incomplete_branch().
   def reversed_incomplete_branch(value)
#      ^^^^^^^^^^^^^^^^^^^^^^^^^^ definition [..] IntersectionCalls#reversed_incomplete_branch().
#                                 ^^^^^ definition local 1$2865993482
     value.shared(key: "discard-reversed")
#    ^^^^^ reference local 1$2865993482
#          ^^^^^^ reference [..] IntersectionLeft#shared().
#          ^^^^^^ reference [..] IntersectionRight#shared().
#                 ^^^ reference [..] IntersectionLeft#shared().(key)
#                 ^^^ reference [..] IntersectionRight#shared().(key)
   end
#    ⌃ enclosing_range_end [..] IntersectionCalls#reversed_incomplete_branch().
 
   sig { params(value: T.all(T.any(IntersectionLeft, IntersectionThird), IntersectionRight)).void }
#                                  ^^^^^^^^^^^^^^^^ reference [..] IntersectionLeft#
#                                                    ^^^^^^^^^^^^^^^^^ reference [..] IntersectionThird#
#                                                                        ^^^^^^^^^^^^^^^^^ reference [..] IntersectionRight#
#  ⌄ enclosing_range_start [..] IntersectionCalls#complete_branches().
   def complete_branches(value)
#      ^^^^^^^^^^^^^^^^^ definition [..] IntersectionCalls#complete_branches().
#                        ^^^^^ definition local 1$418533310
     value.shared(key: "complete")
#    ^^^^^ reference local 1$418533310
#          ^^^^^^ reference [..] IntersectionLeft#shared().
#          ^^^^^^ reference [..] IntersectionRight#shared().
#          ^^^^^^ reference [..] IntersectionThird#shared().
#                 ^^^ reference [..] IntersectionLeft#shared().(key)
#                 ^^^ reference [..] IntersectionRight#shared().(key)
#                 ^^^ reference [..] IntersectionThird#shared().(key)
   end
#    ⌃ enclosing_range_end [..] IntersectionCalls#complete_branches().
 
   sig { params(value: T.any(T.all(IntersectionLeft, IntersectionRight), IntersectionThird)).void }
#                                  ^^^^^^^^^^^^^^^^ reference [..] IntersectionLeft#
#                                                    ^^^^^^^^^^^^^^^^^ reference [..] IntersectionRight#
#                                                                        ^^^^^^^^^^^^^^^^^ reference [..] IntersectionThird#
#  ⌄ enclosing_range_start [..] IntersectionCalls#nested_union().
   def nested_union(value)
#      ^^^^^^^^^^^^ definition [..] IntersectionCalls#nested_union().
#                   ^^^^^ definition local 1$3190820961
     value.shared(key: "nested-union")
#    ^^^^^ reference local 1$3190820961
#          ^^^^^^ reference [..] IntersectionLeft#shared().
#          ^^^^^^ reference [..] IntersectionRight#shared().
#          ^^^^^^ reference [..] IntersectionThird#shared().
#                 ^^^ reference [..] IntersectionLeft#shared().(key)
#                 ^^^ reference [..] IntersectionRight#shared().(key)
#                 ^^^ reference [..] IntersectionThird#shared().(key)
   end
#    ⌃ enclosing_range_end [..] IntersectionCalls#nested_union().
 
   sig { params(value: T.any(IntersectionLeft, IntersectionThird)).void }
#                            ^^^^^^^^^^^^^^^^ reference [..] IntersectionLeft#
#                                              ^^^^^^^^^^^^^^^^^ reference [..] IntersectionThird#
#  ⌄ enclosing_range_start [..] IntersectionCalls#ordinary_union().
   def ordinary_union(value)
#      ^^^^^^^^^^^^^^ definition [..] IntersectionCalls#ordinary_union().
#                     ^^^^^ definition local 1$1328153896
     value.shared(key: "ordinary-union")
#    ^^^^^ reference local 1$1328153896
#          ^^^^^^ reference [..] IntersectionLeft#shared().
#          ^^^^^^ reference [..] IntersectionThird#shared().
#                 ^^^ reference [..] IntersectionLeft#shared().(key)
#                 ^^^ reference [..] IntersectionThird#shared().(key)
   end
#    ⌃ enclosing_range_end [..] IntersectionCalls#ordinary_union().
 
   sig { params(mod: T.all(T::Module[IntersectionLeft], IntersectionRight)).void }
#                                    ^^^^^^^^^^^^^^^^ reference [..] IntersectionLeft#
#                                                       ^^^^^^^^^^^^^^^^^ reference [..] IntersectionRight#
#  ⌄ enclosing_range_start [..] IntersectionCalls#module_receiver().
   def module_receiver(mod)
#      ^^^^^^^^^^^^^^^ definition [..] IntersectionCalls#module_receiver().
#                      ^^^ definition local 1$2206775946
     mod.name
#    ^^^ reference local 1$2206775946
#        ^^^^ reference [..] Module#name().
     mod.ancestors
#    ^^^ reference local 1$2206775946
#        ^^^^^^^^^ reference [..] Module#ancestors().
     mod.instance_method(:left).name
#    ^^^ reference local 1$2206775946
#        ^^^^^^^^^^^^^^^ reference [..] Module#instance_method().
#                               ^^^^ reference [..] UnboundMethod#name().
     mod.right("module")
#    ^^^ reference local 1$2206775946
#        ^^^^^ reference [..] IntersectionRight#right().
   end
#    ⌃ enclosing_range_end [..] IntersectionCalls#module_receiver().
 
   sig { params(value: T.all(IntersectionLeft, IntersectionRight), block: T.proc.returns(String)).void }
#                            ^^^^^^^^^^^^^^^^ reference [..] IntersectionLeft#
#                                              ^^^^^^^^^^^^^^^^^ reference [..] IntersectionRight#
#                                                                                        ^^^^^^ reference [..] String#
#  ⌄ enclosing_range_start [..] IntersectionCalls#wrapped().
   def wrapped(value, &block)
#      ^^^^^^^ definition [..] IntersectionCalls#wrapped().
#              ^^^^^ definition local 1$73509159
#                      ^^^^^ definition local 2$73509159
     value.left("a", &block)
#    ^^^^^ reference local 1$73509159
#          ^^^^ reference [..] IntersectionLeft#left().
#                     ^^^^^ reference local 2$73509159
     value.left(*["b"])
#    ^^^^^ reference local 1$73509159
#          ^^^^ reference [..] IntersectionLeft#left().
     value.left(*["c"], &block)
#    ^^^^^ reference local 1$73509159
#          ^^^^ reference [..] IntersectionLeft#left().
#                        ^^^^^ reference local 2$73509159
     value.left(*["d"]) { "block" }
#    ^^^^^ reference local 1$73509159
#          ^^^^ reference [..] IntersectionLeft#left().
     value.left(
#    ^^^^^ reference local 1$73509159
#          ^^^^ reference [..] IntersectionLeft#left().
       *["multiline"],
       &block
#       ^^^^^ reference local 2$73509159
     )
     [value].map(&:title)
#     ^^^^^ reference local 1$73509159
#            ^^^ reference [..] Array#map().
#                  ^^^^^ reference [..] IntersectionLeft#title().
     [value].map(&:"title")
#     ^^^^^ reference local 1$73509159
#            ^^^ reference [..] Array#map().
#                   ^^^^^ reference [..] IntersectionLeft#title().
     [value].map(&:'title')
#     ^^^^^ reference local 1$73509159
#            ^^^ reference [..] Array#map().
#                   ^^^^^ reference [..] IntersectionLeft#title().
     value[0]
#    ^^^^^ reference local 1$73509159
#         ^ reference [..] IntersectionLeft#`[]`().
     value[*[0]]
#    ^^^^^ reference local 1$73509159
#         ^ reference [..] IntersectionLeft#`[]`().
     value.[](*[0])
#    ^^^^^ reference local 1$73509159
#          ^^ reference [..] IntersectionLeft#`[]`().
     value[0] = "a"
#    ^^^^^ reference local 1$73509159
#         ^ reference [..] IntersectionRight#`[]=`().
     value[*[0]] = "b"
#    ^^^^^ reference local 1$73509159
#         ^ reference [..] IntersectionRight#`[]=`().
     value.[]=(*[0, "c"])
#    ^^^^^ reference local 1$73509159
#          ^^^ reference [..] IntersectionRight#`[]=`().
   end
#    ⌃ enclosing_range_end [..] IntersectionCalls#wrapped().
 end
#  ⌃ enclosing_range_end [..] IntersectionCalls#
 
#⌄ enclosing_range_start [..] IntersectionBox#
 class IntersectionBox
#      ^^^^^^^^^^^^^^^ definition [..] IntersectionBox#
   extend T::Sig
#  ^^^^^^ reference [..] Kernel#extend().
   extend T::Generic
#  ^^^^^^ reference [..] Kernel#extend().
   Elem = type_member { {upper: T.all(IntersectionLeft, IntersectionRight)} }
#  ^^^^ definition [..] IntersectionBox#Elem#
#                                     ^^^^^^^^^^^^^^^^ reference [..] IntersectionLeft#
#                                                       ^^^^^^^^^^^^^^^^^ reference [..] IntersectionRight#
 
   sig { params(value: Elem).void }
#                      ^^^^ reference [..] IntersectionBox#Elem#
#  ⌄ enclosing_range_start [..] IntersectionBox#bounded().
   def bounded(value)
#      ^^^^^^^ definition [..] IntersectionBox#bounded().
#              ^^^^^ definition local 1$1790903679
     value.left("bounded")
#    ^^^^^ reference local 1$1790903679
#          ^^^^ reference [..] IntersectionLeft#left().
     value.right("bounded")
#    ^^^^^ reference local 1$1790903679
#          ^^^^^ reference [..] IntersectionRight#right().
     value.shared(key: "bounded")
#    ^^^^^ reference local 1$1790903679
#          ^^^^^^ reference [..] IntersectionLeft#shared().
#          ^^^^^^ reference [..] IntersectionRight#shared().
#                 ^^^ reference [..] IntersectionLeft#shared().(key)
#                 ^^^ reference [..] IntersectionRight#shared().(key)
     value.left(*["bounded-splat"])
#    ^^^^^ reference local 1$1790903679
#          ^^^^ reference [..] IntersectionLeft#left().
   end
#    ⌃ enclosing_range_end [..] IntersectionBox#bounded().
 end
#  ⌃ enclosing_range_end [..] IntersectionBox#
