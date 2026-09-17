 # typed: true
 # check-errors: true
 
 # The unsigned RBI must not hide the old payload's constructor return type.
 Gem::Version.new('2.0') >= Gem::Version.new('1.0')
#^^^ reference [..] Gem#
#     ^^^^^^^ reference [..] Gem#Version#
#             ^^^ reference [..] Gem#`<Class:Version>`#new().
#                        ^^ reference [..] Comparable#`>=`().
#                           ^^^ reference [..] Gem#
#                                ^^^^^^^ reference [..] Gem#Version#
#                                        ^^^ reference [..] Gem#`<Class:Version>`#new().
 
 # An arbitrary unsigned factory is not a constructor contract.
 OtherFactory.new.upcase
#^^^^^^^^^^^^ reference [..] OtherFactory#
#             ^^^ reference [..] `<Class:OtherFactory>`#new().
