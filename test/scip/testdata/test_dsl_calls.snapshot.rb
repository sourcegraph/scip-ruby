 # typed: true
 # enable-experimental-rspec: true
 
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
#    ⌄ enclosing_range_start [..] Minitest#`<Class:Spec>`#context().
     def self.context(name, &block); end
#             ^^^^^^^ definition [..] Minitest#`<Class:Spec>`#context().
#                                      ⌃ enclosing_range_end [..] Minitest#`<Class:Spec>`#context().
#    ⌄ enclosing_range_start [..] Minitest#`<Class:Spec>`#specify().
     def self.specify(name, &block); end
#             ^^^^^^^ definition [..] Minitest#`<Class:Spec>`#specify().
#                                      ⌃ enclosing_range_end [..] Minitest#`<Class:Spec>`#specify().
#    ⌄ enclosing_range_start [..] Minitest#`<Class:Spec>`#it().
     def self.it(name, &block); end
#             ^^ definition [..] Minitest#`<Class:Spec>`#it().
#                                 ⌃ enclosing_range_end [..] Minitest#`<Class:Spec>`#it().
#    ⌄ enclosing_range_start [..] Minitest#`<Class:Spec>`#let().
     def self.let(name, &block); end
#             ^^^ definition [..] Minitest#`<Class:Spec>`#let().
#                                  ⌃ enclosing_range_end [..] Minitest#`<Class:Spec>`#let().
   end
#    ⌃ enclosing_range_end [..] Minitest#Spec#
 end
#  ⌃ enclosing_range_end [..] Minitest#
 
#⌄ enclosing_range_start [..] RSpec#
 module RSpec
#       ^^^^^ definition [..] RSpec#
#  ⌄ enclosing_range_start [..] RSpec#Core#
   module Core
#         ^^^^ definition [..] RSpec#Core#
#    ⌄ enclosing_range_start [..] RSpec#Core#ExampleGroup#
     class ExampleGroup
#          ^^^^^^^^^^^^ definition [..] RSpec#Core#ExampleGroup#
#      ⌄ enclosing_range_start [..] RSpec#Core#`<Class:ExampleGroup>`#shared_context().
       def self.shared_context(name, &block); end
#               ^^^^^^^^^^^^^^ definition [..] RSpec#Core#`<Class:ExampleGroup>`#shared_context().
#                                               ⌃ enclosing_range_end [..] RSpec#Core#`<Class:ExampleGroup>`#shared_context().
#      ⌄ enclosing_range_start [..] RSpec#Core#`<Class:ExampleGroup>`#include_context().
       def self.include_context(name, *args); end
#               ^^^^^^^^^^^^^^^ definition [..] RSpec#Core#`<Class:ExampleGroup>`#include_context().
#                                               ⌃ enclosing_range_end [..] RSpec#Core#`<Class:ExampleGroup>`#include_context().
#      ⌄ enclosing_range_start [..] RSpec#Core#`<Class:ExampleGroup>`#describe().
       def self.describe(name, &block); end
#               ^^^^^^^^ definition [..] RSpec#Core#`<Class:ExampleGroup>`#describe().
#                                         ⌃ enclosing_range_end [..] RSpec#Core#`<Class:ExampleGroup>`#describe().
#      ⌄ enclosing_range_start [..] RSpec#Core#`<Class:ExampleGroup>`#let().
       def self.let(name, &block); end
#               ^^^ definition [..] RSpec#Core#`<Class:ExampleGroup>`#let().
#                                    ⌃ enclosing_range_end [..] RSpec#Core#`<Class:ExampleGroup>`#let().
#      ⌄ enclosing_range_start [..] RSpec#Core#`<Class:ExampleGroup>`#it().
       def self.it(name, &block); end
#               ^^ definition [..] RSpec#Core#`<Class:ExampleGroup>`#it().
#                                   ⌃ enclosing_range_end [..] RSpec#Core#`<Class:ExampleGroup>`#it().
     end
#      ⌃ enclosing_range_end [..] RSpec#Core#ExampleGroup#
   end
#    ⌃ enclosing_range_end [..] RSpec#Core#
#  ⌄ enclosing_range_start [..] `<Class:RSpec>`#describe().
   def self.describe(name, &block); end
#           ^^^^^^^^ definition [..] `<Class:RSpec>`#describe().
#                                     ⌃ enclosing_range_end [..] `<Class:RSpec>`#describe().
 end
#  ⌃ enclosing_range_end [..] RSpec#
 
#⌄ enclosing_range_start [..] `<describe 'shared helper navigation'>`#
 RSpec.describe 'shared helper navigation' do
#^^^^^ reference [..] RSpec#
#^^^^^ reference [..] RSpec#
#^^^^^ reference [..] RSpec#Core#
#^^^^^ reference [..] RSpec#Core#ExampleGroup#
#      ^^^^^^^^ reference [..] `<Class:RSpec>`#describe().
#               ^^^^^^^^^^^^^^^^^^^^^^^^^^ definition [..] `<describe 'shared helper navigation'>`#
#  ⌄ enclosing_range_start [..] `<describe 'shared helper navigation'>`#`<shared_examples 'unparameterized'>`#
   shared_context 'unparameterized' do
#  ^^^^^^^^^^^^^^ reference [..] RSpec#Core#`<Class:ExampleGroup>`#shared_context().
#                 ^^^^^^^^^^^^^^^^^ definition [..] `<describe 'shared helper navigation'>`#`<shared_examples 'unparameterized'>`#
#    ⌄ enclosing_range_start [..] `<describe 'shared helper navigation'>`#`<shared_examples 'unparameterized'>`#ordinary().
     let(:ordinary) { 'ordinary' }
#        ^^^^^^^^^ definition [..] `<describe 'shared helper navigation'>`#`<shared_examples 'unparameterized'>`#ordinary().
#                                ⌃ enclosing_range_end [..] `<describe 'shared helper navigation'>`#`<shared_examples 'unparameterized'>`#ordinary().
   end
#    ⌃ enclosing_range_end [..] `<describe 'shared helper navigation'>`#`<shared_examples 'unparameterized'>`#
#  ⌄ enclosing_range_start [..] `<describe 'shared helper navigation'>`#`<shared_examples 'parameterized'>`#
   shared_context 'parameterized' do |name|
#  ^^^^^^^^^^^^^^ reference [..] RSpec#Core#`<Class:ExampleGroup>`#shared_context().
#                 ^^^^^^^^^^^^^^^ definition [..] `<describe 'shared helper navigation'>`#`<shared_examples 'parameterized'>`#
#                                     ^^^^ definition local 2$3166084400
#                                     ^^^^ definition local 2$821412825
#                                     ^^^^ reference [..] T#
#                                     ^^^^ reference [..] `<Class:T>`#unsafe().
#    ⌄ enclosing_range_start [..] `<describe 'shared helper navigation'>`#`<shared_examples 'parameterized'>`#from_parameter().
     let(:from_parameter) { name }
#        ^^^^^^^^^^^^^^^ definition [..] `<describe 'shared helper navigation'>`#`<shared_examples 'parameterized'>`#from_parameter().
#                           ^^^^ reference local 2$3166084400
#                                ⌃ enclosing_range_end [..] `<describe 'shared helper navigation'>`#`<shared_examples 'parameterized'>`#from_parameter().
#    ⌄ enclosing_range_start [..] `<describe 'shared helper navigation'>`#`<shared_examples 'parameterized'>`#`<it 'reads the shared parameter'>`().
     it('reads the shared parameter') { name; from_parameter }
#       ^^^^^^^^^^^^^^^^^^^^^^^^^^^^ definition [..] `<describe 'shared helper navigation'>`#`<shared_examples 'parameterized'>`#`<it 'reads the shared parameter'>`().
#                                             ^^^^^^^^^^^^^^ reference [..] `<describe 'shared helper navigation'>`#`<shared_examples 'parameterized'>`#from_parameter().
#                                                            ⌃ enclosing_range_end [..] `<describe 'shared helper navigation'>`#`<shared_examples 'parameterized'>`#`<it 'reads the shared parameter'>`().
   end
#    ⌃ enclosing_range_end [..] `<describe 'shared helper navigation'>`#`<shared_examples 'parameterized'>`#
#  ⌄ enclosing_range_start [..] `<describe 'shared helper navigation'>`#`<describe 'consumer'>`#
   describe 'consumer' do
#  ^^^^^^^^ reference [..] RSpec#Core#`<Class:ExampleGroup>`#describe().
#           ^^^^^^^^^^ reference [..] `<describe 'shared helper navigation'>`#
#           ^^^^^^^^^^ definition [..] `<describe 'shared helper navigation'>`#`<describe 'consumer'>`#
     include_context 'unparameterized'
#    ^^^^^^^^^^^^^^^ reference [..] RSpec#Core#`<Class:ExampleGroup>`#include_context().
#    ^^^^^^^^^^^^^^^ reference [..] Module#include().
#                    ^^^^^^^^^^^^^^^^^ reference [..] `<describe 'shared helper navigation'>`#`<shared_examples 'unparameterized'>`#
#                    ^^^^^^^^^^^^^^^^^ reference [..] `<describe 'shared helper navigation'>`#`<shared_examples 'unparameterized'>`#
     include_context 'parameterized', 'hello'
#    ^^^^^^^^^^^^^^^ reference [..] RSpec#Core#`<Class:ExampleGroup>`#include_context().
#    ^^^^^^^^^^^^^^^ reference [..] Module#include().
#                    ^^^^^^^^^^^^^^^ reference [..] `<describe 'shared helper navigation'>`#`<shared_examples 'parameterized'>`#
#                    ^^^^^^^^^^^^^^^ reference [..] `<describe 'shared helper navigation'>`#`<shared_examples 'parameterized'>`#
#    ⌄ enclosing_range_start [..] `<describe 'shared helper navigation'>`#`<describe 'consumer'>`#`<it 'calls both helpers'>`().
     it('calls both helpers') { ordinary; from_parameter }
#    ^^ reference [..] RSpec#Core#`<Class:ExampleGroup>`#it().
#       ^^^^^^^^^^^^^^^^^^^^ definition [..] `<describe 'shared helper navigation'>`#`<describe 'consumer'>`#`<it 'calls both helpers'>`().
#                               ^^^^^^^^ reference [..] `<describe 'shared helper navigation'>`#`<shared_examples 'unparameterized'>`#ordinary().
#                                         ^^^^^^^^^^^^^^ reference [..] `<describe 'shared helper navigation'>`#`<shared_examples 'parameterized'>`#from_parameter().
#                                                        ⌃ enclosing_range_end [..] `<describe 'shared helper navigation'>`#`<describe 'consumer'>`#`<it 'calls both helpers'>`().
   end
#    ⌃ enclosing_range_end [..] `<describe 'shared helper navigation'>`#`<describe 'consumer'>`#
 end
#  ⌃ enclosing_range_end [..] `<describe 'shared helper navigation'>`#
 
#⌄ enclosing_range_start [..] DSLNavigation#
 class DSLNavigation < Minitest::Spec
#      ^^^^^^^^^^^^^ definition [..] DSLNavigation#
#                      ^^^^^^^^ reference [..] Minitest#
#                                ^^^^ reference [..] Minitest#Spec#
#  ⌄ enclosing_range_start [..] DSLNavigation#`<describe 'group'>`#
   describe 'group' do
#  ^^^^^^^^ reference [..] Minitest#`<Class:Spec>`#describe().
#           ^^^^^^^ reference [..] DSLNavigation#
#           ^^^^^^^ definition [..] DSLNavigation#`<describe 'group'>`#
#    ⌄ enclosing_range_start [..] DSLNavigation#`<describe 'group'>`#`<context 'nested group'>`#
     context 'nested group' do
#    ^^^^^^^ reference [..] Minitest#`<Class:Spec>`#context().
#            ^^^^^^^^^^^^^^ reference [..] DSLNavigation#`<describe 'group'>`#
#            ^^^^^^^^^^^^^^ definition [..] DSLNavigation#`<describe 'group'>`#`<context 'nested group'>`#
#      ⌄ enclosing_range_start [..] DSLNavigation#`<describe 'group'>`#`<context 'nested group'>`#name().
       let(:name) { 'hello'.upcase }
#      ^^^ reference [..] Minitest#`<Class:Spec>`#let().
#          ^^^^^ definition [..] DSLNavigation#`<describe 'group'>`#`<context 'nested group'>`#name().
#                           ^^^^^^ reference [..] String#upcase().
#                                  ⌃ enclosing_range_end [..] DSLNavigation#`<describe 'group'>`#`<context 'nested group'>`#name().
#      ⌄ enclosing_range_start [..] DSLNavigation#`<describe 'group'>`#`<context 'nested group'>`#`<specify 'retains the call and body'>`().
       specify 'retains the call and body' do
#      ^^^^^^^ reference [..] Minitest#`<Class:Spec>`#specify().
#              ^^^^^^^^^^^^^^^^^^^^^^^^^^^ definition [..] DSLNavigation#`<describe 'group'>`#`<context 'nested group'>`#`<specify 'retains the call and body'>`().
         value = 'world'
#        ^^^^^ definition local 1$2541142345
         value.downcase
#        ^^^^^ reference local 1$2541142345
#              ^^^^^^^^ reference [..] String#downcase().
       end
#        ⌃ enclosing_range_end [..] DSLNavigation#`<describe 'group'>`#`<context 'nested group'>`#`<specify 'retains the call and body'>`().
#      ⌄ enclosing_range_start [..] DSLNavigation#`<describe 'group'>`#`<context 'nested group'>`#`<it 'uses the helper'>`().
       it('uses the helper') { name }
#      ^^ reference [..] Minitest#`<Class:Spec>`#it().
#         ^^^^^^^^^^^^^^^^^ definition [..] DSLNavigation#`<describe 'group'>`#`<context 'nested group'>`#`<it 'uses the helper'>`().
#                              ^^^^ reference [..] DSLNavigation#`<describe 'group'>`#`<context 'nested group'>`#name().
#                                   ⌃ enclosing_range_end [..] DSLNavigation#`<describe 'group'>`#`<context 'nested group'>`#`<it 'uses the helper'>`().
     end
#      ⌃ enclosing_range_end [..] DSLNavigation#`<describe 'group'>`#`<context 'nested group'>`#
   end
#    ⌃ enclosing_range_end [..] DSLNavigation#`<describe 'group'>`#
 end
#  ⌃ enclosing_range_end [..] DSLNavigation#
