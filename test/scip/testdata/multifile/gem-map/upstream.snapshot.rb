 # typed: true
 
 def g()
#    ^ definition my_upstream_gem 1 Object#g().
   puts 'Hello'
#  ^^^^ reference [..] Kernel#puts().
 end
