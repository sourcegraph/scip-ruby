 # typed: true
 # check-errors: true
 
 # Keep this first definition beyond the end of b.rb to catch offsets being
 # reused in the wrong file. Both definitions share one method symbol, but each
 # definition occurrence and enclosing range must belong to its own source file.
#⌄ enclosing_range_start [..] ReopenedMethod#
 class ReopenedMethod # error: `ReopenedMethod` has behavior defined in multiple files
#      ^^^^^^^^^^^^^^ definition [..] ReopenedMethod#
#  ⌄ enclosing_range_start [..] ReopenedMethod#value().
   def value
#      ^^^^^ definition [..] ReopenedMethod#value().
     1
   end
#    ⌃ enclosing_range_end [..] ReopenedMethod#value().
 end
#  ⌃ enclosing_range_end [..] ReopenedMethod#
