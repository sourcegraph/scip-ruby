 # typed: true
 # check-errors: true
 
#⌄ enclosing_range_start [..] T#
 module T
#       ^ definition [..] T#
#  ⌄ enclosing_range_start [..] T#Helpers#
   module Helpers
#         ^^^^^^^ definition [..] T#Helpers#
#    ⌄ enclosing_range_start [..] T#`<Class:Helpers>`#runtime_module().
     def self.runtime_module
#             ^^^^^^^^^^^^^^ definition [..] T#`<Class:Helpers>`#runtime_module().
       Module
#      ^^^^^^ reference [..] T#Module#
     end
#      ⌃ enclosing_range_end [..] T#`<Class:Helpers>`#runtime_module().
 
#    ⌄ enclosing_range_start [..] T#`<Class:Helpers>`#root_module().
     def self.root_module
#             ^^^^^^^^^^^ definition [..] T#`<Class:Helpers>`#root_module().
       ::Module.new
#        ^^^^^^ reference [..] Module#
#               ^^^ reference [..] Module#initialize().
     end
#      ⌃ enclosing_range_end [..] T#`<Class:Helpers>`#root_module().
   end
#    ⌃ enclosing_range_end [..] T#Helpers#
 end
#  ⌃ enclosing_range_end [..] T#
