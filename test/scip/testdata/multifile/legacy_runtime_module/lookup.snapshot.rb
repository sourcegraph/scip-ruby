 # typed: true
 # check-errors: true
 
#⌄ enclosing_range_start [..] T#
 module T
#       ^ definition [..] T#
#  ⌄ enclosing_range_start [..] T#Helpers#
   module Helpers
#         ^^^^^^^ definition [..] T#Helpers#
     # Old Tapioca expects the root Module in both locations.
     prepend(Module.new do
#    ^^^^^^^ reference [..] Module#prepend().
#            ^^^^^^ reference [..] Module#
#                   ^^^ reference [..] Module#initialize().
#      ⌄ enclosing_range_start [..] T#Helpers#legacy_runtime_helper().
       def legacy_runtime_helper; end
#          ^^^^^^^^^^^^^^^^^^^^^ definition [..] T#Helpers#legacy_runtime_helper().
#                                   ⌃ enclosing_range_end [..] T#Helpers#legacy_runtime_helper().
     end)
     NAME_METHOD = T.let(Module.instance_method(:name), UnboundMethod)
#    ^^^^^^^^^^^ definition [..] T#Helpers#NAME_METHOD.
#                        ^^^^^^ reference [..] Module#
#                               ^^^^^^^^^^^^^^^ reference [..] Module#instance_method().
#                                                       ^^^^^^^^^^^^^ reference [..] UnboundMethod#
 
#    ⌄ enclosing_range_start [..] T#`<Class:Helpers>`#explicit_runtime_module().
     def self.explicit_runtime_module
#             ^^^^^^^^^^^^^^^^^^^^^^^ definition [..] T#`<Class:Helpers>`#explicit_runtime_module().
       # Explicit qualification keeps the requested namespace.
       T::Module
#      ^ reference [..] T#
#         ^^^^^^ reference [..] T#Module#
     end
#      ⌃ enclosing_range_end [..] T#`<Class:Helpers>`#explicit_runtime_module().
 
#    ⌄ enclosing_range_start [..] T#`<Class:Helpers>`#root_module().
     def self.root_module
#             ^^^^^^^^^^^ definition [..] T#`<Class:Helpers>`#root_module().
       ::Module
#        ^^^^^^ reference [..] Module#
     end
#      ⌃ enclosing_range_end [..] T#`<Class:Helpers>`#root_module().
   end
#    ⌃ enclosing_range_end [..] T#Helpers#
 end
#  ⌃ enclosing_range_end [..] T#
