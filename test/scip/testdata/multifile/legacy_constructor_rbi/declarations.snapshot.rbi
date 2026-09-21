 # typed: true
 
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
 
#⌄ enclosing_range_start [..] OtherFactory#
 class OtherFactory
#      ^^^^^^^^^^^^ definition [..] OtherFactory#
#  ⌄ enclosing_range_start [..] `<Class:OtherFactory>`#new().
   def self.new; end
#           ^^^ definition [..] `<Class:OtherFactory>`#new().
#                  ⌃ enclosing_range_end [..] `<Class:OtherFactory>`#new().
 end
#  ⌃ enclosing_range_end [..] OtherFactory#
