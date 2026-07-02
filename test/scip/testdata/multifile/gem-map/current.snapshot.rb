 # typed: true
 
 require 'upstream'
#^^^^^^^ reference [..] Kernel#require().
 require 'downstream'
#^^^^^^^ reference [..] Kernel#require().
 
 # File missing from gem map; check fallback behavior
 
#⌄ enclosing_range_start my_current_gem 2 Object#h().
 def h()
#    ^ definition my_current_gem 2 Object#h().
   f()
#  ^ reference my_downstream_gem 1 Object#f().
   g()
#  ^ reference my_upstream_gem 1 Object#g().
 end
#  ⌃ enclosing_range_end my_current_gem 2 Object#h().
