 # typed: true
 # enable-experimental-rbs-comments: true
 
#⌄ enclosing_range_start [..] Ranges#
 module Ranges
#       ^^^^^^ definition [..] Ranges#
#  ⌄ enclosing_range_start [..] Ranges#Models#
   module Models
#         ^^^^^^ definition [..] Ranges#Models#
#    ⌄ enclosing_range_start [..] Ranges#Models#Customer#
     class Customer
#          ^^^^^^^^ definition [..] Ranges#Models#Customer#
       #: -> String
#            ^^^^^^ reference [..] String#
#      ⌄ enclosing_range_start [..] Ranges#Models#Customer#name().
       def name
#          ^^^^ definition [..] Ranges#Models#Customer#name().
         "customer"
       end
#        ⌃ enclosing_range_end [..] Ranges#Models#Customer#name().
     end
#      ⌃ enclosing_range_end [..] Ranges#Models#Customer#
 
     #: type customer = Customer
#            ^^^^^^^^ definition [..] Ranges#Models#`type customer`.
#                       ^^^^^^^^ reference [..] Ranges#Models#Customer#
   end
#    ⌃ enclosing_range_end [..] Ranges#Models#
 
   #: type customer = ::Ranges::Models::Customer
#          ^^^^^^^^ definition [..] Ranges#`type customer`.
#                       ^^^^^^ reference [..] Ranges#
#                               ^^^^^^ reference [..] Ranges#Models#
#                                       ^^^^^^^^ reference [..] Ranges#Models#Customer#
   #: type copy = Ranges::Models::customer
#          ^^^^ definition [..] Ranges#`type copy`.
#                 ^^^^^^ reference [..] Ranges#
#                         ^^^^^^ reference [..] Ranges#Models#
#                                 ^^^^^^^^ reference [..] Ranges#Models#`type customer`.
   #: type pair = [
#          ^^^^ definition [..] Ranges#`type pair`.
   #|   Ranges::Models::customer,
#       ^^^^^^ reference [..] Ranges#
#               ^^^^^^ reference [..] Ranges#Models#
#                       ^^^^^^^^ reference [..] Ranges#Models#`type customer`.
   #|   ::Ranges::Models::Customer
#         ^^^^^^ reference [..] Ranges#
#                 ^^^^^^ reference [..] Ranges#Models#
#                         ^^^^^^^^ reference [..] Ranges#Models#Customer#
   #| ]
   #: type optional =
#          ^^^^^^^^ definition [..] Ranges#`type optional`.
   #|   Ranges::Models::customer?
#       ^^^^^^ reference [..] Ranges#
#               ^^^^^^ reference [..] Ranges#Models#
#                       ^^^^^^^^ reference [..] Ranges#Models#`type customer`.
 
   #: [out Elem <
#          ^^^^ definition [..] Ranges#Box#Elem#
   #|   ::Ranges::Models::Customer]
#         ^^^^^^ reference [..] Ranges#
#                 ^^^^^^ reference [..] Ranges#Models#
#                         ^^^^^^^^ reference [..] Ranges#Models#Customer#
#  ⌄ enclosing_range_start [..] Ranges#Box#
   class Box
#        ^^^ definition [..] Ranges#Box#
     #: Elem
#       ^^^^ reference [..] Ranges#Box#Elem#
#    ⌄ enclosing_range_start [..] Ranges#Box#value().
     attr_reader :value
#                 ^^^^^ definition [..] Ranges#Box#value().
#                     ⌃ enclosing_range_end [..] Ranges#Box#value().
 
     #: (Elem) -> void
#        ^^^^ reference [..] Ranges#Box#Elem#
#    ⌄ enclosing_range_start [..] Ranges#Box#initialize().
     def initialize(value)
#        ^^^^^^^^^^ definition [..] Ranges#Box#initialize().
#                   ^^^^^ definition local 1$621587515
       @value = value
#      ^^^^^^ definition [..] Ranges#Box#`@value`.
#      ^^^^^^^^^^^^^^ reference [..] Ranges#Box#`@value`.
#               ^^^^^ reference local 1$621587515
     end
#      ⌃ enclosing_range_end [..] Ranges#Box#initialize().
   end
#    ⌃ enclosing_range_end [..] Ranges#Box#
 
   #: [Elem = Ranges::Models::Customer]
#      ^^^^ definition [..] Ranges#Fixed#Elem#
#             ^^^^^^ reference [..] Ranges#
#                     ^^^^^^ reference [..] Ranges#Models#
#                             ^^^^^^^^ reference [..] Ranges#Models#Customer#
#  ⌄ enclosing_range_start [..] Ranges#Fixed#
   class Fixed; end
#        ^^^^^ definition [..] Ranges#Fixed#
#                 ⌃ enclosing_range_end [..] Ranges#Fixed#
 
#  ⌄ enclosing_range_start [..] Ranges#Reader#
   class Reader
#        ^^^^^^ definition [..] Ranges#Reader#
     #: Ranges::Models::customer
#       ^^^^^^ reference [..] Ranges#
#               ^^^^^^ reference [..] Ranges#Models#
#                       ^^^^^^^^ reference [..] Ranges#Models#`type customer`.
#    ⌄ enclosing_range_start [..] Ranges#Reader#customer().
     attr_reader :customer
#                 ^^^^^^^^ definition [..] Ranges#Reader#customer().
#                        ⌃ enclosing_range_end [..] Ranges#Reader#customer().
 
     #: (Ranges::Models::Customer) -> void
#        ^^^^^^ reference [..] Ranges#
#                ^^^^^^ reference [..] Ranges#Models#
#                        ^^^^^^^^ reference [..] Ranges#Models#Customer#
#    ⌄ enclosing_range_start [..] Ranges#Reader#initialize().
     def initialize(customer)
#        ^^^^^^^^^^ definition [..] Ranges#Reader#initialize().
#                   ^^^^^^^^ definition local 1$2389659779
       @customer = customer
#      ^^^^^^^^^ definition [..] Ranges#Reader#`@customer`.
#      ^^^^^^^^^^^^^^^^^^^^ reference [..] Ranges#Reader#`@customer`.
#                  ^^^^^^^^ reference local 1$2389659779
     end
#      ⌃ enclosing_range_end [..] Ranges#Reader#initialize().
   end
#    ⌃ enclosing_range_end [..] Ranges#Reader#
 end
#  ⌃ enclosing_range_end [..] Ranges#
 
 #: (Ranges::customer) -> Ranges::copy
#    ^^^^^^ reference [..] Ranges#
#            ^^^^^^^^ reference [..] Ranges#`type customer`.
#                         ^^^^^^ reference [..] Ranges#
#                                 ^^^^ reference [..] Ranges#`type copy`.
#⌄ enclosing_range_start [..] Object#customer_echo().
 def customer_echo(value)
#    ^^^^^^^^^^^^^ definition [..] Object#customer_echo().
#                  ^^^^^ definition local 1$1878604689
   value
#  ^^^^^ reference local 1$1878604689
 end
#  ⌃ enclosing_range_end [..] Object#customer_echo().
 
 #: (
 #|   ::Ranges::Models::customer,
#       ^^^^^^ reference [..] Ranges#
#               ^^^^^^ reference [..] Ranges#Models#
#                       ^^^^^^^^ reference [..] Ranges#Models#`type customer`.
 #|   Ranges::Models::Customer
#     ^^^^^^ reference [..] Ranges#
#             ^^^^^^ reference [..] Ranges#Models#
#                     ^^^^^^^^ reference [..] Ranges#Models#Customer#
 #| ) -> Ranges::pair
#        ^^^^^^ reference [..] Ranges#
#                ^^^^ reference [..] Ranges#`type pair`.
#⌄ enclosing_range_start [..] Object#pair().
 def pair(first, second)
#    ^^^^ definition [..] Object#pair().
#         ^^^^^ definition local 1$2485926875
#                ^^^^^^ definition local 2$2485926875
   [first, second]
#   ^^^^^ reference local 1$2485926875
#          ^^^^^^ reference local 2$2485926875
 end
#  ⌃ enclosing_range_end [..] Object#pair().
 
 #: (Ranges::optional) -> Ranges::optional
#    ^^^^^^ reference [..] Ranges#
#            ^^^^^^^^ reference [..] Ranges#`type optional`.
#                         ^^^^^^ reference [..] Ranges#
#                                 ^^^^^^^^ reference [..] Ranges#`type optional`.
#⌄ enclosing_range_start [..] Object#optional().
 def optional(value)
#    ^^^^^^^^ definition [..] Object#optional().
#             ^^^^^ definition local 1$3023001291
   value
#  ^^^^^ reference local 1$3023001291
 end
#  ⌃ enclosing_range_end [..] Object#optional().
 
 #: [Elem] (Elem?) -> Elem?
#    ^^^^ definition [..] Object#generic().[Elem]
#           ^^^^ reference [..] Object#generic().[Elem]
#                     ^^^^ reference [..] Object#generic().[Elem]
#⌄ enclosing_range_start [..] Object#generic().
 def generic(value)
#    ^^^^^^^ definition [..] Object#generic().
#            ^^^^^ definition local 1$1084842404
   value #: Elem?
#  ^^^^^ reference local 1$1084842404
#           ^^^^ reference [..] Object#generic().[Elem]
 end
#  ⌃ enclosing_range_end [..] Object#generic().
 
 #: (Array[Ranges::Models::Customer]) -> Array[Ranges::Models::customer]
#    ^^^^^ reference [..] T#Array#
#          ^^^^^^ reference [..] Ranges#
#                  ^^^^^^ reference [..] Ranges#Models#
#                          ^^^^^^^^ reference [..] Ranges#Models#Customer#
#                                        ^^^^^ reference [..] T#Array#
#                                              ^^^^^^ reference [..] Ranges#
#                                                      ^^^^^^ reference [..] Ranges#Models#
#                                                              ^^^^^^^^ reference [..] Ranges#Models#`type customer`.
#⌄ enclosing_range_start [..] Object#customers().
 def customers(values)
#    ^^^^^^^^^ definition [..] Object#customers().
#              ^^^^^^ definition local 1$3950896148
   values
#  ^^^^^^ reference local 1$3950896148
 end
#  ⌃ enclosing_range_end [..] Object#customers().
 
 #: (Enumerator::Lazy[Ranges::customer]) -> ::Enumerator::Lazy[Ranges::customer]
#    ^^^^^^^^^^ reference [..] T#Enumerator#
#                ^^^^ reference [..] T#Enumerator#Lazy#
#                     ^^^^^^ reference [..] Ranges#
#                             ^^^^^^^^ reference [..] Ranges#`type customer`.
#                                             ^^^^^^^^^^ reference [..] T#Enumerator#
#                                                         ^^^^ reference [..] T#Enumerator#Lazy#
#                                                              ^^^^^^ reference [..] Ranges#
#                                                                      ^^^^^^^^ reference [..] Ranges#`type customer`.
#⌄ enclosing_range_start [..] Object#lazy().
 def lazy(values)
#    ^^^^ definition [..] Object#lazy().
#         ^^^^^^ definition local 1$8220481
   values
#  ^^^^^^ reference local 1$8220481
 end
#  ⌃ enclosing_range_end [..] Object#lazy().
 
 #: (Enumerator::Chain[Ranges::customer]) -> ::Enumerator::Chain[Ranges::customer]
#    ^^^^^^^^^^ reference [..] T#Enumerator#
#                ^^^^^ reference [..] T#Enumerator#Chain#
#                      ^^^^^^ reference [..] Ranges#
#                              ^^^^^^^^ reference [..] Ranges#`type customer`.
#                                              ^^^^^^^^^^ reference [..] T#Enumerator#
#                                                          ^^^^^ reference [..] T#Enumerator#Chain#
#                                                                ^^^^^^ reference [..] Ranges#
#                                                                        ^^^^^^^^ reference [..] Ranges#`type customer`.
#⌄ enclosing_range_start [..] Object#chain().
 def chain(values)
#    ^^^^^ definition [..] Object#chain().
#          ^^^^^^ definition local 1$2236280368
   values
#  ^^^^^^ reference local 1$2236280368
 end
#  ⌃ enclosing_range_end [..] Object#chain().
 
 customer = Ranges::Models::Customer.new
#^^^^^^^^ definition local 9$217974539
#           ^^^^^^ reference [..] Ranges#
#                   ^^^^^^ reference [..] Ranges#Models#
#                           ^^^^^^^^ reference [..] Ranges#Models#Customer#
#                                    ^^^ reference [..] Class#new().
 customer_echo(customer).name
#^^^^^^^^^^^^^ reference [..] Object#customer_echo().
#              ^^^^^^^^ reference local 9$217974539
#                        ^^^^ reference [..] Ranges#Models#Customer#name().
 Ranges::Reader.new(customer).customer.name
#^^^^^^ reference [..] Ranges#
#        ^^^^^^ reference [..] Ranges#Reader#
#               ^^^ reference [..] Ranges#Reader#initialize().
#                   ^^^^^^^^ reference local 9$217974539
#                             ^^^^^^^^ reference [..] Ranges#Reader#customer().
#                                      ^^^^ reference [..] Ranges#Models#Customer#name().
 pair(customer, customer)
#^^^^ reference [..] Object#pair().
#     ^^^^^^^^ reference local 9$217974539
#               ^^^^^^^^ reference local 9$217974539
 optional(customer)
#^^^^^^^^ reference [..] Object#optional().
#         ^^^^^^^^ reference local 9$217974539
 generic(customer)
#^^^^^^^ reference [..] Object#generic().
#        ^^^^^^^^ reference local 9$217974539
 customers([customer])
#^^^^^^^^^ reference [..] Object#customers().
#           ^^^^^^^^ reference local 9$217974539
 box = Ranges::Box.new(customer) #: Ranges::Box[Ranges::Models::Customer]
#^^^ definition local 16$217974539
#      ^^^^^^ reference [..] Ranges#
#              ^^^ reference [..] Ranges#Box#
#                      ^^^^^^^^ reference local 9$217974539
#                                   ^^^^^^ reference [..] Ranges#
#                                           ^^^ reference [..] Ranges#Box#
#                                               ^^^^^^ reference [..] Ranges#
#                                                       ^^^^^^ reference [..] Ranges#Models#
#                                                               ^^^^^^^^ reference [..] Ranges#Models#Customer#
 box.value.name
#^^^ reference local 16$217974539
#    ^^^^^ reference [..] Ranges#Box#value().
#          ^^^^ reference [..] Ranges#Models#Customer#name().
 fixed = Ranges::Fixed.new #: Ranges::Fixed
#^^^^^ definition local 19$217974539
#        ^^^^^^ reference [..] Ranges#
#                ^^^^^ reference [..] Ranges#Fixed#
#                      ^^^ reference [..] Class#new().
#                             ^^^^^^ reference [..] Ranges#
#                                     ^^^^^ reference [..] Ranges#Fixed#
 value = customer #: Ranges::Models::customer
#^^^^^ definition local 20$217974539
#        ^^^^^^^^ reference local 9$217974539
#                    ^^^^^^ reference [..] Ranges#
#                            ^^^^^^ reference [..] Ranges#Models#
#                                    ^^^^^^^^ reference [..] Ranges#Models#`type customer`.
 value.name
#^^^^^ reference local 20$217974539
#      ^^^^ reference [..] Ranges#Models#Customer#name().
 
 # Handwritten Sorbet syntax must keep its own T and type references.
 T.let(customer, T.nilable(Ranges::Models::Customer))
#      ^^^^^^^^ reference local 9$217974539
#                ^ reference [..] T#
#                  ^^^^^^^ reference [..] `<Class:T>`#nilable().
#                          ^^^^^^ reference [..] Ranges#
#                                  ^^^^^^ reference [..] Ranges#Models#
#                                          ^^^^^^^^ reference [..] Ranges#Models#Customer#
