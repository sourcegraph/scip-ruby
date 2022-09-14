 # typed: true
 
 class MethodNameManipulation
#      ^^^^^^^^^^^^^^^^^^^^^^ definition [..] MethodNameManipulation#
   extend T::Sig
#  ^^^^^^ reference [..] Kernel#extend().
   delegate :ball, to: :thing, private: true, allow_nil: true
#  ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ reference [..] Proc#
#           ^^^^^ definition [..] MethodNameManipulation#ball().
   delegate :foo, :bar, prefix: 'string', to: :thing
#  ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ reference [..] Proc#
#           ^^^^ definition [..] MethodNameManipulation#string_foo().
#                 ^^^^ definition [..] MethodNameManipulation#string_bar().
   delegate :foo, :bar, prefix: :symbol, to: :thing
#  ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ reference [..] Proc#
#           ^^^^ definition [..] MethodNameManipulation#symbol_foo().
#                 ^^^^ definition [..] MethodNameManipulation#symbol_bar().
 
   sig {void}
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
 end
