 # typed: true
 # check-errors: true
 # Adapted from test/testdata/lsp/type_member_references.rb.
 
#⌄ enclosing_range_start [..] Upper#
 class Upper
#      ^^^^^ definition [..] Upper#
   extend T::Sig, T::Generic, T::Helpers
#  ^^^^^^ reference [..] Kernel#extend().
   abstract!
   X = type_member { {upper: Numeric} }
#  ^ definition [..] Upper#X#
#                            ^^^^^^^ reference [..] Numeric#
 
   sig { abstract.returns(X) }
#                         ^ reference [..] Upper#X#
#  ⌄ enclosing_range_start [..] Upper#value().
   def value; end
#      ^^^^^ definition [..] Upper#value().
#               ⌃ enclosing_range_end [..] Upper#value().
 end
#  ⌃ enclosing_range_end [..] Upper#
 
#⌄ enclosing_range_start [..] Fixed#
 class Fixed
#      ^^^^^ definition [..] Fixed#
   extend T::Sig, T::Generic
#  ^^^^^^ reference [..] Kernel#extend().
   X = type_member { {fixed: Integer} }
#  ^ definition [..] Fixed#X#
#                            ^^^^^^^ reference [..] Integer#
 
   sig { returns(X) }
#                ^ reference [..] Fixed#X#
#  ⌄ enclosing_range_start [..] Fixed#value().
   def value
#      ^^^^^ definition [..] Fixed#value().
     1
   end
#    ⌃ enclosing_range_end [..] Fixed#value().
 end
#  ⌃ enclosing_range_end [..] Fixed#
 
#⌄ enclosing_range_start [..] Lower#
 class Lower
#      ^^^^^ definition [..] Lower#
   extend T::Sig, T::Generic
#  ^^^^^^ reference [..] Kernel#extend().
   X = type_member { {lower: Integer} }
#  ^ definition [..] Lower#X#
#                            ^^^^^^^ reference [..] Integer#
 
   sig { params(x: X).returns(X) }
#                  ^ reference [..] Lower#X#
#                             ^ reference [..] Lower#X#
#  ⌄ enclosing_range_start [..] Lower#identity().
   def identity(x)
#      ^^^^^^^^ definition [..] Lower#identity().
#               ^ definition local 1$835964821
     T.let(x, X)
#          ^ reference local 1$835964821
#             ^ reference [..] Lower#X#
   end
#    ⌃ enclosing_range_end [..] Lower#identity().
 end
#  ⌃ enclosing_range_end [..] Lower#
 
#⌄ enclosing_range_start [..] Template#
 class Template
#      ^^^^^^^^ definition [..] Template#
   extend T::Sig, T::Generic
#  ^^^^^^ reference [..] Kernel#extend().
   X = type_template { {fixed: String} }
#  ^ definition [..] `<Class:Template>`#X#
#                              ^^^^^^ reference [..] String#
 
   sig { returns(X) }
#                ^ reference [..] `<Class:Template>`#X#
#  ⌄ enclosing_range_start [..] `<Class:Template>`#value().
   def self.value
#           ^^^^^ definition [..] `<Class:Template>`#value().
     "text"
   end
#    ⌃ enclosing_range_end [..] `<Class:Template>`#value().
 end
#  ⌃ enclosing_range_end [..] Template#
 
#⌄ enclosing_range_start [..] Plain#
 class Plain
#      ^^^^^ definition [..] Plain#
   extend T::Sig, T::Generic
#  ^^^^^^ reference [..] Kernel#extend().
   X = type_member
#  ^ definition [..] Plain#X#
 
   sig { params(x: X).returns(X) }
#                  ^ reference [..] Plain#X#
#                             ^ reference [..] Plain#X#
#  ⌄ enclosing_range_start [..] Plain#identity().
   def identity(x)
#      ^^^^^^^^ definition [..] Plain#identity().
#               ^ definition local 1$861111766
     x
#    ^ reference local 1$861111766
   end
#    ⌃ enclosing_range_end [..] Plain#identity().
 end
#  ⌃ enclosing_range_end [..] Plain#
 
 Fixed.new.value.abs
#^^^^^ reference [..] Fixed#
#      ^^^ reference [..] Class#new().
#          ^^^^^ reference [..] Fixed#value().
#                ^^^ reference [..] Integer#abs().
 Lower[Numeric].new.identity(1).abs
#^^^^^ reference [..] Lower#
#     ^ reference [..] T#Generic#`[]`().
#      ^^^^^^^ reference [..] Numeric#
#                   ^^^^^^^^ reference [..] Lower#identity().
#                               ^^^ reference [..] Numeric#abs().
 Template.value.upcase
#^^^^^^^^ reference [..] Template#
#         ^^^^^ reference [..] `<Class:Template>`#value().
#               ^^^^^^ reference [..] String#upcase().
 Plain[String].new.identity("text").upcase
#^^^^^ reference [..] Plain#
#     ^ reference [..] T#Generic#`[]`().
#      ^^^^^^ reference [..] String#
#                  ^^^^^^^^ reference [..] Plain#identity().
#                                   ^^^^^^ reference [..] String#upcase().
