 # typed: true
 
#⌄ enclosing_range_start my_upstream_gem 1 Object#g().
 def g()
#    ^ definition my_upstream_gem 1 Object#g().
   puts 'Hello'
#  ^^^^ reference [..] Kernel#puts().
 end
#  ⌃ enclosing_range_end my_upstream_gem 1 Object#g().
