 # typed: true
 
 # Minimal stub of Chalk implementation to support encrypted_prop
#⌄ enclosing_range_start [..] Chalk#ODM#Document#
 class Chalk::ODM::Document
#      ^^^^^ reference [..] Chalk#
#             ^^^ reference [..] Chalk#ODM#
#                  ^^^^^^^^ definition [..] Chalk#ODM#Document#
 end
#  ⌃ enclosing_range_end [..] Chalk#ODM#Document#
#⌄ enclosing_range_start [..] Opus#DB#Model#Mixins#Encryptable#EncryptedValue#
 class Opus::DB::Model::Mixins::Encryptable::EncryptedValue < Chalk::ODM::Document
#      ^^^^ reference [..] Opus#
#            ^^ reference [..] Opus#DB#
#                ^^^^^ reference [..] Opus#DB#Model#
#                       ^^^^^^ reference [..] Opus#DB#Model#Mixins#
#                               ^^^^^^^^^^^ reference [..] Opus#DB#Model#Mixins#Encryptable#
#                                            ^^^^^^^^^^^^^^ definition [..] Opus#DB#Model#Mixins#Encryptable#EncryptedValue#
#                                                             ^^^^^ reference [..] Chalk#
#                                                                    ^^^ reference [..] Chalk#ODM#
#                                                                         ^^^^^^^^ reference [..] Chalk#ODM#Document#
 end
#  ⌃ enclosing_range_end [..] Opus#DB#Model#Mixins#Encryptable#EncryptedValue#
 
#⌄ enclosing_range_start [..] EncryptedProp#
 class EncryptedProp
#      ^^^^^^^^^^^^^ definition [..] EncryptedProp#
   include T::Props
#  ^^^^^^^ reference [..] Module#include().
#          ^ reference [..] T#
#             ^^^^^ reference [..] T#Props#
#  ⌄ enclosing_range_start [..] `<Class:EncryptedProp>`#encrypted_prop().
   def self.encrypted_prop(opts={}); end
#           ^^^^^^^^^^^^^^ definition [..] `<Class:EncryptedProp>`#encrypted_prop().
#                                      ⌃ enclosing_range_end [..] `<Class:EncryptedProp>`#encrypted_prop().
#  ⌄ enclosing_range_start [..] EncryptedProp#`encrypted_foo=`().
#  ⌄ enclosing_range_start [..] EncryptedProp#`foo=`().
#  ⌄ enclosing_range_start [..] EncryptedProp#encrypted_foo().
#  ⌄ enclosing_range_start [..] EncryptedProp#foo().
   encrypted_prop :foo
#  ^^^^^^^^^^^^^^^^^^^ reference [..] String#
#  ^^^^^^^^^^^^^^^^^^^ reference [..] Opus#DB#
#  ^^^^^^^^^^^^^^^^^^^ reference [..] Opus#DB#Model#
#  ^^^^^^^^^^^^^^^^^^^ reference [..] Opus#DB#Model#Mixins#
#  ^^^^^^^^^^^^^^^^^^^ reference [..] Opus#DB#Model#Mixins#Encryptable#
#  ^^^^^^^^^^^^^^^^^^^ reference [..] Opus#DB#Model#Mixins#Encryptable#EncryptedValue#
#  ^^^^^^^^^^^^^^^^^^^ reference [..] Opus#
#                  ^^^ definition [..] EncryptedProp#`encrypted_foo=`().
#                  ^^^ definition [..] EncryptedProp#`foo=`().
#                  ^^^ definition [..] EncryptedProp#encrypted_foo().
#                  ^^^ definition [..] EncryptedProp#foo().
#                    ⌃ enclosing_range_end [..] EncryptedProp#`encrypted_foo=`().
#                    ⌃ enclosing_range_end [..] EncryptedProp#`foo=`().
#                    ⌃ enclosing_range_end [..] EncryptedProp#encrypted_foo().
#                    ⌃ enclosing_range_end [..] EncryptedProp#foo().
#  ⌄ enclosing_range_start [..] EncryptedProp#bar().
#  ⌄ enclosing_range_start [..] EncryptedProp#encrypted_bar().
   encrypted_prop :bar, migrating: true, immutable: true
#  ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ reference [..] Opus#DB#Model#Mixins#Encryptable#
#  ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ reference [..] Opus#DB#
#  ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ reference [..] Opus#DB#Model#
#  ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ reference [..] Opus#DB#Model#Mixins#
#  ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ reference [..] Opus#
#  ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ reference [..] Opus#DB#Model#Mixins#Encryptable#EncryptedValue#
#  ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ reference [..] String#
#                  ^^^ definition [..] EncryptedProp#bar().
#                  ^^^ definition [..] EncryptedProp#encrypted_bar().
#                                                      ⌃ enclosing_range_end [..] EncryptedProp#bar().
#                                                      ⌃ enclosing_range_end [..] EncryptedProp#encrypted_bar().
 end
#  ⌃ enclosing_range_end [..] EncryptedProp#
 
 
#⌄ enclosing_range_start [..] Object#f().
 def f
#    ^ definition [..] Object#f().
   EncryptedProp.new.foo = "hello"
#  ^^^^^^^^^^^^^ reference [..] EncryptedProp#
#                ^^^ reference [..] Class#new().
#                    ^^^^^ reference [..] EncryptedProp#`foo=`().
   EncryptedProp.new.foo = nil
#  ^^^^^^^^^^^^^ reference [..] EncryptedProp#
#                ^^^ reference [..] Class#new().
#                    ^^^^^ reference [..] EncryptedProp#`foo=`().
   return EncryptedProp.new.encrypted_foo
#         ^^^^^^^^^^^^^ reference [..] EncryptedProp#
#                       ^^^ reference [..] Class#new().
#                           ^^^^^^^^^^^^^ reference [..] EncryptedProp#encrypted_foo().
 end
#  ⌃ enclosing_range_end [..] Object#f().
