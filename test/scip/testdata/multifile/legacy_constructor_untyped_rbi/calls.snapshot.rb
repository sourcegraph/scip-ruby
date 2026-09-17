 # typed: true
 # check-errors: true
 
 # An explicit untyped contract must remain untyped.
 Gem::Version.new('2.0') >= Gem::Version.new('1.0')
#^^^ reference [..] Gem#
#     ^^^^^^^ reference [..] Gem#Version#
#             ^^^ reference [..] Gem#`<Class:Version>`#new().
#                           ^^^ reference [..] Gem#
#                                ^^^^^^^ reference [..] Gem#Version#
#                                        ^^^ reference [..] Gem#`<Class:Version>`#new().
