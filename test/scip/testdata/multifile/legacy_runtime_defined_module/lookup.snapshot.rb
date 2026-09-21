 # typed: true
 # check-errors: true
 
#⌄ enclosing_range_start [..] T#
 module T
#       ^ definition [..] T#
#  ⌄ enclosing_range_start [..] T#Module#
   module Module
#         ^^^^^^ definition [..] T#Module#
#    ⌄ enclosing_range_start [..] T#`<Class:Module>`#marker().
     def self.marker; end
#             ^^^^^^ definition [..] T#`<Class:Module>`#marker().
#                       ⌃ enclosing_range_end [..] T#`<Class:Module>`#marker().
   end
#    ⌃ enclosing_range_end [..] T#Module#
 
#  ⌄ enclosing_range_start [..] T#Helpers#
   module Helpers
#         ^^^^^^^ definition [..] T#Helpers#
#    ⌄ enclosing_range_start [..] T#`<Class:Helpers>`#project_module().
     def self.project_module
#             ^^^^^^^^^^^^^^ definition [..] T#`<Class:Helpers>`#project_module().
       Module.marker
#      ^^^^^^ reference [..] T#Module#
#             ^^^^^^ reference [..] T#`<Class:Module>`#marker().
     end
#      ⌃ enclosing_range_end [..] T#`<Class:Helpers>`#project_module().
   end
#    ⌃ enclosing_range_end [..] T#Helpers#
 end
#  ⌃ enclosing_range_end [..] T#
