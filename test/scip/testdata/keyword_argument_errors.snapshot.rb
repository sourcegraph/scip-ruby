 # typed: true
 # check-errors: true
 
#⌄ enclosing_range_start [..] KeywordErrors#
 class KeywordErrors
#      ^^^^^^^^^^^^^ definition [..] KeywordErrors#
   extend T::Sig
#  ^^^^^^ reference [..] Kernel#extend().
   sig { params(customer: String).void }
#                         ^^^^^^ reference [..] String#
#  ⌄ enclosing_range_start [..] KeywordErrors#deliver().
   def deliver(customer:)
#      ^^^^^^^ definition [..] KeywordErrors#deliver().
#              ^^^^^^^^ definition [..] KeywordErrors#deliver().(customer)
   end
#    ⌃ enclosing_range_end [..] KeywordErrors#deliver().
 end
#  ⌃ enclosing_range_end [..] KeywordErrors#
 
 receiver = KeywordErrors.new
#^^^^^^^^ definition local 1$119448696
#           ^^^^^^^^^^^^^ reference [..] KeywordErrors#
#                         ^^^ reference [..] Class#new().
 receiver.deliver(customer: "Ada", missing: "x") # error: Unrecognized keyword argument `missing` passed for method `KeywordErrors#deliver`
#^^^^^^^^ reference local 1$119448696
#         ^^^^^^^ reference [..] KeywordErrors#deliver().
#                 ^^^^^^^^ reference [..] KeywordErrors#deliver().(customer)
 receiver.deliver(customer: 1) # error: Expected `String` but found `Integer(1)` for argument `customer`
#^^^^^^^^ reference local 1$119448696
#         ^^^^^^^ reference [..] KeywordErrors#deliver().
#                 ^^^^^^^^ reference [..] KeywordErrors#deliver().(customer)
