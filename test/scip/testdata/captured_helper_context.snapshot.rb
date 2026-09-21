 # typed: true
 # check-errors: true
 
#⌄ enclosing_range_start [..] CapturedHelperContext#
 class CapturedHelperContext
#      ^^^^^^^^^^^^^^^^^^^^^ definition [..] CapturedHelperContext#
#  ⌄ enclosing_range_start [..] `<Class:CapturedHelperContext>`#describe().
   def self.describe(name, &block); end
#           ^^^^^^^^ definition [..] `<Class:CapturedHelperContext>`#describe().
#                                     ⌃ enclosing_range_end [..] `<Class:CapturedHelperContext>`#describe().
#  ⌄ enclosing_range_start [..] `<Class:CapturedHelperContext>`#context().
   def self.context(name, &block); end
#           ^^^^^^^ definition [..] `<Class:CapturedHelperContext>`#context().
#                                    ⌃ enclosing_range_end [..] `<Class:CapturedHelperContext>`#context().
#  ⌄ enclosing_range_start [..] `<Class:CapturedHelperContext>`#it().
   def self.it(name, &block); end
#           ^^ definition [..] `<Class:CapturedHelperContext>`#it().
#                               ⌃ enclosing_range_end [..] `<Class:CapturedHelperContext>`#it().
#  ⌄ enclosing_range_start [..] `<Class:CapturedHelperContext>`#let().
   def self.let(name, &block); end
#           ^^^ definition [..] `<Class:CapturedHelperContext>`#let().
#                                ⌃ enclosing_range_end [..] `<Class:CapturedHelperContext>`#let().
 
#  ⌄ enclosing_range_start [..] CapturedHelperContext#helper().
   def helper
#      ^^^^^^ definition [..] CapturedHelperContext#helper().
     'helper'
   end
#    ⌃ enclosing_range_end [..] CapturedHelperContext#helper().
 
#  ⌄ enclosing_range_start [..] CapturedHelperContext#`<describe 'keeps instance self alongside captured locals'>`#
   describe 'keeps instance self alongside captured locals' do
#  ^^^^^^^^ reference [..] `<Class:CapturedHelperContext>`#describe().
#           ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ reference [..] CapturedHelperContext#
#           ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ definition [..] CapturedHelperContext#`<describe 'keeps instance self alongside captured locals'>`#
     value = 'captured'
#    ^^^^^ definition local 1$1596751174
#    ⌄ enclosing_range_start [..] CapturedHelperContext#`<describe 'keeps instance self alongside captured locals'>`#captured_helper().
     let(:captured_helper) { value.downcase }
#    ^^^ reference [..] `<Class:CapturedHelperContext>`#let().
#        ^^^^^^^^^^^^^^^^ definition [..] CapturedHelperContext#`<describe 'keeps instance self alongside captured locals'>`#captured_helper().
#                            ^^^^^ reference local 1$1596751174
#                                  ^^^^^^^^ reference [..] String#downcase().
#                                           ⌃ enclosing_range_end [..] CapturedHelperContext#`<describe 'keeps instance self alongside captured locals'>`#captured_helper().
     it 'calls the instance helper' do
#    ^^ reference [..] `<Class:CapturedHelperContext>`#it().
       value.upcase
#      ^^^^^ reference local 1$1596751174
#            ^^^^^^ reference [..] String#upcase().
       helper
#      ^^^^^^ reference [..] CapturedHelperContext#helper().
       self.helper
#           ^^^^^^ reference [..] CapturedHelperContext#helper().
       captured_helper
#      ^^^^^^^^^^^^^^^ reference [..] CapturedHelperContext#`<describe 'keeps instance self alongside captured locals'>`#captured_helper().
     end
 
#    ⌄ enclosing_range_start [..] CapturedHelperContext#`<describe 'keeps instance self alongside captured locals'>`#`<context 'captures through a nested group'>`#
     context 'captures through a nested group' do
#    ^^^^^^^ reference [..] `<Class:CapturedHelperContext>`#context().
#            ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ reference [..] CapturedHelperContext#`<describe 'keeps instance self alongside captured locals'>`#
#            ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ definition [..] CapturedHelperContext#`<describe 'keeps instance self alongside captured locals'>`#`<context 'captures through a nested group'>`#
       extend T::Sig
#      ^^^^^^ reference [..] Kernel#extend().
       sig { returns(String) }
#                    ^^^^^^ reference [..] String#
#      ⌄ enclosing_range_start [..] CapturedHelperContext#`<describe 'keeps instance self alongside captured locals'>`#`<context 'captures through a nested group'>`#local_helper().
       def local_helper; 'local'; end
#          ^^^^^^^^^^^^ definition [..] CapturedHelperContext#`<describe 'keeps instance self alongside captured locals'>`#`<context 'captures through a nested group'>`#local_helper().
#                                   ⌃ enclosing_range_end [..] CapturedHelperContext#`<describe 'keeps instance self alongside captured locals'>`#`<context 'captures through a nested group'>`#local_helper().
 
#      ⌄ enclosing_range_start [..] CapturedHelperContext#`<describe 'keeps instance self alongside captured locals'>`#`<context 'captures through a nested group'>`#nested_helper().
       let(:nested_helper) { value.downcase }
#      ^^^ reference [..] `<Class:CapturedHelperContext>`#let().
#          ^^^^^^^^^^^^^^ definition [..] CapturedHelperContext#`<describe 'keeps instance self alongside captured locals'>`#`<context 'captures through a nested group'>`#nested_helper().
#                            ^^^^^ reference local 1$1596751174
#                                  ^^^^^^^^ reference [..] String#downcase().
#                                           ⌃ enclosing_range_end [..] CapturedHelperContext#`<describe 'keeps instance self alongside captured locals'>`#`<context 'captures through a nested group'>`#nested_helper().
       it 'keeps the closure and inherited helpers' do
#      ^^ reference [..] `<Class:CapturedHelperContext>`#it().
         value.upcase
#        ^^^^^ reference local 1$1596751174
#              ^^^^^^ reference [..] String#upcase().
         helper
#        ^^^^^^ reference [..] CapturedHelperContext#helper().
         self.helper
#             ^^^^^^ reference [..] CapturedHelperContext#helper().
         captured_helper
#        ^^^^^^^^^^^^^^^ reference [..] CapturedHelperContext#`<describe 'keeps instance self alongside captured locals'>`#captured_helper().
         nested_helper
#        ^^^^^^^^^^^^^ reference [..] CapturedHelperContext#`<describe 'keeps instance self alongside captured locals'>`#`<context 'captures through a nested group'>`#nested_helper().
         local_helper.upcase
#        ^^^^^^^^^^^^ reference [..] CapturedHelperContext#`<describe 'keeps instance self alongside captured locals'>`#`<context 'captures through a nested group'>`#local_helper().
#                     ^^^^^^ reference [..] String#upcase().
       end
 
#      ⌄ enclosing_range_start [..] CapturedHelperContext#`<describe 'keeps instance self alongside captured locals'>`#`<context 'captures through a nested group'>`#`<describe 'isolates an overriding helper'>`#
       describe 'isolates an overriding helper' do
#      ^^^^^^^^ reference [..] `<Class:CapturedHelperContext>`#describe().
#               ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ reference [..] CapturedHelperContext#`<describe 'keeps instance self alongside captured locals'>`#`<context 'captures through a nested group'>`#
#               ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ definition [..] CapturedHelperContext#`<describe 'keeps instance self alongside captured locals'>`#`<context 'captures through a nested group'>`#`<describe 'isolates an overriding helper'>`#
#        ⌄ enclosing_range_start [..] CapturedHelperContext#`<describe 'keeps instance self alongside captured locals'>`#`<context 'captures through a nested group'>`#`<describe 'isolates an overriding helper'>`#captured_helper().
         let(:captured_helper) { value.reverse }
#        ^^^ reference [..] `<Class:CapturedHelperContext>`#let().
#            ^^^^^^^^^^^^^^^^ definition [..] CapturedHelperContext#`<describe 'keeps instance self alongside captured locals'>`#`<context 'captures through a nested group'>`#`<describe 'isolates an overriding helper'>`#captured_helper().
#                                ^^^^^ reference local 1$1596751174
#                                      ^^^^^^^ reference [..] String#reverse().
#                                              ⌃ enclosing_range_end [..] CapturedHelperContext#`<describe 'keeps instance self alongside captured locals'>`#`<context 'captures through a nested group'>`#`<describe 'isolates an overriding helper'>`#captured_helper().
         it('uses the inner helper') { captured_helper; value.upcase }
#        ^^ reference [..] `<Class:CapturedHelperContext>`#it().
#                                      ^^^^^^^^^^^^^^^ reference [..] CapturedHelperContext#`<describe 'keeps instance self alongside captured locals'>`#`<context 'captures through a nested group'>`#`<describe 'isolates an overriding helper'>`#captured_helper().
#                                                       ^^^^^ reference local 1$1596751174
#                                                             ^^^^^^ reference [..] String#upcase().
       end
#        ⌃ enclosing_range_end [..] CapturedHelperContext#`<describe 'keeps instance self alongside captured locals'>`#`<context 'captures through a nested group'>`#`<describe 'isolates an overriding helper'>`#
 
       it('still uses the outer helper') { captured_helper }
#      ^^ reference [..] `<Class:CapturedHelperContext>`#it().
#                                          ^^^^^^^^^^^^^^^ reference [..] CapturedHelperContext#`<describe 'keeps instance self alongside captured locals'>`#captured_helper().
     end
#      ⌃ enclosing_range_end [..] CapturedHelperContext#`<describe 'keeps instance self alongside captured locals'>`#`<context 'captures through a nested group'>`#
   end
#    ⌃ enclosing_range_end [..] CapturedHelperContext#`<describe 'keeps instance self alongside captured locals'>`#
 end
#  ⌃ enclosing_range_end [..] CapturedHelperContext#
