 # typed: false
 
 # Top-level callbacks record fields on an ancestor without a source definition.
 RSpec.configure do |config|
#                    ^^^^^^ definition local 2$217974539
   config.before { @user = 'alice' }
#  ^^^^^^ reference local 2$217974539
#                  ^^^^^ definition [..] `<Class:<root>>`#`@user`.
#                  ^^^^^^^^^^^^^^^ reference [..] `<Class:<root>>`#`@user`.
 end
 
#⌄ enclosing_range_start [..] `<describe 'nested groups'>`#
 describe 'nested groups' do
#         ^^^^^^^^^^^^^^^ definition [..] `<describe 'nested groups'>`#
#  ⌄ enclosing_range_start [..] `<describe 'nested groups'>`#`<before>`().
   before { @message = 'hello' }
#  ^^^^^^ definition [..] `<describe 'nested groups'>`#`<before>`().
#           ^^^^^^^^ definition [..] `<describe 'nested groups'>`#`@message`.
#           ^^^^^^^^^^^^^^^^^^ reference [..] `<describe 'nested groups'>`#`@message`.
#                              ⌃ enclosing_range_end [..] `<describe 'nested groups'>`#`<before>`().
#  ⌄ enclosing_range_start [..] `<describe 'nested groups'>`#`<describe 'reads setup fields'>`#
   describe 'reads setup fields' do
#           ^^^^^^^^^^^^^^^^^^^^ reference [..] `<describe 'nested groups'>`#
#           ^^^^^^^^^^^^^^^^^^^^ definition [..] `<describe 'nested groups'>`#`<describe 'reads setup fields'>`#
#    ⌄ enclosing_range_start [..] `<describe 'nested groups'>`#`<describe 'reads setup fields'>`#`<it 'keeps the body indexed'>`().
     it('keeps the body indexed') do
#       ^^^^^^^^^^^^^^^^^^^^^^^^ definition [..] `<describe 'nested groups'>`#`<describe 'reads setup fields'>`#`<it 'keeps the body indexed'>`().
       @user.to_s.upcase
#      ^^^^^ reference [..] `<describe 'nested groups'>`#`<describe 'reads setup fields'>`#`@user`.
#            ^^^^ reference [..] Kernel#to_s().
       @message.to_s.downcase
#      ^^^^^^^^ reference [..] `<describe 'nested groups'>`#`<describe 'reads setup fields'>`#`@message`.
#      relation definition=[..] `<describe 'nested groups'>`#`@message`.
#               ^^^^ reference [..] Kernel#to_s().
       'after the missing relationship'.length
#                                       ^^^^^^ reference [..] String#length().
     end
#      ⌃ enclosing_range_end [..] `<describe 'nested groups'>`#`<describe 'reads setup fields'>`#`<it 'keeps the body indexed'>`().
   end
#    ⌃ enclosing_range_end [..] `<describe 'nested groups'>`#`<describe 'reads setup fields'>`#
 end
#  ⌃ enclosing_range_end [..] `<describe 'nested groups'>`#
 
 # Source-backed parent and mixin relationships must still be emitted.
#⌄ enclosing_range_start [..] FieldMixin#
 module FieldMixin
#       ^^^^^^^^^^ definition [..] FieldMixin#
#  ⌄ enclosing_range_start [..] FieldMixin#mixed_value().
   def mixed_value
#      ^^^^^^^^^^^ definition [..] FieldMixin#mixed_value().
     @shared = 'mixin'
#    ^^^^^^^ definition [..] FieldMixin#`@shared`.
#    ^^^^^^^^^^^^^^^^^ reference [..] FieldMixin#`@shared`.
   end
#    ⌃ enclosing_range_end [..] FieldMixin#mixed_value().
 end
#  ⌃ enclosing_range_end [..] FieldMixin#
 
#⌄ enclosing_range_start [..] FieldParent#
 class FieldParent
#      ^^^^^^^^^^^ definition [..] FieldParent#
#  ⌄ enclosing_range_start [..] FieldParent#initialize().
   def initialize
#      ^^^^^^^^^^ definition [..] FieldParent#initialize().
     @shared = 'parent'
#    ^^^^^^^ definition [..] FieldParent#`@shared`.
#    ^^^^^^^^^^^^^^^^^^ reference [..] FieldParent#`@shared`.
   end
#    ⌃ enclosing_range_end [..] FieldParent#initialize().
 end
#  ⌃ enclosing_range_end [..] FieldParent#
 
#⌄ enclosing_range_start [..] FieldChild#
 class FieldChild < FieldParent
#      ^^^^^^^^^^ definition [..] FieldChild#
#                   ^^^^^^^^^^^ reference [..] FieldParent#
   include FieldMixin
#  ^^^^^^^ reference [..] Module#include().
#          ^^^^^^^^^^ reference [..] FieldMixin#
#          ^^^^^^^^^^ reference [..] FieldMixin#
#  ⌄ enclosing_range_start [..] FieldChild#read().
   def read
#      ^^^^ definition [..] FieldChild#read().
     @shared.to_s.upcase
#    ^^^^^^^ reference [..] FieldChild#`@shared`.
#    relation reference=[..] FieldMixin#`@shared`. definition=[..] FieldParent#`@shared`.
#            ^^^^ reference [..] Kernel#to_s().
   end
#    ⌃ enclosing_range_end [..] FieldChild#read().
 end
#  ⌃ enclosing_range_end [..] FieldChild#
 
 FieldChild.new.read
#^^^^^^^^^^ reference [..] FieldChild#
#           ^^^ reference [..] FieldParent#initialize().
#               ^^^^ reference [..] FieldChild#read().
