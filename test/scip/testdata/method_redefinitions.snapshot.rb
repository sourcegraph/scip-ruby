 # typed: true
 # check-errors: true
 
 # This method already has a definition in the payload. Its symbol's location
 # belongs to the RBI, not to this source file.
#⌄ enclosing_range_start [..] Exception#
 class Exception
#      ^^^^^^^^^ definition [..] Exception#
#  ⌄ enclosing_range_start [..] Exception#message().
   def message
#      ^^^^^^^ definition [..] Exception#message().
     "custom message"
   end
#    ⌃ enclosing_range_end [..] Exception#message().
 end
#  ⌃ enclosing_range_end [..] Exception#
 
 # Repeated definitions in one file must each use their own name range.
#⌄ enclosing_range_start [..] RedefinedMethod#
 class RedefinedMethod
#      ^^^^^^^^^^^^^^^ definition [..] RedefinedMethod#
#  ⌄ enclosing_range_start [..] RedefinedMethod#value().
   def value
#      ^^^^^ definition [..] RedefinedMethod#value().
     1
   end
#    ⌃ enclosing_range_end [..] RedefinedMethod#value().
 
#  ⌄ enclosing_range_start [..] RedefinedMethod#value().
   def value
#      ^^^^^ definition [..] RedefinedMethod#value().
     2
   end
#    ⌃ enclosing_range_end [..] RedefinedMethod#value().
 end
#  ⌃ enclosing_range_end [..] RedefinedMethod#
 
 Exception.new.message
#^^^^^^^^^ reference [..] Exception#
#          ^^^ reference [..] Class#new().
#              ^^^^^^^ reference [..] Exception#message().
 RedefinedMethod.new.value
#^^^^^^^^^^^^^^^ reference [..] RedefinedMethod#
#                ^^^ reference [..] Class#new().
#                    ^^^^^ reference [..] RedefinedMethod#value().
