 # typed: true
 # check-errors: true
 
#⌄ enclosing_range_start [..] MissingDSL#
 class MissingDSL
#      ^^^^^^^^^^ definition [..] MissingDSL#
#  ⌄ enclosing_range_start [..] MissingDSL#ordinary().
   def ordinary
#      ^^^^^^^^ definition [..] MissingDSL#ordinary().
     'still indexed'
   end
#    ⌃ enclosing_range_end [..] MissingDSL#ordinary().
 end
#  ⌃ enclosing_range_end [..] MissingDSL#
 
 value = MissingDSL.new
#^^^^^ reference (write) local 1$217974539
#        ^^^^^^^^^^ reference [..] MissingDSL#
#                   ^^^ reference [..] Class#new().
 value.sig # error: Method `sig` does not exist
#^^^^^ reference local 1$217974539
 value.abstract! # error: Method `abstract!` does not exist on `MissingDSL`
#^^^^^ reference local 1$217974539
 value.final! # error: Method `final!` does not exist on `MissingDSL`
#^^^^^ reference local 1$217974539
 value.sealed! # error: Method `sealed!` does not exist on `MissingDSL`
#^^^^^ reference local 1$217974539
 value.type_member # error: Method `type_member` does not exist on `MissingDSL`
#^^^^^ reference local 1$217974539
 value.ordinary.upcase
#^^^^^ reference local 1$217974539
#      ^^^^^^^^ reference [..] MissingDSL#ordinary().
 
 # Ordinary class-level DSL use remains supported.
#⌄ enclosing_range_start [..] HasDSL#
 class HasDSL
#      ^^^^^^ definition [..] HasDSL#
   extend T::Sig
#  ^^^^^^ reference [..] Kernel#extend().
   sig { returns(String) }
#                ^^^^^^ reference [..] String#
#  ⌄ enclosing_range_start [..] HasDSL#ordinary().
   def ordinary
#      ^^^^^^^^ definition [..] HasDSL#ordinary().
     'typed'
   end
#    ⌃ enclosing_range_end [..] HasDSL#ordinary().
 end
#  ⌃ enclosing_range_end [..] HasDSL#
 HasDSL.new.ordinary.upcase
#^^^^^^ reference [..] HasDSL#
#       ^^^ reference [..] Class#new().
#           ^^^^^^^^ reference [..] HasDSL#ordinary().
#                    ^^^^^^ reference [..] String#upcase().
