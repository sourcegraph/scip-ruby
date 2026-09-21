 # typed: true
 # enable-experimental-rbs-comments: true
 # options: showDocs
 
#⌄ enclosing_range_start [..] RBSKeywordReceiver#
 class RBSKeywordReceiver
#      ^^^^^^^^^^^^^^^^^^ definition [..] RBSKeywordReceiver#
#      documentation
#      | ```ruby
#      | class RBSKeywordReceiver
#      | ```
   #: (customer: String, ?enabled: bool) -> String
#                ^^^^^^ reference [..] String#
#                                  ^^^^ reference [..] T#Boolean.
#                                           ^^^^^^ reference [..] String#
#  ⌄ enclosing_range_start [..] RBSKeywordReceiver#deliver().
   def deliver(customer:, enabled: true)
#      ^^^^^^^ definition [..] RBSKeywordReceiver#deliver().
#      documentation
#      | ```ruby
#      | sig { params(customer: String, enabled: T::Boolean).returns(String) }
#      | def deliver(customer:, enabled: …)
#      | ```
#      documentation
#      | : (customer: String, ?enabled: bool) -> String
#              ^^^^^^^^ definition [..] RBSKeywordReceiver#deliver().(customer)
#              documentation
#              | ```ruby
#              | customer (String)
#              | ```
#                         ^^^^^^^ definition [..] RBSKeywordReceiver#deliver().(enabled)
#                         documentation
#                         | ```ruby
#                         | enabled (T::Boolean)
#                         | ```
     customer.upcase
#    ^^^^^^^^ reference [..] RBSKeywordReceiver#deliver().(customer)
#             ^^^^^^ reference [..] String#upcase().
   end
#    ⌃ enclosing_range_end [..] RBSKeywordReceiver#deliver().
 
   #: (customer: String) -> void
#                ^^^^^^ reference [..] String#
#  ⌄ enclosing_range_start [..] RBSKeywordReceiver#unused().
   def unused(customer:)
#      ^^^^^^ definition [..] RBSKeywordReceiver#unused().
#      documentation
#      | ```ruby
#      | sig { params(customer: String).void }
#      | def unused(customer:)
#      | ```
#      documentation
#      | : (customer: String) -> void
#             ^^^^^^^^ definition [..] RBSKeywordReceiver#unused().(customer)
#             documentation
#             | ```ruby
#             | customer (String)
#             | ```
   end
#    ⌃ enclosing_range_end [..] RBSKeywordReceiver#unused().
 
   #: (customer: String) -> void
#                ^^^^^^ reference [..] String#
#  ⌄ enclosing_range_start [..] `<Class:RBSKeywordReceiver>`#deliver().
   def self.deliver(customer:)
#           ^^^^^^^ definition [..] `<Class:RBSKeywordReceiver>`#deliver().
#           documentation
#           | ```ruby
#           | sig { params(customer: String).void }
#           | def self.deliver(customer:)
#           | ```
#           documentation
#           | : (customer: String) -> void
#                   ^^^^^^^^ definition [..] `<Class:RBSKeywordReceiver>`#deliver().(customer)
#                   documentation
#                   | ```ruby
#                   | customer (String)
#                   | ```
   end
#    ⌃ enclosing_range_end [..] `<Class:RBSKeywordReceiver>`#deliver().
 end
#  ⌃ enclosing_range_end [..] RBSKeywordReceiver#
 
 customer = "Ada"
#^^^^^^^^ definition local 1$217974539
#documentation
#| ```ruby
#| customer (String("Ada"))
#| ```
 RBSKeywordReceiver.new.deliver(customer:, enabled: true)
#^^^^^^^^^^^^^^^^^^ reference [..] RBSKeywordReceiver#
#                   ^^^ reference [..] Class#new().
#                       ^^^^^^^ reference [..] RBSKeywordReceiver#deliver().
#                               ^^^^^^^^ reference local 1$217974539
#                               ^^^^^^^^ reference [..] RBSKeywordReceiver#deliver().(customer)
#                                          ^^^^^^^ reference [..] RBSKeywordReceiver#deliver().(enabled)
 RBSKeywordReceiver.new.unused(customer: customer)
#^^^^^^^^^^^^^^^^^^ reference [..] RBSKeywordReceiver#
#                   ^^^ reference [..] Class#new().
#                       ^^^^^^ reference [..] RBSKeywordReceiver#unused().
#                              ^^^^^^^^ reference [..] RBSKeywordReceiver#unused().(customer)
#                                        ^^^^^^^^ reference local 1$217974539
 RBSKeywordReceiver.deliver(customer:)
#^^^^^^^^^^^^^^^^^^ reference [..] RBSKeywordReceiver#
#                   ^^^^^^^ reference [..] `<Class:RBSKeywordReceiver>`#deliver().
#                           ^^^^^^^^ reference local 1$217974539
#                           ^^^^^^^^ reference [..] `<Class:RBSKeywordReceiver>`#deliver().(customer)
