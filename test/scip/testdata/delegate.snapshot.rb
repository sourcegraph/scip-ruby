 # typed: true
 
#⌄ enclosing_range_start [..] MethodNameManipulation#
 class MethodNameManipulation
#      ^^^^^^^^^^^^^^^^^^^^^^ definition [..] MethodNameManipulation#
   extend T::Sig
#  ^^^^^^ reference [..] Kernel#extend().
#  ⌄ enclosing_range_start [..] MethodNameManipulation#ball().
   delegate :ball, to: :thing, private: true, allow_nil: true
#  ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ reference [..] Proc#
#           ^^^^^ definition [..] MethodNameManipulation#ball().
#                                                           ⌃ enclosing_range_end [..] MethodNameManipulation#ball().
#  ⌄ enclosing_range_start [..] MethodNameManipulation#string_bar().
#  ⌄ enclosing_range_start [..] MethodNameManipulation#string_foo().
   delegate :foo, :bar, prefix: 'string', to: :thing
#  ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ reference [..] Proc#
#           ^^^^ definition [..] MethodNameManipulation#string_foo().
#                 ^^^^ definition [..] MethodNameManipulation#string_bar().
#                                                  ⌃ enclosing_range_end [..] MethodNameManipulation#string_bar().
#                                                  ⌃ enclosing_range_end [..] MethodNameManipulation#string_foo().
#  ⌄ enclosing_range_start [..] MethodNameManipulation#symbol_bar().
#  ⌄ enclosing_range_start [..] MethodNameManipulation#symbol_foo().
   delegate :foo, :bar, prefix: :symbol, to: :thing
#  ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ reference [..] Proc#
#           ^^^^ definition [..] MethodNameManipulation#symbol_foo().
#                 ^^^^ definition [..] MethodNameManipulation#symbol_bar().
#                                                 ⌃ enclosing_range_end [..] MethodNameManipulation#symbol_bar().
#                                                 ⌃ enclosing_range_end [..] MethodNameManipulation#symbol_foo().
 
   sig {void}
#  ⌄ enclosing_range_start [..] MethodNameManipulation#usages().
   def usages
#      ^^^^^^ definition [..] MethodNameManipulation#usages().
     ball(thing: 0) {}
#    ^^^^ reference [..] MethodNameManipulation#ball().
     string_foo
#    ^^^^^^^^^^ reference [..] MethodNameManipulation#string_foo().
     string_bar
#    ^^^^^^^^^^ reference [..] MethodNameManipulation#string_bar().
     symbol_foo {}
#    ^^^^^^^^^^ reference [..] MethodNameManipulation#symbol_foo().
     symbol_bar(1, 2) {}
#    ^^^^^^^^^^ reference [..] MethodNameManipulation#symbol_bar().
   end
#    ⌃ enclosing_range_end [..] MethodNameManipulation#usages().
 end
#  ⌃ enclosing_range_end [..] MethodNameManipulation#
