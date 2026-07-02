 # typed: true
 
 require 'upstream'
#^^^^^^^ reference [..] Kernel#require().
 
#⌄ enclosing_range_start my_downstream_gem 1 Object#f().
 def f()
#    ^ definition my_downstream_gem 1 Object#f().
   g()
#  ^ reference my_upstream_gem 1 Object#g().
 end
#  ⌃ enclosing_range_end my_downstream_gem 1 Object#f().
