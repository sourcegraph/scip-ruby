 # typed: true
 # check-errors: true
 
 extend T::Sig
#^^^^^^ reference [..] Kernel#extend().
#       ^ reference [..] T#
#          ^^^ reference [..] T#Sig#
 sig { params(value: T.all(CrossIntersectionLeft, CrossIntersectionRight)).void }
#^^^ reference [..] T#Sig#sig().
#      ^^^^^^ reference [..] T#Private#Methods#DeclBuilder#params().
#                    ^ reference [..] T#
#                      ^^^ reference [..] `<Class:T>`#all().
#                          ^^^^^^^^^^^^^^^^^^^^^ reference [..] CrossIntersectionLeft#
#                                                 ^^^^^^^^^^^^^^^^^^^^^^ reference [..] CrossIntersectionRight#
#                                                                          ^^^^ reference [..] T#Private#Methods#DeclBuilder#void().
#⌄ enclosing_range_start [..] Object#cross_intersection().
 def cross_intersection(value)
#    ^^^^^^^^^^^^^^^^^^ definition [..] Object#cross_intersection().
#                       ^^^^^ definition local 1$3062284895
   value.left.upcase
#  ^^^^^ reference local 1$3062284895
#        ^^^^ reference [..] CrossIntersectionLeft#left().
#             ^^^^^^ reference [..] String#upcase().
   value.right.upcase
#  ^^^^^ reference local 1$3062284895
#        ^^^^^ reference [..] CrossIntersectionRight#right().
#              ^^^^^^ reference [..] String#upcase().
 end
#  ⌃ enclosing_range_end [..] Object#cross_intersection().
