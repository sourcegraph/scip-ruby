 # typed: true
 
#⌄ enclosing_range_start [..] SafeNavigationReceiver#
 class SafeNavigationReceiver
#      ^^^^^^^^^^^^^^^^^^^^^^ definition [..] SafeNavigationReceiver#
   extend T::Sig
#  ^^^^^^ reference [..] Kernel#extend().
 
   sig { returns(String) }
#                ^^^^^^ reference [..] String#
#  ⌄ enclosing_range_start [..] SafeNavigationReceiver#value().
   def value; "value"; end
#      ^^^^^ definition [..] SafeNavigationReceiver#value().
#                        ⌃ enclosing_range_end [..] SafeNavigationReceiver#value().
 end
#  ⌃ enclosing_range_end [..] SafeNavigationReceiver#
 
 extend T::Sig
#^^^^^^ reference [..] Kernel#extend().
#       ^ reference [..] T#
#          ^^^ reference [..] T#Sig#
 
 sig { params(receiver: T.nilable(SafeNavigationReceiver)).void }
#^^^ reference [..] T#Sig#sig().
#      ^^^^^^ reference [..] T#Private#Methods#DeclBuilder#params().
#                       ^ reference [..] T#
#                         ^^^^^^^ reference [..] `<Class:T>`#nilable().
#                                 ^^^^^^^^^^^^^^^^^^^^^^ reference [..] SafeNavigationReceiver#
#                                                          ^^^^ reference [..] T#Private#Methods#DeclBuilder#void().
#⌄ enclosing_range_start [..] Object#optional_receiver().
 def optional_receiver(receiver)
#    ^^^^^^^^^^^^^^^^^ definition [..] Object#optional_receiver().
#                      ^^^^^^^^ definition local 1$2598614927
   receiver&.value
#  ^^^^^^^^ reference local 1$2598614927
#            ^^^^^ reference [..] SafeNavigationReceiver#value().
   receiver&.value&.upcase
#  ^^^^^^^^ reference local 1$2598614927
#            ^^^^^ reference [..] SafeNavigationReceiver#value().
#                   ^^^^^^ reference [..] String#upcase().
   value = T.let(nil, T.nilable(String))
#  ^^^^^ definition local 4$2598614927
#                     ^ reference [..] T#
#                       ^^^^^^^ reference [..] `<Class:T>`#nilable().
#                               ^^^^^^ reference [..] String#
   value ||= receiver&.value
#  ^^^^^ reference (write) local 4$2598614927
#            ^^^^^^^^ reference local 1$2598614927
#                      ^^^^^ reference [..] SafeNavigationReceiver#value().
   value &&= receiver&.value
#  ^^^^^ reference (write) local 4$2598614927
#  ^^^^^ reference local 4$2598614927
#  ^^^^^^^^^^^^^^^^^^^^^^^^^ reference local 4$2598614927
#            ^^^^^^^^ reference local 1$2598614927
#                      ^^^^^ reference [..] SafeNavigationReceiver#value().
 end
#  ⌃ enclosing_range_end [..] Object#optional_receiver().
 
 sig { params(receiver: SafeNavigationReceiver).void }
#^^^ reference [..] T#Sig#sig().
#      ^^^^^^ reference [..] T#Private#Methods#DeclBuilder#params().
#                       ^^^^^^^^^^^^^^^^^^^^^^ reference [..] SafeNavigationReceiver#
#                                               ^^^^ reference [..] T#Private#Methods#DeclBuilder#void().
#⌄ enclosing_range_start [..] Object#known_receiver().
 def known_receiver(receiver)
#    ^^^^^^^^^^^^^^ definition [..] Object#known_receiver().
#                   ^^^^^^^^ definition local 1$283871188
   receiver&.value
#  ^^^^^^^^ reference local 1$283871188
#            ^^^^^ reference [..] SafeNavigationReceiver#value().
   (receiver)&.value
#   ^^^^^^^^ reference local 1$283871188
#              ^^^^^ reference [..] SafeNavigationReceiver#value().
   receiver.value&.upcase
#  ^^^^^^^^ reference local 1$283871188
#           ^^^^^ reference [..] SafeNavigationReceiver#value().
#                  ^^^^^^ reference [..] String#upcase().
   SafeNavigationReceiver.new&.value
#  ^^^^^^^^^^^^^^^^^^^^^^ reference [..] SafeNavigationReceiver#
#                         ^^^ reference [..] Class#new().
#                              ^^^^^ reference [..] SafeNavigationReceiver#value().
   nil&.value
 end
#  ⌃ enclosing_range_end [..] Object#known_receiver().
