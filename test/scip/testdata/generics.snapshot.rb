 # typed: true
 
 # Exercises the TypeArgument / TypeMember descriptor branches in
 # scip_indexer/SCIPSymbolRef.cc symbolForExpr (Descriptor::TypeParameter,
 # Descriptor::Type).
 
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
   def initialize(x)
#      ^^^^^^^^^^ definition [..] GenericBox#initialize().
#                 ^ definition local 1$3465713227
     @x = x
#    ^^ definition [..] GenericBox#`@x`.
#    ^^^^^^ reference [..] GenericBox#`@x`.
#         ^ reference local 1$3465713227
   end
 
   sig { returns(Elem) }
   def get
#      ^^^ definition [..] GenericBox#get().
     @x
#    ^^ reference [..] GenericBox#`@x`.
   end
 end
 
 module MyGenericMixin
#       ^^^^^^^^^^^^^^ definition [..] MyGenericMixin#
   extend T::Generic
#  ^^^^^^ reference [..] Kernel#extend().
 
   Item = type_member
#  ^^^^ definition local 2$119448696
 end
 
 class WithTypeTemplate
#      ^^^^^^^^^^^^^^^^ definition [..] WithTypeTemplate#
   extend T::Generic
#  ^^^^^^ reference [..] Kernel#extend().
 
   Tag = type_template
#  ^^^ definition local 2$119448696
 end
 
 class WithTypeParameters
#      ^^^^^^^^^^^^^^^^^^ definition [..] WithTypeParameters#
   extend T::Sig
#  ^^^^^^ reference [..] Kernel#extend().
 
   sig { type_parameters(:U).params(x: T.type_parameter(:U)).returns(T.type_parameter(:U)) }
   def identity(x)
#      ^^^^^^^^ definition [..] WithTypeParameters#identity().
#               ^ definition local 1$2839884955
     x
#    ^ reference local 1$2839884955
   end
 end
 
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
