 # typed: true
 # check-errors: true
 
 # A Ruby body, even an empty one, must not acquire the old payload contract.
#⌄ enclosing_range_start [..] Gem#Version#
 class Gem::Version
#      ^^^ reference [..] Gem#
#           ^^^^^^^ definition [..] Gem#Version#
#  ⌄ enclosing_range_start [..] Gem#`<Class:Version>`#new().
   def self.new(version); end
#           ^^^ definition [..] Gem#`<Class:Version>`#new().
#                           ⌃ enclosing_range_end [..] Gem#`<Class:Version>`#new().
 end
#  ⌃ enclosing_range_end [..] Gem#Version#
 
 Gem::Version.new('2.0') >= Gem::Version.new('1.0')
#^^^ reference [..] Gem#
#     ^^^^^^^ reference [..] Gem#Version#
#             ^^^ reference [..] Gem#`<Class:Version>`#new().
#                           ^^^ reference [..] Gem#
#                                ^^^^^^^ reference [..] Gem#Version#
#                                        ^^^ reference [..] Gem#`<Class:Version>`#new().
