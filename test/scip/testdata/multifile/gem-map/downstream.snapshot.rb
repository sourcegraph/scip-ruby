 # typed: true
 
 require 'upstream'
#^^^^^^^ reference [..] Kernel#require().
 
 def f()
#    ^ definition my_downstream_gem 1 Object#f().
   g()
#  ^ reference my_upstream_gem 1 Object#g().
 end
