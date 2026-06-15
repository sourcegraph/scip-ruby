 # typed: false
 
 # `require` and `require_relative` calls. They lower to ordinary Send
 # instructions; this fixture documents what the indexer emits for them.
 
 require 'json'
#^^^^^^^ reference [..] Kernel#require().
 require 'set'
#^^^^^^^ reference [..] Kernel#require().
 require_relative 'non_existent_helper'
#^^^^^^^^^^^^^^^^ reference [..] Kernel#require_relative().
 
 def lazy_load
#    ^^^^^^^^^ definition [..] Object#lazy_load().
   require 'csv'
#  ^^^^^^^ reference [..] Kernel#require().
   return
 end
