 # typed: true
 # check-errors: true
 
#⌄ enclosing_range_start [..] Good#
 class Good
#      ^^^^ definition [..] Good#
#  ⌄ enclosing_range_start [..] Good#usable().
   def usable; 'ok'; end
#      ^^^^^^ definition [..] Good#usable().
#                      ⌃ enclosing_range_end [..] Good#usable().
 end
#  ⌃ enclosing_range_end [..] Good#
 Good.new.usable
#^^^^ reference [..] Good#
#     ^^^ reference [..] Class#new().
#         ^^^^^^ reference [..] Good#usable().
