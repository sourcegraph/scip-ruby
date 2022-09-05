 # typed: true
 
 require 'forwardable'
 
 class MyArray1
#      ^^^^^^^^ definition [..] MyArray1#
   attr_accessor :inner_array
#                 ^^^^^^^^^^^ definition [..] MyArray1#inner_array().
#                 ^^^^^^^^^^^ definition [..] MyArray1#`inner_array=`().
   extend Forwardable
#         ^^^^^^^^^^^ reference [..] Forwardable#
   def_delegator :@inner_array, :[], :get_at_index
#  ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ reference [..] Sorbet#Private#Static#
#  ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ reference [..] Sorbet#Private#`<Class:Static>`#sig().
#  ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ reference [..] T#
#  ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ reference [..] `<Class:T>`#untyped().
#  ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ reference [..] T#
#  ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ reference [..] `<Class:T>`#nilable().
#  ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ reference [..] T#Private#Methods#DeclBuilder#params().
#  ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ reference [..] T#
#  ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ reference [..] `<Class:T>`#untyped().
#  ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ reference [..] T#Private#Methods#DeclBuilder#returns().
#  ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ reference [..] Proc#
#                                    ^^^^^^^^^^^^^ definition [..] MyArray1#get_at_index().
 end
 
 class MyArray2
#      ^^^^^^^^ definition [..] MyArray2#
   extend T::Sig
#         ^ reference [..] T#
#            ^^^ reference [..] T#Sig#
   attr_accessor :inner_array
#                 ^^^^^^^^^^^ definition [..] MyArray2#inner_array().
#                 ^^^^^^^^^^^ definition [..] MyArray2#`inner_array=`().
   extend Forwardable
#         ^^^^^^^^^^^ reference [..] Forwardable#
   def_delegator :@inner_array, :[], :get_at_index
#  ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ reference [..] Sorbet#Private#Static#
#  ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ reference [..] Sorbet#Private#`<Class:Static>`#sig().
#  ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ reference [..] T#
#  ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ reference [..] `<Class:T>`#untyped().
#  ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ reference [..] T#
#  ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ reference [..] `<Class:T>`#nilable().
#  ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ reference [..] T#Private#Methods#DeclBuilder#params().
#  ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ reference [..] T#
#  ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ reference [..] `<Class:T>`#untyped().
#  ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ reference [..] T#Private#Methods#DeclBuilder#returns().
#  ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ reference [..] Proc#
#                                    ^^^^^^^^^^^^^ definition [..] MyArray2#get_at_index().
 end
 
 class MyArray3
#      ^^^^^^^^ definition [..] MyArray3#
   attr_accessor :inner_array
#                 ^^^^^^^^^^^ definition [..] MyArray3#inner_array().
#                 ^^^^^^^^^^^ definition [..] MyArray3#`inner_array=`().
   extend Forwardable
#         ^^^^^^^^^^^ reference [..] Forwardable#
   def_delegators :@inner_array, :size, :<<, :map
#  ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ reference [..] `<Class:T>`#nilable().
#  ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ reference [..] T#
#  ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ reference [..] Proc#
#  ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ reference [..] Sorbet#Private#Static#
#  ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ reference [..] Sorbet#Private#`<Class:Static>`#sig().
#  ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ reference [..] T#
#  ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ reference [..] `<Class:T>`#untyped().
#  ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ reference [..] T#
#  ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ reference [..] `<Class:T>`#nilable().
#  ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ reference [..] T#Private#Methods#DeclBuilder#returns().
#  ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ reference [..] T#
#  ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ reference [..] `<Class:T>`#untyped().
#  ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ reference [..] T#Private#Methods#DeclBuilder#returns().
#  ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ reference [..] Sorbet#Private#Static#
#  ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ reference [..] Sorbet#Private#`<Class:Static>`#sig().
#  ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ reference [..] T#
#  ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ reference [..] `<Class:T>`#untyped().
#  ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ reference [..] T#
#  ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ reference [..] T#Private#Methods#DeclBuilder#params().
#  ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ reference [..] T#Private#Methods#DeclBuilder#params().
#  ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ reference [..] T#
#  ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ reference [..] `<Class:T>`#untyped().
#  ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ reference [..] T#Private#Methods#DeclBuilder#returns().
#  ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ reference [..] Sorbet#Private#Static#
#  ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ reference [..] Sorbet#Private#`<Class:Static>`#sig().
#  ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ reference [..] T#
#  ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ reference [..] `<Class:T>`#untyped().
#  ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ reference [..] T#
#  ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ reference [..] `<Class:T>`#untyped().
#  ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ reference [..] T#Private#Methods#DeclBuilder#params().
#  ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ reference [..] `<Class:T>`#nilable().
#                                ^^^^^ definition [..] MyArray3#size().
#                                       ^^^ definition [..] MyArray3#`<<`().
#                                            ^^^^ definition [..] MyArray3#map().
 end
 
 class MyArray4
#      ^^^^^^^^ definition [..] MyArray4#
   extend T::Sig
#         ^ reference [..] T#
#            ^^^ reference [..] T#Sig#
   attr_accessor :inner_array
#                 ^^^^^^^^^^^ definition [..] MyArray4#`inner_array=`().
#                 ^^^^^^^^^^^ definition [..] MyArray4#inner_array().
   extend Forwardable
#         ^^^^^^^^^^^ reference [..] Forwardable#
   def_delegators :@inner_array, :size, :<<, :map
#  ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ reference [..] Proc#
#  ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ reference [..] Sorbet#Private#Static#
#  ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ reference [..] T#
#  ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ reference [..] `<Class:T>`#untyped().
#  ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ reference [..] T#
#  ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ reference [..] `<Class:T>`#nilable().
#  ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ reference [..] T#Private#Methods#DeclBuilder#params().
#  ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ reference [..] T#
#  ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ reference [..] `<Class:T>`#untyped().
#  ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ reference [..] T#Private#Methods#DeclBuilder#returns().
#  ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ reference [..] Sorbet#Private#Static#
#  ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ reference [..] Sorbet#Private#`<Class:Static>`#sig().
#  ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ reference [..] T#
#  ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ reference [..] `<Class:T>`#untyped().
#  ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ reference [..] T#
#  ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ reference [..] `<Class:T>`#nilable().
#  ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ reference [..] T#Private#Methods#DeclBuilder#params().
#  ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ reference [..] T#
#  ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ reference [..] `<Class:T>`#untyped().
#  ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ reference [..] T#Private#Methods#DeclBuilder#returns().
#  ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ reference [..] Sorbet#Private#Static#
#  ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ reference [..] Sorbet#Private#`<Class:Static>`#sig().
#  ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ reference [..] T#
#  ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ reference [..] `<Class:T>`#untyped().
#  ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ reference [..] T#
#  ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ reference [..] `<Class:T>`#nilable().
#  ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ reference [..] T#Private#Methods#DeclBuilder#params().
#  ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ reference [..] T#
#  ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ reference [..] `<Class:T>`#untyped().
#  ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ reference [..] T#Private#Methods#DeclBuilder#returns().
#  ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ reference [..] Sorbet#Private#`<Class:Static>`#sig().
#                                ^^^^^ definition [..] MyArray4#size().
#                                       ^^^ definition [..] MyArray4#`<<`().
#                                            ^^^^ definition [..] MyArray4#map().
 end
