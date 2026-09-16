 # typed: true
 # enable-experimental-rspec: true
 # Adapted from test/testdata/rewriter/minitest_let.rb and rspec_describe.rb.
 
#⌄ enclosing_range_start [..] RSpec#
 module RSpec
#       ^^^^^ definition [..] RSpec#
#  ⌄ enclosing_range_start [..] RSpec#Core#
   module Core
#         ^^^^ definition [..] RSpec#Core#
#    ⌄ enclosing_range_start [..] RSpec#Core#ExampleGroup#
     class ExampleGroup
#          ^^^^^^^^^^^^ definition [..] RSpec#Core#ExampleGroup#
#      ⌄ enclosing_range_start [..] RSpec#Core#`<Class:ExampleGroup>`#test_each().
       def self.test_each(values, &block); end
#               ^^^^^^^^^ definition [..] RSpec#Core#`<Class:ExampleGroup>`#test_each().
#                                            ⌃ enclosing_range_end [..] RSpec#Core#`<Class:ExampleGroup>`#test_each().
     end
#      ⌃ enclosing_range_end [..] RSpec#Core#ExampleGroup#
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
   extend T::Sig
#  ^^^^^^ reference [..] Kernel#extend().
   sig { returns(String) }
#                ^^^^^^ reference [..] String#
#  ⌄ enclosing_range_start [..] Customer#name().
   def name; "Alice"; end
#      ^^^^ definition [..] Customer#name().
#                       ⌃ enclosing_range_end [..] Customer#name().
 end
#  ⌃ enclosing_range_end [..] Customer#
 
#⌄ enclosing_range_start [..] GeneratedAccessor#
 class GeneratedAccessor
#      ^^^^^^^^^^^^^^^^^ definition [..] GeneratedAccessor#
#  ⌄ enclosing_range_start [..] GeneratedAccessor#ordinary().
   attr_reader :ordinary
#               ^^^^^^^^ definition [..] GeneratedAccessor#ordinary().
#                      ⌃ enclosing_range_end [..] GeneratedAccessor#ordinary().
 end
#  ⌃ enclosing_range_end [..] GeneratedAccessor#
 
 RSpec.describe Customer do
#               ^^^^^^^^ reference [..] Customer#
#  ⌄ enclosing_range_start [..] `<describe 'Customer'>`#`<describe 'helpers'>`#
   describe("helpers") do
#           ^^^^^^^^^ reference [..] `<describe 'Customer'>`#
#           ^^^^^^^^^ definition [..] `<describe 'Customer'>`#`<describe 'helpers'>`#
#    ⌄ enclosing_range_start [..] `<describe 'Customer'>`#`<describe 'helpers'>`#ordinary().
     let(:ordinary) do
#        ^^^^^^^^^ definition [..] `<describe 'Customer'>`#`<describe 'helpers'>`#ordinary().
       customer = Customer.new
#      ^^^^^^^^ definition local 1$1152480723
#                 ^^^^^^^^ reference [..] Customer#
#                          ^^^ reference [..] Class#new().
       customer.name
#      ^^^^^^^^ reference local 1$1152480723
#               ^^^^ reference [..] Customer#name().
     end
#      ⌃ enclosing_range_end [..] `<describe 'Customer'>`#`<describe 'helpers'>`#ordinary().
 
#    ⌄ enclosing_range_start [..] `<describe 'Customer'>`#`<describe 'helpers'>`#eager().
     let!("eager") { Customer.new.name }
#         ^^^^^^^ definition [..] `<describe 'Customer'>`#`<describe 'helpers'>`#eager().
#                    ^^^^^^^^ reference [..] Customer#
#                             ^^^ reference [..] Class#new().
#                                 ^^^^ reference [..] Customer#name().
#                                      ⌃ enclosing_range_end [..] `<describe 'Customer'>`#`<describe 'helpers'>`#eager().
#    ⌄ enclosing_range_start [..] `<describe 'Customer'>`#`<describe 'helpers'>`#named().
     subject(:named) { Customer.new.name }
#            ^^^^^^ definition [..] `<describe 'Customer'>`#`<describe 'helpers'>`#named().
#                      ^^^^^^^^ reference [..] Customer#
#                               ^^^ reference [..] Class#new().
#                                   ^^^^ reference [..] Customer#name().
#                                        ⌃ enclosing_range_end [..] `<describe 'Customer'>`#`<describe 'helpers'>`#named().
 
#    ⌄ enclosing_range_start [..] `<describe 'Customer'>`#`<describe 'helpers'>`#subject().
     subject do
#    ^^^^^^^ definition [..] `<describe 'Customer'>`#`<describe 'helpers'>`#subject().
       customer = Customer.new
#      ^^^^^^^^ definition local 1$2300378703
#                 ^^^^^^^^ reference [..] Customer#
#                          ^^^ reference [..] Class#new().
       customers = T.let([customer], T::Array[Customer])
#      ^^^^^^^^^ definition local 5$2300378703
#                         ^^^^^^^^ reference local 1$2300378703
#                                    ^ reference [..] T#
#                                       ^^^^^ reference [..] T#Array#
#                                            ^ reference [..] T#`<Class:Array>`#`[]`().
#                                             ^^^^^^^^ reference [..] Customer#
       customers.map do |customer|
#      ^^^^^^^^^ reference local 5$2300378703
#                ^^^ reference [..] Array#map().
#                        ^^^^^^^^ definition local 6$2300378703
         customer.name
#        ^^^^^^^^ reference local 6$2300378703
#                 ^^^^ reference [..] Customer#name().
       end
     end
#      ⌃ enclosing_range_end [..] `<describe 'Customer'>`#`<describe 'helpers'>`#subject().
 
#    ⌄ enclosing_range_start [..] `<describe 'Customer'>`#`<describe 'helpers'>`#empty().
     let(:empty) {}
#        ^^^^^^ definition [..] `<describe 'Customer'>`#`<describe 'helpers'>`#empty().
#                 ⌃ enclosing_range_end [..] `<describe 'Customer'>`#`<describe 'helpers'>`#empty().
 
#    ⌄ enclosing_range_start [..] `<describe 'Customer'>`#`<describe 'helpers'>`#`<it 'uses the helpers'>`().
     it("uses the helpers") { ordinary; eager; named; subject; empty }
#       ^^^^^^^^^^^^^^^^^^ definition [..] `<describe 'Customer'>`#`<describe 'helpers'>`#`<it 'uses the helpers'>`().
#                             ^^^^^^^^ reference [..] `<describe 'Customer'>`#`<describe 'helpers'>`#ordinary().
#                                       ^^^^^ reference [..] `<describe 'Customer'>`#`<describe 'helpers'>`#eager().
#                                              ^^^^^ reference [..] `<describe 'Customer'>`#`<describe 'helpers'>`#named().
#                                                     ^^^^^^^ reference [..] `<describe 'Customer'>`#`<describe 'helpers'>`#subject().
#                                                              ^^^^^ reference [..] `<describe 'Customer'>`#`<describe 'helpers'>`#empty().
#                                                                    ⌃ enclosing_range_end [..] `<describe 'Customer'>`#`<describe 'helpers'>`#`<it 'uses the helpers'>`().
 
#    ⌄ enclosing_range_start [..] `<describe 'Customer'>`#`<describe 'helpers'>`#`<describe 'nested helpers'>`#
     describe("nested helpers") do
#             ^^^^^^^^^^^^^^^^ reference [..] `<describe 'Customer'>`#`<describe 'helpers'>`#
#             ^^^^^^^^^^^^^^^^ definition [..] `<describe 'Customer'>`#`<describe 'helpers'>`#`<describe 'nested helpers'>`#
#      ⌄ enclosing_range_start [..] `<describe 'Customer'>`#`<describe 'helpers'>`#`<describe 'nested helpers'>`#ordinary().
       let("ordinary") { Customer.new.name }
#          ^^^^^^^^^^ definition [..] `<describe 'Customer'>`#`<describe 'helpers'>`#`<describe 'nested helpers'>`#ordinary().
#                        ^^^^^^^^ reference [..] Customer#
#                                 ^^^ reference [..] Class#new().
#                                     ^^^^ reference [..] Customer#name().
#                                          ⌃ enclosing_range_end [..] `<describe 'Customer'>`#`<describe 'helpers'>`#`<describe 'nested helpers'>`#ordinary().
#      ⌄ enclosing_range_start [..] `<describe 'Customer'>`#`<describe 'helpers'>`#`<describe 'nested helpers'>`#`<it 'uses the nested helper'>`().
       it("uses the nested helper") { ordinary; subject }
#         ^^^^^^^^^^^^^^^^^^^^^^^^ definition [..] `<describe 'Customer'>`#`<describe 'helpers'>`#`<describe 'nested helpers'>`#`<it 'uses the nested helper'>`().
#                                     ^^^^^^^^ reference [..] `<describe 'Customer'>`#`<describe 'helpers'>`#`<describe 'nested helpers'>`#ordinary().
#                                               ^^^^^^^ reference [..] `<describe 'Customer'>`#`<describe 'helpers'>`#subject().
#                                                       ⌃ enclosing_range_end [..] `<describe 'Customer'>`#`<describe 'helpers'>`#`<describe 'nested helpers'>`#`<it 'uses the nested helper'>`().
     end
#      ⌃ enclosing_range_end [..] `<describe 'Customer'>`#`<describe 'helpers'>`#`<describe 'nested helpers'>`#
   end
#    ⌃ enclosing_range_end [..] `<describe 'Customer'>`#`<describe 'helpers'>`#
 
   test_each([1]) do |unused|
#  ^^^^^^^^^ reference [..] RSpec#Core#`<Class:ExampleGroup>`#test_each().
#                     ^^^^^^ definition local 1$119448696
#                     ^^^^^^ definition local 1$1835867214
     describe("parameterized helpers") do
#      ⌄ enclosing_range_start [..] `<describe 'Customer'>`#ordinary().
       let(:ordinary) { Customer.new.name }
#          ^^^^^^^^^ definition [..] `<describe 'Customer'>`#ordinary().
#                       ^^^^^^^^ reference [..] Customer#
#                                ^^^ reference [..] Class#new().
#                                    ^^^^ reference [..] Customer#name().
#                                         ⌃ enclosing_range_end [..] `<describe 'Customer'>`#ordinary().
#      ⌄ enclosing_range_start [..] `<describe 'Customer'>`#eager().
       let!(:eager) { Customer.new.name }
#           ^^^^^^ definition [..] `<describe 'Customer'>`#eager().
#                     ^^^^^^^^ reference [..] Customer#
#                              ^^^ reference [..] Class#new().
#                                  ^^^^ reference [..] Customer#name().
#                                       ⌃ enclosing_range_end [..] `<describe 'Customer'>`#eager().
#      ⌄ enclosing_range_start [..] `<describe 'Customer'>`#named().
       subject("named") { Customer.new.name }
#              ^^^^^^^ definition [..] `<describe 'Customer'>`#named().
#                         ^^^^^^^^ reference [..] Customer#
#                                  ^^^ reference [..] Class#new().
#                                      ^^^^ reference [..] Customer#name().
#                                           ⌃ enclosing_range_end [..] `<describe 'Customer'>`#named().
#      ⌄ enclosing_range_start [..] `<describe 'Customer'>`#subject().
       subject { Customer.new.name }
#      ^^^^^^^ definition [..] `<describe 'Customer'>`#subject().
#                ^^^^^^^^ reference [..] Customer#
#                         ^^^ reference [..] Class#new().
#                             ^^^^ reference [..] Customer#name().
#                                  ⌃ enclosing_range_end [..] `<describe 'Customer'>`#subject().
#      ⌄ enclosing_range_start [..] `<describe 'Customer'>`#`<it 'uses parameterized helpers'>`().
       it("uses parameterized helpers") { ordinary; eager; named; subject }
#         ^^^^^^^^^^^^^^^^^^^^^^^^^^^^ definition [..] `<describe 'Customer'>`#`<it 'uses parameterized helpers'>`().
#                                         ^^^^^^^^ reference [..] `<describe 'Customer'>`#ordinary().
#                                                   ^^^^^ reference [..] `<describe 'Customer'>`#eager().
#                                                          ^^^^^ reference [..] `<describe 'Customer'>`#named().
#                                                                 ^^^^^^^ reference [..] `<describe 'Customer'>`#subject().
#                                                                         ⌃ enclosing_range_end [..] `<describe 'Customer'>`#`<it 'uses parameterized helpers'>`().
     end
   end
 end
