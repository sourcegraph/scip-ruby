 # typed: true
 
 require 'forwardable'
#^^^^^^^ reference [..] Kernel#require().
 
 class MyArray1
#      ^^^^^^^^ definition [..] MyArray1#
   attr_accessor :inner_array
#                 ^^^^^^^^^^^ definition [..] MyArray1#`inner_array=`().
#                 ^^^^^^^^^^^ definition [..] MyArray1#inner_array().
   extend Forwardable
#  ^^^^^^ reference [..] Kernel#extend().
#         ^^^^^^^^^^^ reference [..] Forwardable#
   def_delegator :@inner_array, :[], :get_at_index
#  ^^^^^^^^^^^^^ reference [..] Forwardable#def_delegator().
#  ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ reference [..] Proc#
#                                    ^^^^^^^^^^^^^ definition [..] MyArray1#get_at_index().
 end
 
 class MyArray2
#      ^^^^^^^^ definition [..] MyArray2#
   extend T::Sig
#  ^^^^^^ reference [..] Kernel#extend().
   attr_accessor :inner_array
#                 ^^^^^^^^^^^ definition [..] MyArray2#`inner_array=`().
#                 ^^^^^^^^^^^ definition [..] MyArray2#inner_array().
   extend Forwardable
#  ^^^^^^ reference [..] Kernel#extend().
#         ^^^^^^^^^^^ reference [..] Forwardable#
   def_delegator :@inner_array, :[], :get_at_index
#  ^^^^^^^^^^^^^ reference [..] Forwardable#def_delegator().
#  ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ reference [..] Proc#
#                                    ^^^^^^^^^^^^^ definition [..] MyArray2#get_at_index().
 end
 
 class MyArray3
#      ^^^^^^^^ definition [..] MyArray3#
   attr_accessor :inner_array
#                 ^^^^^^^^^^^ definition [..] MyArray3#`inner_array=`().
#                 ^^^^^^^^^^^ definition [..] MyArray3#inner_array().
   extend Forwardable
#  ^^^^^^ reference [..] Kernel#extend().
#         ^^^^^^^^^^^ reference [..] Forwardable#
   def_delegators :@inner_array, :size, :<<, :map
#  ^^^^^^^^^^^^^^ reference [..] Forwardable#def_delegators().
#  ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ reference [..] Proc#
#                                ^^^^^ definition [..] MyArray3#size().
#                                       ^^^ definition [..] MyArray3#`<<`().
#                                            ^^^^ definition [..] MyArray3#map().
 end
 
 class MyArray4
#      ^^^^^^^^ definition [..] MyArray4#
   extend T::Sig
#  ^^^^^^ reference [..] Kernel#extend().
   attr_accessor :inner_array
#                 ^^^^^^^^^^^ definition [..] MyArray4#`inner_array=`().
#                 ^^^^^^^^^^^ definition [..] MyArray4#inner_array().
   extend Forwardable
#  ^^^^^^ reference [..] Kernel#extend().
#         ^^^^^^^^^^^ reference [..] Forwardable#
   def_delegators :@inner_array, :size, :<<, :map
#  ^^^^^^^^^^^^^^ reference [..] Forwardable#def_delegators().
#  ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ reference [..] Proc#
#                                ^^^^^ definition [..] MyArray4#size().
#                                       ^^^ definition [..] MyArray4#`<<`().
#                                            ^^^^ definition [..] MyArray4#map().
 end
