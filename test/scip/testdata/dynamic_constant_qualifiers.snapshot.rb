 # typed: true
 
#⌄ enclosing_range_start [..] Helpers#
 module Helpers
#       ^^^^^^^ definition [..] Helpers#
   Dynamic = build_helpers
#  ^^^^^^^ definition [..] Helpers#Dynamic.
#  ^^^^^^^^^^^^^^^^^^^^^^^ reference [..] Helpers#Dynamic.
 
#  ⌄ enclosing_range_start [..] Helpers#Client#
   class Client
#        ^^^^^^ definition [..] Helpers#Client#
     include Dynamic
#    ^^^^^^^ reference [..] Module#include().
#            ^^^^^^^ reference [..] Helpers#Dynamic.
   end
#    ⌃ enclosing_range_end [..] Helpers#Client#
 
#  ⌄ enclosing_range_start [..] Helpers#Static#
   module Static
#         ^^^^^^ definition [..] Helpers#Static#
   end
#    ⌃ enclosing_range_end [..] Helpers#Static#
 
#  ⌄ enclosing_range_start [..] Helpers#OtherClient#
   class OtherClient
#        ^^^^^^^^^^^ definition [..] Helpers#OtherClient#
     include Helpers::Static
#    ^^^^^^^ reference [..] Module#include().
#            ^^^^^^^ reference [..] Helpers#
#                     ^^^^^^ reference [..] Helpers#Static#
#                     ^^^^^^ reference [..] Helpers#Static#
   end
#    ⌃ enclosing_range_end [..] Helpers#OtherClient#
 end
#  ⌃ enclosing_range_end [..] Helpers#
