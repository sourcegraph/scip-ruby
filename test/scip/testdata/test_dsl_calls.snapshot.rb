 # typed: true
 
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
