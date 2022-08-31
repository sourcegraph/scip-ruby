 # typed: true
 
 require 'forwardable'
 
 class MyArray1
#      ^^^^^^^^ definition [..] MyArray1#
   attr_accessor :inner_array
#  ^^^^^^^^^^^^^^^^^^^^^^^^^^ definition [..] MyArray1#inner_array().
#  ^^^^^^^^^^^^^^^^^^^^^^^^^^ definition [..] MyArray1#`inner_array=`().
   extend Forwardable
#         ^^^^^^^^^^^ reference [..] Forwardable#
   def_delegator :@inner_array, :[], :get_at_index
#  ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ definition [..] MyArray1#get_at_index().
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
 end
 
 class MyArray2
#      ^^^^^^^^ definition [..] MyArray2#
   extend T::Sig
#         ^ reference [..] T#
#            ^^^ reference [..] T#Sig#
   attr_accessor :inner_array
#  ^^^^^^^^^^^^^^^^^^^^^^^^^^ definition [..] MyArray2#inner_array().
#  ^^^^^^^^^^^^^^^^^^^^^^^^^^ definition [..] MyArray2#`inner_array=`().
   extend Forwardable
#         ^^^^^^^^^^^ reference [..] Forwardable#
   def_delegator :@inner_array, :[], :get_at_index
#  ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ definition [..] MyArray2#get_at_index().
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
 end
 
 class MyArray3
#      ^^^^^^^^ definition [..] MyArray3#
   attr_accessor :inner_array
#  ^^^^^^^^^^^^^^^^^^^^^^^^^^ definition [..] MyArray3#inner_array().
#  ^^^^^^^^^^^^^^^^^^^^^^^^^^ definition [..] MyArray3#`inner_array=`().
   extend Forwardable
#         ^^^^^^^^^^^ reference [..] Forwardable#
   def_delegators :@inner_array, :size, :<<, :map
#  ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ reference [..] `<Class:T>`#nilable().
#  ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ reference [..] Proc#
#  ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ definition [..] MyArray3#map().
#  ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ reference [..] Sorbet#Private#Static#
#  ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ reference [..] Sorbet#Private#`<Class:Static>`#sig().
#  ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ reference [..] T#
#  ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ reference [..] `<Class:T>`#untyped().
#  ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ reference [..] T#
#  ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ reference [..] `<Class:T>`#nilable().
#  ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ definition [..] MyArray3#`<<`().
#  ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ reference [..] T#
#  ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ reference [..] `<Class:T>`#untyped().
#  ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ reference [..] T#Private#Methods#DeclBuilder#returns().
#  ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ reference [..] Sorbet#Private#Static#
#  ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ reference [..] Sorbet#Private#`<Class:Static>`#sig().
#  ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ reference [..] T#
#  ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ reference [..] `<Class:T>`#untyped().
#  ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ reference [..] T#
#  ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ definition [..] MyArray3#size().
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
#  ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ reference [..] T#Private#Methods#DeclBuilder#params().
 end
 
 class MyArray4
#      ^^^^^^^^ definition [..] MyArray4#
   extend T::Sig
#         ^ reference [..] T#
#            ^^^ reference [..] T#Sig#
   attr_accessor :inner_array
#  ^^^^^^^^^^^^^^^^^^^^^^^^^^ definition [..] MyArray4#`inner_array=`().
#  ^^^^^^^^^^^^^^^^^^^^^^^^^^ definition [..] MyArray4#inner_array().
   extend Forwardable
#         ^^^^^^^^^^^ reference [..] Forwardable#
   def_delegators :@inner_array, :size, :<<, :map
#  ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ definition [..] MyArray4#size().
#  ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ reference [..] Proc#
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
#  ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ reference [..] Sorbet#Private#Static#
#  ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ definition [..] MyArray4#map().
#  ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ definition [..] MyArray4#`<<`().
#  ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ reference [..] Sorbet#Private#`<Class:Static>`#sig().
 end
