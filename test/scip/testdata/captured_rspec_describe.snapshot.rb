 # typed: true
 # check-errors: true
 # enable-experimental-rspec: true
 
#⌄ enclosing_range_start [..] RSpec#
 module RSpec
#       ^^^^^ definition [..] RSpec#
#  ⌄ enclosing_range_start [..] RSpec#Core#
   module Core
#         ^^^^ definition [..] RSpec#Core#
#    ⌄ enclosing_range_start [..] RSpec#Core#ExampleGroup#
     class ExampleGroup
#          ^^^^^^^^^^^^ definition [..] RSpec#Core#ExampleGroup#
#      ⌄ enclosing_range_start [..] RSpec#Core#`<Class:ExampleGroup>`#it().
       def self.it(name, &block); end
#               ^^ definition [..] RSpec#Core#`<Class:ExampleGroup>`#it().
#                                   ⌃ enclosing_range_end [..] RSpec#Core#`<Class:ExampleGroup>`#it().
#      ⌄ enclosing_range_start [..] RSpec#Core#`<Class:ExampleGroup>`#let().
       def self.let(name, &block); end
#               ^^^ definition [..] RSpec#Core#`<Class:ExampleGroup>`#let().
#                                    ⌃ enclosing_range_end [..] RSpec#Core#`<Class:ExampleGroup>`#let().
#      ⌄ enclosing_range_start [..] RSpec#Core#ExampleGroup#helper().
       def helper; 'helper'; end
#          ^^^^^^ definition [..] RSpec#Core#ExampleGroup#helper().
#                              ⌃ enclosing_range_end [..] RSpec#Core#ExampleGroup#helper().
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
 
 value = 'captured'
#^^^^^ definition local 1$217974539
#⌄ enclosing_range_start [..] `<describe 'captures file scope'>`#
 RSpec.describe 'captures file scope' do
#^^^^^ reference [..] RSpec#
#^^^^^ reference [..] RSpec#
#^^^^^ reference [..] RSpec#Core#
#^^^^^ reference [..] RSpec#Core#ExampleGroup#
#      ^^^^^^^^ reference [..] `<Class:RSpec>`#describe().
#               ^^^^^^^^^^^^^^^^^^^^^ definition [..] `<describe 'captures file scope'>`#
#  ⌄ enclosing_range_start [..] `<describe 'captures file scope'>`#captured_helper().
   let(:captured_helper) { value.downcase }
#  ^^^ reference [..] RSpec#Core#`<Class:ExampleGroup>`#let().
#      ^^^^^^^^^^^^^^^^ definition [..] `<describe 'captures file scope'>`#captured_helper().
#                          ^^^^^ reference local 1$217974539
#                                ^^^^^^^^ reference [..] String#downcase().
#                                         ⌃ enclosing_range_end [..] `<describe 'captures file scope'>`#captured_helper().
   it 'keeps both instance self and lexical locals' do
#  ^^ reference [..] RSpec#Core#`<Class:ExampleGroup>`#it().
     value.upcase
#    ^^^^^ reference local 1$217974539
#          ^^^^^^ reference [..] String#upcase().
     helper
#    ^^^^^^ reference [..] RSpec#Core#ExampleGroup#helper().
     captured_helper
#    ^^^^^^^^^^^^^^^ reference [..] `<describe 'captures file scope'>`#captured_helper().
   end
 end
#  ⌃ enclosing_range_end [..] `<describe 'captures file scope'>`#
