 # typed: true
 # check-errors: true
 
#⌄ enclosing_range_start [..] IntersectionErrorLeft#
 module IntersectionErrorLeft
#       ^^^^^^^^^^^^^^^^^^^^^ definition [..] IntersectionErrorLeft#
   extend T::Sig
#  ^^^^^^ reference [..] Kernel#extend().
   sig { params(value: String).returns(String) }
#                      ^^^^^^ reference [..] String#
#                                      ^^^^^^ reference [..] String#
#  ⌄ enclosing_range_start [..] IntersectionErrorLeft#left().
   def left(value)
#      ^^^^ definition [..] IntersectionErrorLeft#left().
#           ^^^^^ definition local 1$3463365257
     value
#    ^^^^^ reference local 1$3463365257
   end
#    ⌃ enclosing_range_end [..] IntersectionErrorLeft#left().
 end
#  ⌃ enclosing_range_end [..] IntersectionErrorLeft#
 
#⌄ enclosing_range_start [..] IntersectionErrorRight#
 module IntersectionErrorRight
#       ^^^^^^^^^^^^^^^^^^^^^^ definition [..] IntersectionErrorRight#
 end
#  ⌃ enclosing_range_end [..] IntersectionErrorRight#
 
 extend T::Sig
#^^^^^^ reference [..] Kernel#extend().
#       ^ reference [..] T#
#          ^^^ reference [..] T#Sig#
 sig { params(value: T.all(IntersectionErrorLeft, IntersectionErrorRight), values: T::Array[String]).void }
#^^^ reference [..] T#Sig#sig().
#      ^^^^^^ reference [..] T#Private#Methods#DeclBuilder#params().
#                    ^ reference [..] T#
#                      ^^^ reference [..] `<Class:T>`#all().
#                          ^^^^^^^^^^^^^^^^^^^^^ reference [..] IntersectionErrorLeft#
#                                                 ^^^^^^^^^^^^^^^^^^^^^^ reference [..] IntersectionErrorRight#
#                                                                                  ^ reference [..] T#
#                                                                                     ^^^^^ reference [..] T#Array#
#                                                                                          ^ reference [..] T#`<Class:Array>`#`[]`().
#                                                                                           ^^^^^^ reference [..] String#
#                                                                                                    ^^^^ reference [..] T#Private#Methods#DeclBuilder#void().
#⌄ enclosing_range_start [..] Object#unresolved_intersection().
 def unresolved_intersection(value, values)
#    ^^^^^^^^^^^^^^^^^^^^^^^ definition [..] Object#unresolved_intersection().
#                            ^^^^^ definition local 1$4136111820
#                                   ^^^^^^ definition local 2$4136111820
   value.missing # error: Method `missing` does not exist on `IntersectionErrorLeft` component
#  ^^^^^ reference local 1$4136111820
                 # error: Method `missing` does not exist on `IntersectionErrorRight` component
   value.left(1) # error: Expected `String` but found `Integer(1)` for argument `value`
#  ^^^^^ reference local 1$4136111820
#        ^^^^ reference [..] IntersectionErrorLeft#left().
   value.left(*values) # error: Splats are only supported where the size of the array is known statically
#  ^^^^^ reference local 1$4136111820
 end
#  ⌃ enclosing_range_end [..] Object#unresolved_intersection().
