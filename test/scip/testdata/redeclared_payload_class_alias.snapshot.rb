 # typed: true
 # check-errors: true
 
 # The payload already resolves these aliases to classes. Redeclaring the aliases
 # clears their result types after namer has selected the classes to reopen.
 Mutex = Thread::Mutex
#^^^^^ definition [..] Mutex.
#relation reference=[..] Thread#Mutex#
#        ^^^^^^ reference [..] Thread#
#                ^^^^^ reference [..] Thread#Mutex#
 Net::HTTPClientException = Net::HTTPServerException
#     ^^^^^^^^^^^^^^^^^^^ definition [..] Net#HTTPClientException.
#     relation reference=[..] Net#HTTPServerException#
#                           ^^^ reference [..] Net#
#                                ^^^^^^^^^^^^^^^^^^^ reference [..] Net#HTTPServerException#
 
#⌄ enclosing_range_start [..] Thread#Mutex#
 class Mutex
#      ^^^^^ definition [..] Thread#Mutex#
   extend T::Sig
#  ^^^^^^ reference [..] Kernel#extend().
 
   sig {returns(Integer)}
#               ^^^^^^^ reference [..] Integer#
#  ⌄ enclosing_range_start [..] Thread#Mutex#payload_alias_method().
   def payload_alias_method
#      ^^^^^^^^^^^^^^^^^^^^ definition [..] Thread#Mutex#payload_alias_method().
     0
   end
#    ⌃ enclosing_range_end [..] Thread#Mutex#payload_alias_method().
 end
#  ⌃ enclosing_range_end [..] Thread#Mutex#
 
 # An alias can also be a scope within a class name.
#⌄ enclosing_range_start [..] Thread#Mutex#Nested#
 class Mutex::Nested
#      ^^^^^ reference [..] Thread#Mutex#
#             ^^^^^^ definition [..] Thread#Mutex#Nested#
   extend T::Sig
#  ^^^^^^ reference [..] Kernel#extend().
 
   sig {returns(String)}
#               ^^^^^^ reference [..] String#
#  ⌄ enclosing_range_start [..] Thread#Mutex#Nested#nested_alias_method().
   def nested_alias_method
#      ^^^^^^^^^^^^^^^^^^^ definition [..] Thread#Mutex#Nested#nested_alias_method().
     ""
   end
#    ⌃ enclosing_range_end [..] Thread#Mutex#Nested#nested_alias_method().
 end
#  ⌃ enclosing_range_end [..] Thread#Mutex#Nested#
 
#⌄ enclosing_range_start [..] Net#HTTPServerException#
 class Net::HTTPClientException
#      ^^^ reference [..] Net#
#           ^^^^^^^^^^^^^^^^^^^ definition [..] Net#HTTPServerException#
   extend T::Sig
#  ^^^^^^ reference [..] Kernel#extend().
 
   sig {returns(Symbol)}
#               ^^^^^^ reference [..] Symbol#
#  ⌄ enclosing_range_start [..] Net#HTTPServerException#qualified_alias_method().
   def qualified_alias_method
#      ^^^^^^^^^^^^^^^^^^^^^^ definition [..] Net#HTTPServerException#qualified_alias_method().
     :ok
   end
#    ⌃ enclosing_range_end [..] Net#HTTPServerException#qualified_alias_method().
 end
#  ⌃ enclosing_range_end [..] Net#HTTPServerException#
 
 # References must resolve to methods on the original classes.
 Thread::Mutex.new.payload_alias_method
#^^^^^^ reference [..] Thread#
#        ^^^^^ reference [..] Thread#Mutex#
#              ^^^ reference [..] Class#new().
#                  ^^^^^^^^^^^^^^^^^^^^ reference [..] Thread#Mutex#payload_alias_method().
 Mutex.new.payload_alias_method
#^^^^^ reference [..] Mutex.
#      ^^^ reference [..] Class#new().
#          ^^^^^^^^^^^^^^^^^^^^ reference [..] Thread#Mutex#payload_alias_method().
 Thread::Mutex::Nested.new.nested_alias_method
#^^^^^^ reference [..] Thread#
#        ^^^^^ reference [..] Thread#Mutex#
#               ^^^^^^ reference [..] Thread#Mutex#Nested#
#                      ^^^ reference [..] Class#new().
#                          ^^^^^^^^^^^^^^^^^^^ reference [..] Thread#Mutex#Nested#nested_alias_method().
 Net::HTTPServerException.new("", nil).qualified_alias_method
#^^^ reference [..] Net#
#     ^^^^^^^^^^^^^^^^^^^ reference [..] Net#HTTPServerException#
#                         ^^^ reference [..] Class#new().
#                                      ^^^^^^^^^^^^^^^^^^^^^^ reference [..] Net#HTTPServerException#qualified_alias_method().
