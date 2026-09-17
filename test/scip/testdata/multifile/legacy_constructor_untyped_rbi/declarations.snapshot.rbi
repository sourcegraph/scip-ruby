 # typed: true
 
#⌄ enclosing_range_start [..] Gem#Version#
 class Gem::Version
#      ^^^ reference [..] Gem#
#           ^^^^^^^ definition [..] Gem#Version#
   extend T::Sig
#  ^^^^^^ reference [..] Kernel#extend().
   sig { params(version: String).returns(T.untyped) }
#                        ^^^^^^ reference [..] String#
#  ⌄ enclosing_range_start [..] Gem#`<Class:Version>`#new().
   def self.new(version); end
#           ^^^ definition [..] Gem#`<Class:Version>`#new().
#                           ⌃ enclosing_range_end [..] Gem#`<Class:Version>`#new().
 end
#  ⌃ enclosing_range_end [..] Gem#Version#
