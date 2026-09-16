 # typed: true
 # Adapted from test/testdata/rewriter/minitest_let.rb.
 
#⌄ enclosing_range_start [..] Minitest#
 module Minitest
#       ^^^^^^^^ definition [..] Minitest#
#  ⌄ enclosing_range_start [..] Minitest#Spec#
   class Spec
#        ^^^^ definition [..] Minitest#Spec#
#    ⌄ enclosing_range_start [..] Minitest#`<Class:Spec>`#describe().
     def self.describe(name, &block); end
#             ^^^^^^^^ definition [..] Minitest#`<Class:Spec>`#describe().
#                                       ⌃ enclosing_range_end [..] Minitest#`<Class:Spec>`#describe().
#    ⌄ enclosing_range_start [..] Minitest#`<Class:Spec>`#test_each().
     def self.test_each(values, &block); end
#             ^^^^^^^^^ definition [..] Minitest#`<Class:Spec>`#test_each().
#                                          ⌃ enclosing_range_end [..] Minitest#`<Class:Spec>`#test_each().
   end
#    ⌃ enclosing_range_end [..] Minitest#Spec#
 end
#  ⌃ enclosing_range_end [..] Minitest#
 
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
 
#⌄ enclosing_range_start [..] CustomerSpec#
 class CustomerSpec < Minitest::Spec
#      ^^^^^^^^^^^^ definition [..] CustomerSpec#
#                     ^^^^^^^^ reference [..] Minitest#
#                               ^^^^ reference [..] Minitest#Spec#
#  ⌄ enclosing_range_start [..] CustomerSpec#`<describe 'helpers'>`#
   describe("helpers") do
#  ^^^^^^^^ reference [..] Minitest#`<Class:Spec>`#describe().
#           ^^^^^^^^^ reference [..] CustomerSpec#
#           ^^^^^^^^^ definition [..] CustomerSpec#`<describe 'helpers'>`#
#    ⌄ enclosing_range_start [..] CustomerSpec#`<describe 'helpers'>`#ordinary().
     let(:ordinary) do
#        ^^^^^^^^^ definition [..] CustomerSpec#`<describe 'helpers'>`#ordinary().
       customer = Customer.new
#      ^^^^^^^^ definition local 1$3706689357
#                 ^^^^^^^^ reference [..] Customer#
#                          ^^^ reference [..] Class#new().
       customer.name
#      ^^^^^^^^ reference local 1$3706689357
#               ^^^^ reference [..] Customer#name().
     end
#      ⌃ enclosing_range_end [..] CustomerSpec#`<describe 'helpers'>`#ordinary().
 
#    ⌄ enclosing_range_start [..] CustomerSpec#`<describe 'helpers'>`#eager().
     let!("eager") { Customer.new.name }
#         ^^^^^^^ definition [..] CustomerSpec#`<describe 'helpers'>`#eager().
#                    ^^^^^^^^ reference [..] Customer#
#                             ^^^ reference [..] Class#new().
#                                 ^^^^ reference [..] Customer#name().
#                                      ⌃ enclosing_range_end [..] CustomerSpec#`<describe 'helpers'>`#eager().
#    ⌄ enclosing_range_start [..] CustomerSpec#`<describe 'helpers'>`#named().
     subject(:named) { Customer.new.name }
#            ^^^^^^ definition [..] CustomerSpec#`<describe 'helpers'>`#named().
#                      ^^^^^^^^ reference [..] Customer#
#                               ^^^ reference [..] Class#new().
#                                   ^^^^ reference [..] Customer#name().
#                                        ⌃ enclosing_range_end [..] CustomerSpec#`<describe 'helpers'>`#named().
 
#    ⌄ enclosing_range_start [..] CustomerSpec#`<describe 'helpers'>`#subject().
     subject do
#    ^^^^^^^ definition [..] CustomerSpec#`<describe 'helpers'>`#subject().
       customer = Customer.new
#      ^^^^^^^^ definition local 1$1550327077
#                 ^^^^^^^^ reference [..] Customer#
#                          ^^^ reference [..] Class#new().
       customers = T.let([customer], T::Array[Customer])
#      ^^^^^^^^^ definition local 5$1550327077
#                         ^^^^^^^^ reference local 1$1550327077
#                                    ^ reference [..] T#
#                                       ^^^^^ reference [..] T#Array#
#                                            ^ reference [..] T#`<Class:Array>`#`[]`().
#                                             ^^^^^^^^ reference [..] Customer#
       customers.map do |customer|
#      ^^^^^^^^^ reference local 5$1550327077
#                ^^^ reference [..] Array#map().
#                        ^^^^^^^^ definition local 6$1550327077
         customer.name
#        ^^^^^^^^ reference local 6$1550327077
#                 ^^^^ reference [..] Customer#name().
       end
     end
#      ⌃ enclosing_range_end [..] CustomerSpec#`<describe 'helpers'>`#subject().
 
#    ⌄ enclosing_range_start [..] CustomerSpec#`<describe 'helpers'>`#empty().
     let(:empty) {}
#        ^^^^^^ definition [..] CustomerSpec#`<describe 'helpers'>`#empty().
#                 ⌃ enclosing_range_end [..] CustomerSpec#`<describe 'helpers'>`#empty().
 
#    ⌄ enclosing_range_start [..] CustomerSpec#`<describe 'helpers'>`#`<it 'uses the helpers'>`().
     it("uses the helpers") { ordinary; eager; named; subject; empty }
#       ^^^^^^^^^^^^^^^^^^ definition [..] CustomerSpec#`<describe 'helpers'>`#`<it 'uses the helpers'>`().
#                             ^^^^^^^^ reference [..] CustomerSpec#`<describe 'helpers'>`#ordinary().
#                                       ^^^^^ reference [..] CustomerSpec#`<describe 'helpers'>`#eager().
#                                              ^^^^^ reference [..] CustomerSpec#`<describe 'helpers'>`#named().
#                                                     ^^^^^^^ reference [..] CustomerSpec#`<describe 'helpers'>`#subject().
#                                                              ^^^^^ reference [..] CustomerSpec#`<describe 'helpers'>`#empty().
#                                                                    ⌃ enclosing_range_end [..] CustomerSpec#`<describe 'helpers'>`#`<it 'uses the helpers'>`().
 
#    ⌄ enclosing_range_start [..] CustomerSpec#`<describe 'helpers'>`#`<describe 'nested helpers'>`#
     describe("nested helpers") do
#    ^^^^^^^^ reference [..] Minitest#`<Class:Spec>`#describe().
#             ^^^^^^^^^^^^^^^^ reference [..] CustomerSpec#`<describe 'helpers'>`#
#             ^^^^^^^^^^^^^^^^ definition [..] CustomerSpec#`<describe 'helpers'>`#`<describe 'nested helpers'>`#
#      ⌄ enclosing_range_start [..] CustomerSpec#`<describe 'helpers'>`#`<describe 'nested helpers'>`#ordinary().
       let("ordinary") { Customer.new.name }
#          ^^^^^^^^^^ definition [..] CustomerSpec#`<describe 'helpers'>`#`<describe 'nested helpers'>`#ordinary().
#                        ^^^^^^^^ reference [..] Customer#
#                                 ^^^ reference [..] Class#new().
#                                     ^^^^ reference [..] Customer#name().
#                                          ⌃ enclosing_range_end [..] CustomerSpec#`<describe 'helpers'>`#`<describe 'nested helpers'>`#ordinary().
#      ⌄ enclosing_range_start [..] CustomerSpec#`<describe 'helpers'>`#`<describe 'nested helpers'>`#`<it 'uses the nested helper'>`().
       it("uses the nested helper") { ordinary; subject }
#         ^^^^^^^^^^^^^^^^^^^^^^^^ definition [..] CustomerSpec#`<describe 'helpers'>`#`<describe 'nested helpers'>`#`<it 'uses the nested helper'>`().
#                                     ^^^^^^^^ reference [..] CustomerSpec#`<describe 'helpers'>`#`<describe 'nested helpers'>`#ordinary().
#                                               ^^^^^^^ reference [..] CustomerSpec#`<describe 'helpers'>`#subject().
#                                                       ⌃ enclosing_range_end [..] CustomerSpec#`<describe 'helpers'>`#`<describe 'nested helpers'>`#`<it 'uses the nested helper'>`().
     end
#      ⌃ enclosing_range_end [..] CustomerSpec#`<describe 'helpers'>`#`<describe 'nested helpers'>`#
   end
#    ⌃ enclosing_range_end [..] CustomerSpec#`<describe 'helpers'>`#
 
   test_each([1]) do |unused|
#  ^^^^^^^^^ reference [..] Minitest#`<Class:Spec>`#test_each().
#                     ^^^^^^ definition local 1$1969966160
#                     ^^^^^^ definition local 1$2433650648
     describe("parameterized helpers") do
#      ⌄ enclosing_range_start [..] CustomerSpec#ordinary().
       let(:ordinary) { Customer.new.name }
#          ^^^^^^^^^ definition [..] CustomerSpec#ordinary().
#                       ^^^^^^^^ reference [..] Customer#
#                                ^^^ reference [..] Class#new().
#                                    ^^^^ reference [..] Customer#name().
#                                         ⌃ enclosing_range_end [..] CustomerSpec#ordinary().
#      ⌄ enclosing_range_start [..] CustomerSpec#eager().
       let!(:eager) { Customer.new.name }
#           ^^^^^^ definition [..] CustomerSpec#eager().
#                     ^^^^^^^^ reference [..] Customer#
#                              ^^^ reference [..] Class#new().
#                                  ^^^^ reference [..] Customer#name().
#                                       ⌃ enclosing_range_end [..] CustomerSpec#eager().
#      ⌄ enclosing_range_start [..] CustomerSpec#named().
       subject("named") { Customer.new.name }
#              ^^^^^^^ definition [..] CustomerSpec#named().
#                         ^^^^^^^^ reference [..] Customer#
#                                  ^^^ reference [..] Class#new().
#                                      ^^^^ reference [..] Customer#name().
#                                           ⌃ enclosing_range_end [..] CustomerSpec#named().
#      ⌄ enclosing_range_start [..] CustomerSpec#subject().
       subject { Customer.new.name }
#      ^^^^^^^ definition [..] CustomerSpec#subject().
#                ^^^^^^^^ reference [..] Customer#
#                         ^^^ reference [..] Class#new().
#                             ^^^^ reference [..] Customer#name().
#                                  ⌃ enclosing_range_end [..] CustomerSpec#subject().
#      ⌄ enclosing_range_start [..] CustomerSpec#`<it 'uses parameterized helpers'>`().
       it("uses parameterized helpers") { ordinary; eager; named; subject }
#         ^^^^^^^^^^^^^^^^^^^^^^^^^^^^ definition [..] CustomerSpec#`<it 'uses parameterized helpers'>`().
#                                         ^^^^^^^^ reference [..] CustomerSpec#ordinary().
#                                                   ^^^^^ reference [..] CustomerSpec#eager().
#                                                          ^^^^^ reference [..] CustomerSpec#named().
#                                                                 ^^^^^^^ reference [..] CustomerSpec#subject().
#                                                                         ⌃ enclosing_range_end [..] CustomerSpec#`<it 'uses parameterized helpers'>`().
     end
   end
 end
#  ⌃ enclosing_range_end [..] CustomerSpec#
