 # typed: true
 # check-errors: true
 # options: showDocs
 
#⌄ enclosing_range_start [..] KeywordReceiver#
 class KeywordReceiver
#      ^^^^^^^^^^^^^^^ definition [..] KeywordReceiver#
#      documentation
#      | ```ruby
#      | class KeywordReceiver
#      | ```
   extend T::Sig
#  ^^^^^^ reference [..] Kernel#extend().
 
   sig { params(customer: String, enabled: T::Boolean).returns(String) }
#                         ^^^^^^ reference [..] String#
#                                             ^^^^^^^ reference [..] T#Boolean.
#                                                              ^^^^^^ reference [..] String#
#  ⌄ enclosing_range_start [..] KeywordReceiver#deliver().
   def deliver(customer:, enabled: true)
#      ^^^^^^^ definition [..] KeywordReceiver#deliver().
#      documentation
#      | ```ruby
#      | sig { params(customer: String, enabled: T::Boolean).returns(String) }
#      | def deliver(customer:, enabled: …)
#      | ```
#              ^^^^^^^^ definition [..] KeywordReceiver#deliver().(customer)
#              documentation
#              | ```ruby
#              | customer (String)
#              | ```
#                         ^^^^^^^ definition [..] KeywordReceiver#deliver().(enabled)
#                         documentation
#                         | ```ruby
#                         | enabled (T::Boolean)
#                         | ```
     customer = customer.upcase if enabled
#    ^^^^^^^^ reference (write) [..] KeywordReceiver#deliver().(customer)
#               ^^^^^^^^ reference [..] KeywordReceiver#deliver().(customer)
#                        ^^^^^^ reference [..] String#upcase().
     [1].each { customer.downcase }
#        ^^^^ reference [..] Array#each().
#               ^^^^^^^^ reference [..] KeywordReceiver#deliver().(customer)
#                        ^^^^^^^^ reference [..] String#downcase().
     ["shadow"].each { |customer| customer.upcase }
#               ^^^^ reference [..] Array#each().
#                       ^^^^^^^^ definition local 1$720076859
#                       documentation
#                       | ```ruby
#                       | customer (String)
#                       | ```
#                                 ^^^^^^^^ reference local 1$720076859
#                                          ^^^^^^ reference [..] String#upcase().
     customer
#    ^^^^^^^^ reference [..] KeywordReceiver#deliver().(customer)
   end
#    ⌃ enclosing_range_end [..] KeywordReceiver#deliver().
 
   sig { params(customer: String).void }
#                         ^^^^^^ reference [..] String#
#  ⌄ enclosing_range_start [..] KeywordReceiver#unused().
   def unused(customer:)
#      ^^^^^^ definition [..] KeywordReceiver#unused().
#      documentation
#      | ```ruby
#      | sig { params(customer: String).void }
#      | def unused(customer:)
#      | ```
#             ^^^^^^^^ definition [..] KeywordReceiver#unused().(customer)
#             documentation
#             | ```ruby
#             | customer (String)
#             | ```
   end
#    ⌃ enclosing_range_end [..] KeywordReceiver#unused().
 
   sig { params(customer: String).returns(String) }
#                         ^^^^^^ reference [..] String#
#                                         ^^^^^^ reference [..] String#
#  ⌄ enclosing_range_start [..] `<Class:KeywordReceiver>`#deliver().
   def self.deliver(customer:)
#           ^^^^^^^ definition [..] `<Class:KeywordReceiver>`#deliver().
#           documentation
#           | ```ruby
#           | sig { params(customer: String).returns(String) }
#           | def self.deliver(customer:)
#           | ```
#                   ^^^^^^^^ definition [..] `<Class:KeywordReceiver>`#deliver().(customer)
#                   documentation
#                   | ```ruby
#                   | customer (String)
#                   | ```
     customer
#    ^^^^^^^^ reference [..] `<Class:KeywordReceiver>`#deliver().(customer)
   end
#    ⌃ enclosing_range_end [..] `<Class:KeywordReceiver>`#deliver().
 
   alias copied deliver
 
   sig { params(values: Integer, customer: String, block: T.nilable(T.proc.void)).returns(String) }
#                       ^^^^^^^ reference [..] Integer#
#                                          ^^^^^^ reference [..] String#
#                                                                                         ^^^^^^ reference [..] String#
#  ⌄ enclosing_range_start [..] KeywordReceiver#wrapped().
   def wrapped(*values, customer:, &block)
#      ^^^^^^^ definition [..] KeywordReceiver#wrapped().
#      documentation
#      | ```ruby
#      | sig do
#      |   params(
#      |     values: Integer,
#      |     customer: String,
#      |     block: T.nilable(T.proc.void)
#      |   )
#      |   .returns(String)
#      | end
#      | def wrapped(*values, customer:, &block)
#      | ```
#                       ^^^^^^^^ definition [..] KeywordReceiver#wrapped().(customer)
#                       documentation
#                       | ```ruby
#                       | customer (String)
#                       | ```
#                                   ^^^^^ definition local 1$2727688631
#                                   documentation
#                                   | ```ruby
#                                   | block (T.nilable(T.proc.void))
#                                   | ```
     block.call if block
#    ^^^^^ reference local 1$2727688631
#    override_documentation
#    | ```ruby
#    | block (T.proc.void)
#    | ```
#          ^^^^ reference [..] Proc0#call().
     customer
#    ^^^^^^^^ reference [..] KeywordReceiver#wrapped().(customer)
   end
#    ⌃ enclosing_range_end [..] KeywordReceiver#wrapped().
 
   sig { params(extras: String).void }
#                       ^^^^^^ reference [..] String#
#  ⌄ enclosing_range_start [..] KeywordReceiver#extras().
   def extras(**extras)
#      ^^^^^^ definition [..] KeywordReceiver#extras().
#      documentation
#      | ```ruby
#      | sig { params(extras: String).void }
#      | def extras(**extras)
#      | ```
   end
#    ⌃ enclosing_range_end [..] KeywordReceiver#extras().
 
   sig { params(options: T::Hash[Symbol, String]).void }
#                                ^^^^^^ reference [..] Symbol#
#                                        ^^^^^^ reference [..] String#
#  ⌄ enclosing_range_start [..] KeywordReceiver#positional().
   def positional(options)
#      ^^^^^^^^^^ definition [..] KeywordReceiver#positional().
#      documentation
#      | ```ruby
#      | sig { params(options: T::Hash[Symbol, String]).void }
#      | def positional(options)
#      | ```
   end
#    ⌃ enclosing_range_end [..] KeywordReceiver#positional().
 end
#  ⌃ enclosing_range_end [..] KeywordReceiver#
 
#⌄ enclosing_range_start [..] KeywordChild#
 class KeywordChild < KeywordReceiver
#      ^^^^^^^^^^^^ definition [..] KeywordChild#
#      documentation
#      | ```ruby
#      | class KeywordChild < KeywordReceiver
#      | ```
#                     ^^^^^^^^^^^^^^^ reference [..] KeywordReceiver#
 end
#  ⌃ enclosing_range_end [..] KeywordChild#
 
#⌄ enclosing_range_start [..] KeywordSibling#
 class KeywordSibling < KeywordReceiver
#      ^^^^^^^^^^^^^^ definition [..] KeywordSibling#
#      documentation
#      | ```ruby
#      | class KeywordSibling < KeywordReceiver
#      | ```
#                       ^^^^^^^^^^^^^^^ reference [..] KeywordReceiver#
 end
#  ⌃ enclosing_range_end [..] KeywordSibling#
 
#⌄ enclosing_range_start [..] OtherKeywordReceiver#
 class OtherKeywordReceiver
#      ^^^^^^^^^^^^^^^^^^^^ definition [..] OtherKeywordReceiver#
#      documentation
#      | ```ruby
#      | class OtherKeywordReceiver
#      | ```
   extend T::Sig
#  ^^^^^^ reference [..] Kernel#extend().
   sig { params(customer: String, enabled: T::Boolean).returns(String) }
#                         ^^^^^^ reference [..] String#
#                                             ^^^^^^^ reference [..] T#Boolean.
#                                                              ^^^^^^ reference [..] String#
#  ⌄ enclosing_range_start [..] OtherKeywordReceiver#deliver().
   def deliver(customer:, enabled: false)
#      ^^^^^^^ definition [..] OtherKeywordReceiver#deliver().
#      documentation
#      | ```ruby
#      | sig { params(customer: String, enabled: T::Boolean).returns(String) }
#      | def deliver(customer:, enabled: …)
#      | ```
#              ^^^^^^^^ definition [..] OtherKeywordReceiver#deliver().(customer)
#              documentation
#              | ```ruby
#              | customer (String)
#              | ```
#                         ^^^^^^^ definition [..] OtherKeywordReceiver#deliver().(enabled)
#                         documentation
#                         | ```ruby
#                         | enabled (T::Boolean)
#                         | ```
     customer
#    ^^^^^^^^ reference [..] OtherKeywordReceiver#deliver().(customer)
   end
#    ⌃ enclosing_range_end [..] OtherKeywordReceiver#deliver().
 end
#  ⌃ enclosing_range_end [..] OtherKeywordReceiver#
 
#⌄ enclosing_range_start [..] KeywordOverride#
 class KeywordOverride < KeywordReceiver
#      ^^^^^^^^^^^^^^^ definition [..] KeywordOverride#
#      documentation
#      | ```ruby
#      | class KeywordOverride < KeywordReceiver
#      | ```
#                        ^^^^^^^^^^^^^^^ reference [..] KeywordReceiver#
   extend T::Sig
#  ^^^^^^ reference [..] Kernel#extend().
   sig { override.params(customer: String, enabled: T::Boolean).returns(String) }
#                                  ^^^^^^ reference [..] String#
#                                                      ^^^^^^^ reference [..] T#Boolean.
#                                                                       ^^^^^^ reference [..] String#
#  ⌄ enclosing_range_start [..] KeywordOverride#deliver().
   def deliver(customer:, enabled: true)
#      ^^^^^^^ definition [..] KeywordOverride#deliver().
#      documentation
#      | ```ruby
#      | sig { override.params(customer: String, enabled: T::Boolean).returns(String) }
#      | def deliver(customer:, enabled: …)
#      | ```
#              ^^^^^^^^ definition [..] KeywordOverride#deliver().(customer)
#              documentation
#              | ```ruby
#              | customer (String)
#              | ```
#                         ^^^^^^^ definition [..] KeywordOverride#deliver().(enabled)
#                         documentation
#                         | ```ruby
#                         | enabled (T::Boolean)
#                         | ```
     super(customer:, enabled:)
#          ^^^^^^^^ reference [..] KeywordOverride#deliver().(customer)
#          ^^^^^^^^ reference [..] KeywordReceiver#deliver().(customer)
#                     ^^^^^^^ reference [..] KeywordOverride#deliver().(enabled)
#                     ^^^^^^^ reference [..] KeywordReceiver#deliver().(enabled)
   end
#    ⌃ enclosing_range_end [..] KeywordOverride#deliver().
 end
#  ⌃ enclosing_range_end [..] KeywordOverride#
 
#⌄ enclosing_range_start [..] KeywordConstructor#
 class KeywordConstructor
#      ^^^^^^^^^^^^^^^^^^ definition [..] KeywordConstructor#
#      documentation
#      | ```ruby
#      | class KeywordConstructor
#      | ```
   extend T::Sig
#  ^^^^^^ reference [..] Kernel#extend().
   sig { params(customer: String).void }
#                         ^^^^^^ reference [..] String#
#  ⌄ enclosing_range_start [..] KeywordConstructor#initialize().
   def initialize(customer:)
#      ^^^^^^^^^^ definition [..] KeywordConstructor#initialize().
#      documentation
#      | ```ruby
#      | sig { params(customer: String).void }
#      | def initialize(customer:)
#      | ```
#                 ^^^^^^^^ definition [..] KeywordConstructor#initialize().(customer)
#                 documentation
#                 | ```ruby
#                 | customer (String)
#                 | ```
     @customer = customer
#    ^^^^^^^^^ definition [..] KeywordConstructor#`@customer`.
#    ^^^^^^^^^^^^^^^^^^^^ reference [..] KeywordConstructor#`@customer`.
#                ^^^^^^^^ reference [..] KeywordConstructor#initialize().(customer)
   end
#    ⌃ enclosing_range_end [..] KeywordConstructor#initialize().
 end
#  ⌃ enclosing_range_end [..] KeywordConstructor#
 
#⌄ enclosing_range_start [..] KeywordCaller#
 class KeywordCaller
#      ^^^^^^^^^^^^^ definition [..] KeywordCaller#
#      documentation
#      | ```ruby
#      | class KeywordCaller
#      | ```
   extend T::Sig
#  ^^^^^^ reference [..] Kernel#extend().
 
   sig { params(receiver: T.any(KeywordReceiver, OtherKeywordReceiver), customer: String).void }
#                               ^^^^^^^^^^^^^^^ reference [..] KeywordReceiver#
#                                                ^^^^^^^^^^^^^^^^^^^^ reference [..] OtherKeywordReceiver#
#                                                                                 ^^^^^^ reference [..] String#
#  ⌄ enclosing_range_start [..] KeywordCaller#union().
   def union(receiver, customer:)
#      ^^^^^ definition [..] KeywordCaller#union().
#      documentation
#      | ```ruby
#      | sig do
#      |   params(
#      |     receiver: T.any(KeywordReceiver, OtherKeywordReceiver),
#      |     customer: String
#      |   )
#      |   .void
#      | end
#      | def union(receiver, customer:)
#      | ```
#            ^^^^^^^^ definition local 1$956405319
#            documentation
#            | ```ruby
#            | receiver (T.any(KeywordReceiver, OtherKeywordReceiver))
#            | ```
#                      ^^^^^^^^ definition [..] KeywordCaller#union().(customer)
#                      documentation
#                      | ```ruby
#                      | customer (String)
#                      | ```
     receiver.deliver(customer:)
#    ^^^^^^^^ reference local 1$956405319
#             ^^^^^^^ reference [..] KeywordReceiver#deliver().
#             ^^^^^^^ reference [..] OtherKeywordReceiver#deliver().
#                     ^^^^^^^^ reference [..] KeywordCaller#union().(customer)
#                     ^^^^^^^^ reference [..] KeywordReceiver#deliver().(customer)
#                     ^^^^^^^^ reference [..] OtherKeywordReceiver#deliver().(customer)
   end
#    ⌃ enclosing_range_end [..] KeywordCaller#union().
 
   sig { params(receiver: T.any(KeywordChild, KeywordSibling), customer: String).void }
#                               ^^^^^^^^^^^^ reference [..] KeywordChild#
#                                             ^^^^^^^^^^^^^^ reference [..] KeywordSibling#
#                                                                        ^^^^^^ reference [..] String#
#  ⌄ enclosing_range_start [..] KeywordCaller#inherited_union().
   def inherited_union(receiver, customer:)
#      ^^^^^^^^^^^^^^^ definition [..] KeywordCaller#inherited_union().
#      documentation
#      | ```ruby
#      | sig do
#      |   params(
#      |     receiver: T.any(KeywordChild, KeywordSibling),
#      |     customer: String
#      |   )
#      |   .void
#      | end
#      | def inherited_union(receiver, customer:)
#      | ```
#                      ^^^^^^^^ definition local 1$3194558502
#                      documentation
#                      | ```ruby
#                      | receiver (T.any(KeywordChild, KeywordSibling))
#                      | ```
#                                ^^^^^^^^ definition [..] KeywordCaller#inherited_union().(customer)
#                                documentation
#                                | ```ruby
#                                | customer (String)
#                                | ```
     receiver.deliver(customer:)
#    ^^^^^^^^ reference local 1$3194558502
#             ^^^^^^^ reference [..] KeywordReceiver#deliver().
#                     ^^^^^^^^ reference [..] KeywordCaller#inherited_union().(customer)
#                     ^^^^^^^^ reference [..] KeywordReceiver#deliver().(customer)
   end
#    ⌃ enclosing_range_end [..] KeywordCaller#inherited_union().
 
   sig { params(customer: String).returns(String) }
#                         ^^^^^^ reference [..] String#
#                                         ^^^^^^ reference [..] String#
#  ⌄ enclosing_range_start [..] KeywordCaller#defaults().
   def defaults(customer: KeywordReceiver.new.wrapped(*[1], customer: "default"))
#      ^^^^^^^^ definition [..] KeywordCaller#defaults().
#      documentation
#      | ```ruby
#      | sig { params(customer: String).returns(String) }
#      | def defaults(customer: …)
#      | ```
#               ^^^^^^^^ definition [..] KeywordCaller#defaults().(customer)
#               documentation
#               | ```ruby
#               | customer (String)
#               | ```
#                         ^^^^^^^^^^^^^^^ reference [..] KeywordReceiver#
#                                         ^^^ reference [..] Class#new().
#                                             ^^^^^^^ reference [..] KeywordReceiver#wrapped().
#                                                           ^^^^^^^^ reference [..] KeywordReceiver#wrapped().(customer)
     customer
#    ^^^^^^^^ reference [..] KeywordCaller#defaults().(customer)
   end
#    ⌃ enclosing_range_end [..] KeywordCaller#defaults().
 
   sig { params(receiver: T.untyped, customer: String).void }
#                                              ^^^^^^ reference [..] String#
#  ⌄ enclosing_range_start [..] KeywordCaller#dynamic().
   def dynamic(receiver, customer:)
#      ^^^^^^^ definition [..] KeywordCaller#dynamic().
#      documentation
#      | ```ruby
#      | sig { params(receiver: T.untyped, customer: String).void }
#      | def dynamic(receiver, customer:)
#      | ```
#              ^^^^^^^^ definition local 1$2222812673
#              documentation
#              | ```ruby
#              | receiver (T.untyped)
#              | ```
#                        ^^^^^^^^ definition [..] KeywordCaller#dynamic().(customer)
#                        documentation
#                        | ```ruby
#                        | customer (String)
#                        | ```
     receiver.deliver(customer:)
#    ^^^^^^^^ reference local 1$2222812673
#                     ^^^^^^^^ reference [..] KeywordCaller#dynamic().(customer)
   end
#    ⌃ enclosing_range_end [..] KeywordCaller#dynamic().
 end
#  ⌃ enclosing_range_end [..] KeywordCaller#
 
 receiver = KeywordReceiver.new
#^^^^^^^^ definition local 1$217974539
#documentation
#| ```ruby
#| receiver (KeywordReceiver)
#| ```
#           ^^^^^^^^^^^^^^^ reference [..] KeywordReceiver#
#                           ^^^ reference [..] Class#new().
 customer = "Ada"
#^^^^^^^^ definition local 3$217974539
#documentation
#| ```ruby
#| customer (String("Ada"))
#| ```
 receiver.deliver(customer: customer, enabled: true)
#^^^^^^^^ reference local 1$217974539
#         ^^^^^^^ reference [..] KeywordReceiver#deliver().
#                 ^^^^^^^^ reference [..] KeywordReceiver#deliver().(customer)
#                           ^^^^^^^^ reference local 3$217974539
#                                     ^^^^^^^ reference [..] KeywordReceiver#deliver().(enabled)
 receiver.deliver(customer:)
#^^^^^^^^ reference local 1$217974539
#         ^^^^^^^ reference [..] KeywordReceiver#deliver().
#                 ^^^^^^^^ reference local 3$217974539
#                 ^^^^^^^^ reference [..] KeywordReceiver#deliver().(customer)
 receiver.deliver(:customer => customer)
#^^^^^^^^ reference local 1$217974539
#         ^^^^^^^ reference [..] KeywordReceiver#deliver().
#                  ^^^^^^^^ reference [..] KeywordReceiver#deliver().(customer)
#                              ^^^^^^^^ reference local 3$217974539
 receiver.deliver("customer": customer)
#^^^^^^^^ reference local 1$217974539
#         ^^^^^^^ reference [..] KeywordReceiver#deliver().
#                  ^^^^^^^^ reference [..] KeywordReceiver#deliver().(customer)
#                             ^^^^^^^^ reference local 3$217974539
 receiver.copied(customer:)
#^^^^^^^^ reference local 1$217974539
#         ^^^^^^ reference [..] KeywordReceiver#deliver().
#                ^^^^^^^^ reference local 3$217974539
#                ^^^^^^^^ reference [..] KeywordReceiver#deliver().(customer)
 KeywordChild.new.deliver(customer:)
#^^^^^^^^^^^^ reference [..] KeywordChild#
#             ^^^ reference [..] Class#new().
#                 ^^^^^^^ reference [..] KeywordReceiver#deliver().
#                         ^^^^^^^^ reference local 3$217974539
#                         ^^^^^^^^ reference [..] KeywordReceiver#deliver().(customer)
 KeywordReceiver.deliver(customer:)
#^^^^^^^^^^^^^^^ reference [..] KeywordReceiver#
#                ^^^^^^^ reference [..] `<Class:KeywordReceiver>`#deliver().
#                        ^^^^^^^^ reference local 3$217974539
#                        ^^^^^^^^ reference [..] `<Class:KeywordReceiver>`#deliver().(customer)
 receiver.unused(customer:)
#^^^^^^^^ reference local 1$217974539
#         ^^^^^^ reference [..] KeywordReceiver#unused().
#                ^^^^^^^^ reference local 3$217974539
#                ^^^^^^^^ reference [..] KeywordReceiver#unused().(customer)
 KeywordConstructor.new(customer:)
#^^^^^^^^^^^^^^^^^^ reference [..] KeywordConstructor#
#                   ^^^ reference [..] KeywordConstructor#initialize().
#                       ^^^^^^^^ reference local 3$217974539
#                       ^^^^^^^^ reference [..] KeywordConstructor#initialize().(customer)
 KeywordOverride.new.deliver(customer:)
#^^^^^^^^^^^^^^^ reference [..] KeywordOverride#
#                ^^^ reference [..] Class#new().
#                    ^^^^^^^ reference [..] KeywordOverride#deliver().
#                            ^^^^^^^^ reference local 3$217974539
#                            ^^^^^^^^ reference [..] KeywordOverride#deliver().(customer)
 
 block = T.let(-> {}, T.proc.void)
#^^^^^ definition local 10$217974539
#documentation
#| ```ruby
#| block (T.proc.void)
#| ```
#              ^^ reference [..] Kernel#
#                     ^ reference [..] T#
#                       ^^^^ reference [..] `<Class:T>`#proc().
 receiver.wrapped(customer:, &block)
#^^^^^^^^ reference local 1$217974539
#         ^^^^^^^ reference [..] KeywordReceiver#wrapped().
#                 ^^^^^^^^ reference local 3$217974539
#                 ^^^^^^^^ reference [..] KeywordReceiver#wrapped().(customer)
#                             ^^^^^ reference local 10$217974539
 receiver.wrapped(*[1, 2], customer: customer)
#^^^^^^^^ reference local 1$217974539
#         ^^^^^^^ reference [..] KeywordReceiver#wrapped().
#                          ^^^^^^^^ reference [..] KeywordReceiver#wrapped().(customer)
#                                    ^^^^^^^^ reference local 3$217974539
 receiver.wrapped(*[1, 2], customer:, &block)
#^^^^^^^^ reference local 1$217974539
#         ^^^^^^^ reference [..] KeywordReceiver#wrapped().
#                          ^^^^^^^^ reference local 3$217974539
#                          ^^^^^^^^ reference [..] KeywordReceiver#wrapped().(customer)
#                                      ^^^^^ reference local 10$217974539
 receiver.wrapped(*[1, 2], customer:) { customer.upcase }
#^^^^^^^^ reference local 1$217974539
#         ^^^^^^^ reference [..] KeywordReceiver#wrapped().
#                          ^^^^^^^^ reference local 3$217974539
#                          ^^^^^^^^ reference [..] KeywordReceiver#wrapped().(customer)
#                                       ^^^^^^^^ reference local 3$217974539
#                                                ^^^^^^ reference [..] String#upcase().
 
 # These keys are data, not named parameter references.
 receiver.extras(customer: customer)
#^^^^^^^^ reference local 1$217974539
#         ^^^^^^ reference [..] KeywordReceiver#extras().
#                          ^^^^^^^^ reference local 3$217974539
 receiver.positional(customer: customer)
#^^^^^^^^ reference local 1$217974539
#         ^^^^^^^^^^ reference [..] KeywordReceiver#positional().
#                              ^^^^^^^^ reference local 3$217974539
 keywords = {customer: customer}
#^^^^^^^^ definition local 11$217974539
#documentation
#| ```ruby
#| keywords ({customer: String("Ada")})
#| ```
#                      ^^^^^^^^ reference local 3$217974539
 receiver.deliver(**keywords)
#^^^^^^^^ reference local 1$217974539
#         ^^^^^^^ reference [..] KeywordReceiver#deliver().
#                   ^^^^^^^^ reference local 11$217974539
 receiver.deliver(**{customer: customer})
#^^^^^^^^ reference local 1$217974539
#         ^^^^^^^ reference [..] KeywordReceiver#deliver().
#                              ^^^^^^^^ reference local 3$217974539
