 # typed: true
 # enable-experimental-rspec: true
 # Adapted from test/testdata/rewriter/rspec_describe.rb.
 # Generated describe classes and described_class methods can have empty name locations.
 
#⌄ enclosing_range_start [..] RSpec#
 module RSpec
#       ^^^^^ definition [..] RSpec#
#  ⌄ enclosing_range_start [..] RSpec#Core#
   module Core
#         ^^^^ definition [..] RSpec#Core#
#    ⌄ enclosing_range_start [..] RSpec#Core#ExampleGroup#
     class ExampleGroup; end
#          ^^^^^^^^^^^^ definition [..] RSpec#Core#ExampleGroup#
#                          ⌃ enclosing_range_end [..] RSpec#Core#ExampleGroup#
   end
#    ⌃ enclosing_range_end [..] RSpec#Core#
#  ⌄ enclosing_range_start [..] `<Class:RSpec>`#describe().
   def self.describe(description, *args, &block); end
#           ^^^^^^^^ definition [..] `<Class:RSpec>`#describe().
#                                                   ⌃ enclosing_range_end [..] `<Class:RSpec>`#describe().
 end
#  ⌃ enclosing_range_end [..] RSpec#
 
#⌄ enclosing_range_start [..] Customer#
 class Customer
#      ^^^^^^^^ definition [..] Customer#
#  ⌄ enclosing_range_start [..] Customer#name().
   def name; "Alice"; end
#      ^^^^ definition [..] Customer#name().
#                       ⌃ enclosing_range_end [..] Customer#name().
 end
#  ⌃ enclosing_range_end [..] Customer#
 
#⌄ enclosing_range_start [..] Billing#
 module Billing
#       ^^^^^^^ definition [..] Billing#
#  ⌄ enclosing_range_start [..] Billing#Customer#
   class Customer
#        ^^^^^^^^ definition [..] Billing#Customer#
#    ⌄ enclosing_range_start [..] Billing#Customer#account().
     def account; "billing"; end
#        ^^^^^^^ definition [..] Billing#Customer#account().
#                              ⌃ enclosing_range_end [..] Billing#Customer#account().
   end
#    ⌃ enclosing_range_end [..] Billing#Customer#
 end
#  ⌃ enclosing_range_end [..] Billing#
 
 RSpec.describe Customer do
#^^^^^ reference [..] RSpec#
#      ^^^^^^^^ reference [..] `<Class:RSpec>`#describe().
#               ^^^^^^^^ reference [..] Customer#
#               ^^^^^^^^ reference [..] Customer#
#  ⌄ enclosing_range_start [..] `<describe 'Customer'>`#`<it 'indexes a constant description'>`().
   it("indexes a constant description") do
#     ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ definition [..] `<describe 'Customer'>`#`<it 'indexes a constant description'>`().
     customer = Customer.new
#    ^^^^^^^^ definition local 1$1350504531
#               ^^^^^^^^ reference [..] Customer#
#                        ^^^ reference [..] Class#new().
     customer.name
#    ^^^^^^^^ reference local 1$1350504531
#             ^^^^ reference [..] Customer#name().
     described_class.new.name
#    ^^^^^^^^^^^^^^^ reference [..] `<describe 'Customer'>`#described_class().
#                    ^^^ reference [..] Class#new().
#                        ^^^^ reference [..] Customer#name().
   end
#    ⌃ enclosing_range_end [..] `<describe 'Customer'>`#`<it 'indexes a constant description'>`().
 
#  ⌄ enclosing_range_start [..] `<describe 'Customer'>`#`<context 'inherits the described class'>`#
   context("inherits the described class") do
#          ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ reference [..] `<describe 'Customer'>`#
#          ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ definition [..] `<describe 'Customer'>`#`<context 'inherits the described class'>`#
#    ⌄ enclosing_range_start [..] `<describe 'Customer'>`#`<context 'inherits the described class'>`#`<it 'indexes a nested example'>`().
     it("indexes a nested example") { described_class.new.name }
#       ^^^^^^^^^^^^^^^^^^^^^^^^^^ definition [..] `<describe 'Customer'>`#`<context 'inherits the described class'>`#`<it 'indexes a nested example'>`().
#                                     ^^^^^^^^^^^^^^^ reference [..] `<describe 'Customer'>`#described_class().
#                                                     ^^^ reference [..] Class#new().
#                                                         ^^^^ reference [..] Customer#name().
#                                                              ⌃ enclosing_range_end [..] `<describe 'Customer'>`#`<context 'inherits the described class'>`#`<it 'indexes a nested example'>`().
   end
#    ⌃ enclosing_range_end [..] `<describe 'Customer'>`#`<context 'inherits the described class'>`#
 
#  ⌄ enclosing_range_start [..] `<describe 'Customer'>`#`<context 'Billing::Customer'>`#
   context Billing::Customer do
#          ^^^^^^^ reference [..] Billing#
#                   ^^^^^^^^ reference [..] Billing#Customer#
#                   ^^^^^^^^ reference [..] Billing#Customer#
#                   ^^^^^^^^ reference [..] `<describe 'Customer'>`#
#                   ^^^^^^^^ definition [..] `<describe 'Customer'>`#`<context 'Billing::Customer'>`#
#    ⌄ enclosing_range_start [..] `<describe 'Customer'>`#`<context 'Billing::Customer'>`#`<it 'uses the nested described class'>`().
     it("uses the nested described class") { described_class.new.account }
#       ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ definition [..] `<describe 'Customer'>`#`<context 'Billing::Customer'>`#`<it 'uses the nested described class'>`().
#                                            ^^^^^^^^^^^^^^^ reference [..] `<describe 'Customer'>`#`<context 'Billing::Customer'>`#described_class().
#                                                            ^^^ reference [..] Class#new().
#                                                                ^^^^^^^ reference [..] Billing#Customer#account().
#                                                                        ⌃ enclosing_range_end [..] `<describe 'Customer'>`#`<context 'Billing::Customer'>`#`<it 'uses the nested described class'>`().
   end
#    ⌃ enclosing_range_end [..] `<describe 'Customer'>`#`<context 'Billing::Customer'>`#
 
#  ⌄ enclosing_range_start [..] `<describe 'Customer'>`#`<describe 'Customer'>`#
   describe Customer do
#           ^^^^^^^^ reference [..] Customer#
#           ^^^^^^^^ reference [..] Customer#
#           ^^^^^^^^ reference [..] `<describe 'Customer'>`#
#           ^^^^^^^^ definition [..] `<describe 'Customer'>`#`<describe 'Customer'>`#
#    ⌄ enclosing_range_start [..] `<describe 'Customer'>`#`<describe 'Customer'>`#`<it 'indexes a nested describe'>`().
     it("indexes a nested describe") { described_class.new.name }
#       ^^^^^^^^^^^^^^^^^^^^^^^^^^^ definition [..] `<describe 'Customer'>`#`<describe 'Customer'>`#`<it 'indexes a nested describe'>`().
#                                      ^^^^^^^^^^^^^^^ reference [..] `<describe 'Customer'>`#`<describe 'Customer'>`#described_class().
#                                                      ^^^ reference [..] Class#new().
#                                                          ^^^^ reference [..] Customer#name().
#                                                               ⌃ enclosing_range_end [..] `<describe 'Customer'>`#`<describe 'Customer'>`#`<it 'indexes a nested describe'>`().
   end
#    ⌃ enclosing_range_end [..] `<describe 'Customer'>`#`<describe 'Customer'>`#
 end
 
 RSpec.describe Billing::Customer do
#^^^^^ reference [..] RSpec#
#      ^^^^^^^^ reference [..] `<Class:RSpec>`#describe().
#               ^^^^^^^ reference [..] Billing#
#                        ^^^^^^^^ reference [..] Billing#Customer#
#                        ^^^^^^^^ reference [..] Billing#Customer#
#  ⌄ enclosing_range_start [..] `<describe 'Billing::Customer'>`#`<it 'indexes a namespaced description'>`().
   it("indexes a namespaced description") do
#     ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ definition [..] `<describe 'Billing::Customer'>`#`<it 'indexes a namespaced description'>`().
     Billing::Customer.new.account
#    ^^^^^^^ reference [..] Billing#
#             ^^^^^^^^ reference [..] Billing#Customer#
#                      ^^^ reference [..] Class#new().
#                          ^^^^^^^ reference [..] Billing#Customer#account().
     described_class.new.account
#    ^^^^^^^^^^^^^^^ reference [..] `<describe 'Billing::Customer'>`#described_class().
#                    ^^^ reference [..] Class#new().
#                        ^^^^^^^ reference [..] Billing#Customer#account().
   end
#    ⌃ enclosing_range_end [..] `<describe 'Billing::Customer'>`#`<it 'indexes a namespaced description'>`().
 end
 
#⌄ enclosing_range_start [..] CustomCustomer#
 class CustomCustomer < Customer; end
#      ^^^^^^^^^^^^^^ definition [..] CustomCustomer#
#                       ^^^^^^^^ reference [..] Customer#
#                                   ⌃ enclosing_range_end [..] CustomCustomer#
 
 RSpec.describe CustomCustomer do
#^^^^^ reference [..] RSpec#
#      ^^^^^^^^ reference [..] `<Class:RSpec>`#describe().
#               ^^^^^^^^^^^^^^ reference [..] CustomCustomer#
#               ^^^^^^^^^^^^^^ reference [..] CustomCustomer#
   extend T::Sig
#  ^^^^^^ reference [..] Kernel#extend().
   sig { returns(T.class_of(CustomCustomer)) }
#                           ^^^^^^^^^^^^^^ reference [..] CustomCustomer#
#  ⌄ enclosing_range_start [..] `<describe 'CustomCustomer'>`#described_class().
   def described_class; CustomCustomer; end
#      ^^^^^^^^^^^^^^^ definition [..] `<describe 'CustomCustomer'>`#described_class().
#                       ^^^^^^^^^^^^^^ reference [..] CustomCustomer#
#                                         ⌃ enclosing_range_end [..] `<describe 'CustomCustomer'>`#described_class().
#  ⌄ enclosing_range_start [..] `<describe 'CustomCustomer'>`#`<it 'keeps a handwritten definition'>`().
   it("keeps a handwritten definition") { described_class.new.name }
#     ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ definition [..] `<describe 'CustomCustomer'>`#`<it 'keeps a handwritten definition'>`().
#                                         ^^^^^^^^^^^^^^^ reference [..] `<describe 'CustomCustomer'>`#described_class().
#                                                         ^^^ reference [..] Class#new().
#                                                             ^^^^ reference [..] Customer#name().
#                                                                  ⌃ enclosing_range_end [..] `<describe 'CustomCustomer'>`#`<it 'keeps a handwritten definition'>`().
 end
