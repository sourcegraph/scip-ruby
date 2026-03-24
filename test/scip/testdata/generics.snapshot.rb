 # typed: true
 
 # Exercises the TypeArgument / TypeMember descriptor branches in
 # scip_indexer/SCIPSymbolRef.cc symbolForExpr (Descriptor::TypeParameter,
 # Descriptor::Type).
 
#⌄ enclosing_range_start [..] GenericBox#
 class GenericBox
#      ^^^^^^^^^^ definition [..] GenericBox#
   extend T::Sig
#  ^^^^^^ reference [..] Kernel#extend().
   extend T::Generic
#  ^^^^^^ reference [..] Kernel#extend().
 
   Elem = type_member
#  ^^^^ definition local 3$119448696
 
   sig { params(x: Elem).void }
#                  ^^^^ definition local 2$3465713227
#  ⌄ enclosing_range_start [..] GenericBox#initialize().
   def initialize(x)
#      ^^^^^^^^^^ definition [..] GenericBox#initialize().
#                 ^ definition local 1$3465713227
     @x = x
#    ^^ definition [..] GenericBox#`@x`.
#    ^^^^^^ reference [..] GenericBox#`@x`.
#         ^ reference local 1$3465713227
   end
#    ⌃ enclosing_range_end [..] GenericBox#initialize().
 
   sig { returns(Elem) }
#  ⌄ enclosing_range_start [..] GenericBox#get().
   def get
#      ^^^ definition [..] GenericBox#get().
     @x
#    ^^ reference [..] GenericBox#`@x`.
   end
#    ⌃ enclosing_range_end [..] GenericBox#get().
 end
#  ⌃ enclosing_range_end [..] GenericBox#
 
#⌄ enclosing_range_start [..] MyGenericMixin#
 module MyGenericMixin
#       ^^^^^^^^^^^^^^ definition [..] MyGenericMixin#
   extend T::Generic
#  ^^^^^^ reference [..] Kernel#extend().
 
   Item = type_member
#  ^^^^ definition local 2$119448696
 end
#  ⌃ enclosing_range_end [..] MyGenericMixin#
 
#⌄ enclosing_range_start [..] WithTypeTemplate#
 class WithTypeTemplate
#      ^^^^^^^^^^^^^^^^ definition [..] WithTypeTemplate#
   extend T::Generic
#  ^^^^^^ reference [..] Kernel#extend().
 
   Tag = type_template
#  ^^^ definition local 2$119448696
 end
#  ⌃ enclosing_range_end [..] WithTypeTemplate#
 
#⌄ enclosing_range_start [..] WithTypeParameters#
 class WithTypeParameters
#      ^^^^^^^^^^^^^^^^^^ definition [..] WithTypeParameters#
   extend T::Sig
#  ^^^^^^ reference [..] Kernel#extend().
 
   sig { type_parameters(:U).params(x: T.type_parameter(:U)).returns(T.type_parameter(:U)) }
#  ⌄ enclosing_range_start [..] WithTypeParameters#identity().
   def identity(x)
#      ^^^^^^^^ definition [..] WithTypeParameters#identity().
#               ^ definition local 1$2839884955
     x
#    ^ reference local 1$2839884955
   end
#    ⌃ enclosing_range_end [..] WithTypeParameters#identity().
 end
#  ⌃ enclosing_range_end [..] WithTypeParameters#
 
#⌄ enclosing_range_start [..] Object#use_generics().
 def use_generics
#    ^^^^^^^^^^^^ definition [..] Object#use_generics().
   box = GenericBox.new(1)
#  ^^^ definition local 1$1376823943
#        ^^^^^^^^^^ reference [..] GenericBox#
#                   ^^^ reference [..] Class#new().
   _ = box.get
#  ^ definition local 3$1376823943
#      ^^^ reference local 1$1376823943
#          ^^^ reference [..] GenericBox#get().
   _ = WithTypeParameters.new.identity(42)
#  ^ reference (write) local 3$1376823943
#      ^^^^^^^^^^^^^^^^^^ reference [..] WithTypeParameters#
#                         ^^^ reference [..] Class#new().
#                             ^^^^^^^^ reference [..] WithTypeParameters#identity().
   return
 end
#  ⌃ enclosing_range_end [..] Object#use_generics().
