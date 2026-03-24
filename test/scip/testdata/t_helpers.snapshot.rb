 # typed: true
 
 # T.must, T.assert_type!, T.absurd, T.bind. Other T.* operations
 # (T.let, T.cast, T.unsafe, T.reveal_type) are already covered elsewhere.
 
#⌄ enclosing_range_start [..] Container#
 class Container
#      ^^^^^^^^^ definition [..] Container#
   extend T::Sig
#  ^^^^^^ reference [..] Kernel#extend().
 
   sig { params(x: T.nilable(String)).returns(Integer) }
#                            ^^^^^^ reference [..] String#
#                                             ^^^^^^^ reference [..] Integer#
#  ⌄ enclosing_range_start [..] Container#use_must().
   def use_must(x)
#      ^^^^^^^^ definition [..] Container#use_must().
#               ^ definition local 1$2138952860
     T.must(x).length
#    ^ reference [..] T#
#      ^^^^ reference [..] `<Class:T>`#must().
#           ^ reference local 1$2138952860
#              ^^^^^^ reference [..] String#length().
   end
#    ⌃ enclosing_range_end [..] Container#use_must().
 
   sig { params(x: T.untyped).returns(Integer) }
#                                     ^^^^^^^ reference [..] Integer#
#  ⌄ enclosing_range_start [..] Container#use_assert_type().
   def use_assert_type(x)
#      ^^^^^^^^^^^^^^^ definition [..] Container#use_assert_type().
#                      ^ definition local 1$3012239264
     T.assert_type!(x, Integer)
#                   ^ reference local 1$3012239264
#                      ^^^^^^^ definition local 2$3012239264
#                      ^^^^^^^ reference [..] Integer#
     x + 1
#    ^ reference local 1$3012239264
   end
#    ⌃ enclosing_range_end [..] Container#use_assert_type().
 
   Variant = T.type_alias { T.any(Integer, String) }
#  ^^^^^^^ definition [..] Container#Variant.
#                                 ^^^^^^^ reference [..] Integer#
#                                          ^^^^^^ reference [..] String#
 
   sig { params(x: Variant).returns(Integer) }
#                  ^^^^^^^ reference [..] Container#Variant.
#                                   ^^^^^^^ reference [..] Integer#
#  ⌄ enclosing_range_start [..] Container#use_absurd().
   def use_absurd(x)
#      ^^^^^^^^^^ definition [..] Container#use_absurd().
#                 ^ definition local 1$4004738816
     case x
#         ^ reference local 1$4004738816
     when Integer then x + 1
#         ^^^^^^^ reference [..] Integer#
#                      ^ reference local 1$4004738816
#                        ^ reference [..] Integer#+().
     when String  then x.length
#         ^^^^^^ reference [..] String#
#                      ^ reference local 1$4004738816
#                        ^^^^^^ reference [..] String#length().
     else
       T.absurd(x)
     end
   end
#    ⌃ enclosing_range_end [..] Container#use_absurd().
 
   sig { returns(T.proc.void) }
#  ⌄ enclosing_range_start [..] Container#use_bind().
   def use_bind
#      ^^^^^^^^ definition [..] Container#use_bind().
     proc do
#    ^^^^ reference [..] Kernel#proc().
       T.bind(self, Integer)
#                   ^^^^^^^ definition local 1$1938721546
#                   ^^^^^^^ reference [..] Integer#
       _ = self + 1
#      ^ definition local 3$1938721546
#               ^ reference [..] Integer#+().
       nil
     end
   end
#    ⌃ enclosing_range_end [..] Container#use_bind().
 end
#  ⌃ enclosing_range_end [..] Container#
