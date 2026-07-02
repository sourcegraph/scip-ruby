 # typed: true
 
 require 'forwardable'
#^^^^^^^ reference [..] Kernel#require().
 
#⌄ enclosing_range_start [..] MyArray1#
 class MyArray1
#      ^^^^^^^^ definition [..] MyArray1#
#  ⌄ enclosing_range_start [..] MyArray1#`inner_array=`().
#  ⌄ enclosing_range_start [..] MyArray1#inner_array().
   attr_accessor :inner_array
#                 ^^^^^^^^^^^ definition [..] MyArray1#`inner_array=`().
#                 ^^^^^^^^^^^ definition [..] MyArray1#inner_array().
#                           ⌃ enclosing_range_end [..] MyArray1#`inner_array=`().
#                           ⌃ enclosing_range_end [..] MyArray1#inner_array().
   extend Forwardable
#  ^^^^^^ reference [..] Kernel#extend().
#         ^^^^^^^^^^^ reference [..] Forwardable#
#  ⌄ enclosing_range_start [..] MyArray1#get_at_index().
   def_delegator :@inner_array, :[], :get_at_index
#  ^^^^^^^^^^^^^ reference [..] Forwardable#def_delegator().
#  ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ reference [..] Proc#
#                                    ^^^^^^^^^^^^^ definition [..] MyArray1#get_at_index().
#                                                ⌃ enclosing_range_end [..] MyArray1#get_at_index().
 end
#  ⌃ enclosing_range_end [..] MyArray1#
 
#⌄ enclosing_range_start [..] MyArray2#
 class MyArray2
#      ^^^^^^^^ definition [..] MyArray2#
   extend T::Sig
#  ^^^^^^ reference [..] Kernel#extend().
#  ⌄ enclosing_range_start [..] MyArray2#`inner_array=`().
#  ⌄ enclosing_range_start [..] MyArray2#inner_array().
   attr_accessor :inner_array
#                 ^^^^^^^^^^^ definition [..] MyArray2#`inner_array=`().
#                 ^^^^^^^^^^^ definition [..] MyArray2#inner_array().
#                           ⌃ enclosing_range_end [..] MyArray2#`inner_array=`().
#                           ⌃ enclosing_range_end [..] MyArray2#inner_array().
   extend Forwardable
#  ^^^^^^ reference [..] Kernel#extend().
#         ^^^^^^^^^^^ reference [..] Forwardable#
#  ⌄ enclosing_range_start [..] MyArray2#get_at_index().
   def_delegator :@inner_array, :[], :get_at_index
#  ^^^^^^^^^^^^^ reference [..] Forwardable#def_delegator().
#  ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ reference [..] Proc#
#                                    ^^^^^^^^^^^^^ definition [..] MyArray2#get_at_index().
#                                                ⌃ enclosing_range_end [..] MyArray2#get_at_index().
 end
#  ⌃ enclosing_range_end [..] MyArray2#
 
#⌄ enclosing_range_start [..] MyArray3#
 class MyArray3
#      ^^^^^^^^ definition [..] MyArray3#
#  ⌄ enclosing_range_start [..] MyArray3#`inner_array=`().
#  ⌄ enclosing_range_start [..] MyArray3#inner_array().
   attr_accessor :inner_array
#                 ^^^^^^^^^^^ definition [..] MyArray3#`inner_array=`().
#                 ^^^^^^^^^^^ definition [..] MyArray3#inner_array().
#                           ⌃ enclosing_range_end [..] MyArray3#`inner_array=`().
#                           ⌃ enclosing_range_end [..] MyArray3#inner_array().
   extend Forwardable
#  ^^^^^^ reference [..] Kernel#extend().
#         ^^^^^^^^^^^ reference [..] Forwardable#
#  ⌄ enclosing_range_start [..] MyArray3#`<<`().
#  ⌄ enclosing_range_start [..] MyArray3#map().
#  ⌄ enclosing_range_start [..] MyArray3#size().
   def_delegators :@inner_array, :size, :<<, :map
#  ^^^^^^^^^^^^^^ reference [..] Forwardable#def_delegators().
#  ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ reference [..] Proc#
#                                ^^^^^ definition [..] MyArray3#size().
#                                       ^^^ definition [..] MyArray3#`<<`().
#                                            ^^^^ definition [..] MyArray3#map().
#                                               ⌃ enclosing_range_end [..] MyArray3#`<<`().
#                                               ⌃ enclosing_range_end [..] MyArray3#map().
#                                               ⌃ enclosing_range_end [..] MyArray3#size().
 end
#  ⌃ enclosing_range_end [..] MyArray3#
 
#⌄ enclosing_range_start [..] MyArray4#
 class MyArray4
#      ^^^^^^^^ definition [..] MyArray4#
   extend T::Sig
#  ^^^^^^ reference [..] Kernel#extend().
#  ⌄ enclosing_range_start [..] MyArray4#`inner_array=`().
#  ⌄ enclosing_range_start [..] MyArray4#inner_array().
   attr_accessor :inner_array
#                 ^^^^^^^^^^^ definition [..] MyArray4#`inner_array=`().
#                 ^^^^^^^^^^^ definition [..] MyArray4#inner_array().
#                           ⌃ enclosing_range_end [..] MyArray4#`inner_array=`().
#                           ⌃ enclosing_range_end [..] MyArray4#inner_array().
   extend Forwardable
#  ^^^^^^ reference [..] Kernel#extend().
#         ^^^^^^^^^^^ reference [..] Forwardable#
#  ⌄ enclosing_range_start [..] MyArray4#`<<`().
#  ⌄ enclosing_range_start [..] MyArray4#map().
#  ⌄ enclosing_range_start [..] MyArray4#size().
   def_delegators :@inner_array, :size, :<<, :map
#  ^^^^^^^^^^^^^^ reference [..] Forwardable#def_delegators().
#  ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ reference [..] Proc#
#                                ^^^^^ definition [..] MyArray4#size().
#                                       ^^^ definition [..] MyArray4#`<<`().
#                                            ^^^^ definition [..] MyArray4#map().
#                                               ⌃ enclosing_range_end [..] MyArray4#`<<`().
#                                               ⌃ enclosing_range_end [..] MyArray4#map().
#                                               ⌃ enclosing_range_end [..] MyArray4#size().
 end
#  ⌃ enclosing_range_end [..] MyArray4#
