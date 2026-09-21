 # typed: true
 
 # Current payload RBIs mark these methods abstract. Older payloads did not,
 # so indexing a checked-in sorbet-runtime must still visit their Ruby bodies.
#⌄ enclosing_range_start [..] T#Types#Base#
 class T::Types::Base
#      ^ reference [..] T#
#         ^^^^^ reference [..] T#Types#
#                ^^^^ definition [..] T#Types#Base#
#  ⌄ enclosing_range_start [..] T#Types#Base#`valid?`().
   def valid?(obj)
#      ^^^^^^ definition [..] T#Types#Base#`valid?`().
     raise NotImplementedError
#    ^^^^^ reference [..] Kernel#raise().
#          ^^^^^^^^^^^^^^^^^^^ reference [..] NotImplementedError#
   end
#    ⌃ enclosing_range_end [..] T#Types#Base#`valid?`().
 
#  ⌄ enclosing_range_start [..] T#Types#Base#name().
   def name
#      ^^^^ definition [..] T#Types#Base#name().
     value = "abstract".upcase
#    ^^^^^ definition local 1$1894959141
#                       ^^^^^^ reference [..] String#upcase().
     value
#    ^^^^^ reference local 1$1894959141
   end
#    ⌃ enclosing_range_end [..] T#Types#Base#name().
 end
#  ⌃ enclosing_range_end [..] T#Types#Base#
 
#⌄ enclosing_range_start [..] AbstractBody#
 class AbstractBody
#      ^^^^^^^^^^^^ definition [..] AbstractBody#
   extend T::Sig
#  ^^^^^^ reference [..] Kernel#extend().
   extend T::Helpers
#  ^^^^^^ reference [..] Kernel#extend().
   abstract!
 
   sig { abstract.params(value: String).returns(String) }
#                               ^^^^^^ reference [..] String#
#                                               ^^^^^^ reference [..] String#
#  ⌄ enclosing_range_start [..] AbstractBody#render().
   def render(value = "default".upcase)
#      ^^^^^^ definition [..] AbstractBody#render().
#             ^^^^^ definition local 1$117847832
#                               ^^^^^^ reference [..] String#upcase().
     value.strip
#    ^^^^^ reference local 1$117847832
#          ^^^^^ reference [..] String#strip().
   end
#    ⌃ enclosing_range_end [..] AbstractBody#render().
 end
#  ⌃ enclosing_range_end [..] AbstractBody#
 
 # Empty declarations have no handwritten body to index.
#⌄ enclosing_range_start [..] EmptyAbstractBody#
 class EmptyAbstractBody
#      ^^^^^^^^^^^^^^^^^ definition [..] EmptyAbstractBody#
   extend T::Sig, T::Helpers
#  ^^^^^^ reference [..] Kernel#extend().
   abstract!
   sig { abstract.returns(String) }
#                         ^^^^^^ reference [..] String#
#  ⌄ enclosing_range_start [..] EmptyAbstractBody#name().
   def name; end
#      ^^^^ definition [..] EmptyAbstractBody#name().
#              ⌃ enclosing_range_end [..] EmptyAbstractBody#name().
 end
#  ⌃ enclosing_range_end [..] EmptyAbstractBody#
