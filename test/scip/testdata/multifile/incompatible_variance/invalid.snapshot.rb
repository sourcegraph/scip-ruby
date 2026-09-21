 # typed: true
 # check-errors: true
 
#⌄ enclosing_range_start [..] Producer#
 class Producer
#      ^^^^^^^^ definition [..] Producer#
   extend T::Generic
#  ^^^^^^ reference [..] Kernel#extend().
   Elem = type_member(:out)
#  ^^^^ definition [..] Producer#Elem#
#  ⌄ enclosing_range_start [..] Producer#parent_method().
   def parent_method; end
#      ^^^^^^^^^^^^^ definition [..] Producer#parent_method().
#                       ⌃ enclosing_range_end [..] Producer#parent_method().
 end
#  ⌃ enclosing_range_end [..] Producer#
 
#⌄ enclosing_range_start [..] InvalidConsumer#
 class InvalidConsumer < Producer
#      ^^^^^^^^^^^^^^^ definition [..] InvalidConsumer#
#                        ^^^^^^^^ reference [..] Producer#
   Elem = type_member(:in) # error: Type variance mismatch for `Elem` with parent `Producer`
#  ^^^^ definition [..] InvalidConsumer#Elem#
#  ⌄ enclosing_range_start [..] InvalidConsumer#child_method().
   def child_method; end
#      ^^^^^^^^^^^^ definition [..] InvalidConsumer#child_method().
#                      ⌃ enclosing_range_end [..] InvalidConsumer#child_method().
 end
#  ⌃ enclosing_range_end [..] InvalidConsumer#
 
 extend T::Sig
#^^^^^^ reference [..] Kernel#extend().
#       ^ reference [..] T#
#          ^^^ reference [..] T#Sig#
 sig { params(forward: T.all(InvalidConsumer[Object], Producer[String]), reverse: T.all(Producer[String], InvalidConsumer[Object])).void }
#^^^ reference [..] T#Sig#sig().
#      ^^^^^^ reference [..] T#Private#Methods#DeclBuilder#params().
#                      ^ reference [..] T#
#                        ^^^ reference [..] `<Class:T>`#all().
#                            ^^^^^^^^^^^^^^^ reference [..] InvalidConsumer#
#                                           ^ reference [..] T#Generic#`[]`().
#                                            ^^^^^^ reference [..] Object#
#                                                     ^^^^^^^^ reference [..] Producer#
#                                                             ^ reference [..] T#Generic#`[]`().
#                                                              ^^^^^^ reference [..] String#
#                                                                                 ^ reference [..] T#
#                                                                                   ^^^ reference [..] `<Class:T>`#all().
#                                                                                       ^^^^^^^^ reference [..] Producer#
#                                                                                               ^ reference [..] T#Generic#`[]`().
#                                                                                                ^^^^^^ reference [..] String#
#                                                                                                         ^^^^^^^^^^^^^^^ reference [..] InvalidConsumer#
#                                                                                                                        ^ reference [..] T#Generic#`[]`().
#                                                                                                                         ^^^^^^ reference [..] Object#
#                                                                                                                                   ^^^^ reference [..] T#Private#Methods#DeclBuilder#void().
#⌄ enclosing_range_start [..] Object#narrow().
 def narrow(forward, reverse)
#    ^^^^^^ definition [..] Object#narrow().
#           ^^^^^^^ definition local 1$3150883420
#                    ^^^^^^^ definition local 2$3150883420
   forward.parent_method
#  ^^^^^^^ reference local 1$3150883420
#          ^^^^^^^^^^^^^ reference [..] Producer#parent_method().
   forward.child_method
#  ^^^^^^^ reference local 1$3150883420
#          ^^^^^^^^^^^^ reference [..] InvalidConsumer#child_method().
   reverse.parent_method
#  ^^^^^^^ reference local 2$3150883420
#          ^^^^^^^^^^^^^ reference [..] Producer#parent_method().
   reverse.child_method
#  ^^^^^^^ reference local 2$3150883420
#          ^^^^^^^^^^^^ reference [..] InvalidConsumer#child_method().
 end
#  ⌃ enclosing_range_end [..] Object#narrow().
 
#⌄ enclosing_range_start [..] Consumer#
 class Consumer
#      ^^^^^^^^ definition [..] Consumer#
   extend T::Generic
#  ^^^^^^ reference [..] Kernel#extend().
   Elem = type_member(:in)
#  ^^^^ definition [..] Consumer#Elem#
#  ⌄ enclosing_range_start [..] Consumer#parent_method().
   def parent_method; end
#      ^^^^^^^^^^^^^ definition [..] Consumer#parent_method().
#                       ⌃ enclosing_range_end [..] Consumer#parent_method().
 end
#  ⌃ enclosing_range_end [..] Consumer#
 
#⌄ enclosing_range_start [..] InvalidProducer#
 class InvalidProducer < Consumer
#      ^^^^^^^^^^^^^^^ definition [..] InvalidProducer#
#                        ^^^^^^^^ reference [..] Consumer#
   Elem = type_member(:out) # error: Type variance mismatch for `Elem` with parent `Consumer`
#  ^^^^ definition [..] InvalidProducer#Elem#
#  ⌄ enclosing_range_start [..] InvalidProducer#child_method().
   def child_method; end
#      ^^^^^^^^^^^^ definition [..] InvalidProducer#child_method().
#                      ⌃ enclosing_range_end [..] InvalidProducer#child_method().
 end
#  ⌃ enclosing_range_end [..] InvalidProducer#
 
 sig { params(forward: T.all(InvalidProducer[String], Consumer[Object]), reverse: T.all(Consumer[Object], InvalidProducer[String])).void }
#^^^ reference [..] T#Sig#sig().
#      ^^^^^^ reference [..] T#Private#Methods#DeclBuilder#params().
#                      ^ reference [..] T#
#                        ^^^ reference [..] `<Class:T>`#all().
#                            ^^^^^^^^^^^^^^^ reference [..] InvalidProducer#
#                                           ^ reference [..] T#Generic#`[]`().
#                                            ^^^^^^ reference [..] String#
#                                                     ^^^^^^^^ reference [..] Consumer#
#                                                             ^ reference [..] T#Generic#`[]`().
#                                                              ^^^^^^ reference [..] Object#
#                                                                                 ^ reference [..] T#
#                                                                                   ^^^ reference [..] `<Class:T>`#all().
#                                                                                       ^^^^^^^^ reference [..] Consumer#
#                                                                                               ^ reference [..] T#Generic#`[]`().
#                                                                                                ^^^^^^ reference [..] Object#
#                                                                                                         ^^^^^^^^^^^^^^^ reference [..] InvalidProducer#
#                                                                                                                        ^ reference [..] T#Generic#`[]`().
#                                                                                                                         ^^^^^^ reference [..] String#
#                                                                                                                                   ^^^^ reference [..] T#Private#Methods#DeclBuilder#void().
#⌄ enclosing_range_start [..] Object#widen().
 def widen(forward, reverse)
#    ^^^^^ definition [..] Object#widen().
#          ^^^^^^^ definition local 1$2673922734
#                   ^^^^^^^ definition local 2$2673922734
   forward.parent_method
#  ^^^^^^^ reference local 1$2673922734
#          ^^^^^^^^^^^^^ reference [..] Consumer#parent_method().
   forward.child_method
#  ^^^^^^^ reference local 1$2673922734
#          ^^^^^^^^^^^^ reference [..] InvalidProducer#child_method().
   reverse.parent_method
#  ^^^^^^^ reference local 2$2673922734
#          ^^^^^^^^^^^^^ reference [..] Consumer#parent_method().
   reverse.child_method
#  ^^^^^^^ reference local 2$2673922734
#          ^^^^^^^^^^^^ reference [..] InvalidProducer#child_method().
 end
#  ⌃ enclosing_range_end [..] Object#widen().
