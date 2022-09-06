 # typed: true
 
 # Minimal stub of Chalk implementation to support encrypted_prop
 class Chalk::ODM::Document
#      ^^^^^ reference [..] Chalk#
#             ^^^ reference [..] Chalk#ODM#
#                  ^^^^^^^^ definition [..] Chalk#ODM#Document#
 end
 class Opus::DB::Model::Mixins::Encryptable::EncryptedValue < Chalk::ODM::Document
#      ^^^^ reference [..] Opus#
#            ^^ reference [..] Opus#DB#
#                ^^^^^ reference [..] Opus#DB#Model#
#                       ^^^^^^ reference [..] Opus#DB#Model#Mixins#
#                               ^^^^^^^^^^^ reference [..] Opus#DB#Model#Mixins#Encryptable#
#                                            ^^^^^^^^^^^^^^ definition [..] Opus#DB#Model#Mixins#Encryptable#EncryptedValue#
#                                                             ^^^^^ reference [..] Chalk#
#                                                                    ^^^ reference [..] Chalk#ODM#
#                                                                         ^^^^^^^^ definition [..] Chalk#ODM#Document#
 end
 
 class EncryptedProp
#      ^^^^^^^^^^^^^ definition [..] EncryptedProp#
   include T::Props
   def self.encrypted_prop(opts={}); end
#           ^^^^^^^^^^^^^^ definition [..] `<Class:EncryptedProp>`#encrypted_prop().
   encrypted_prop :foo
#  ^^^^^^^^^^^^^^^^^^^ reference [..] String#
#                  ^^^ definition [..] EncryptedProp#`encrypted_foo=`().
#                  ^^^ definition [..] EncryptedProp#`foo=`().
#                  ^^^ definition [..] EncryptedProp#encrypted_foo().
#                  ^^^ definition [..] EncryptedProp#foo().
   encrypted_prop :bar, migrating: true, immutable: true
#  ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ reference [..] String#
#                  ^^^ definition [..] EncryptedProp#bar().
#                  ^^^ definition [..] EncryptedProp#encrypted_bar().
 end
 
 
 def f
#    ^ definition [..] Object#f().
   EncryptedProp.new.foo = "hello"
#  ^^^^^^^^^^^^^ reference [..] EncryptedProp#
#                    ^^^^^ reference [..] EncryptedProp#`foo=`().
   EncryptedProp.new.foo = nil
#  ^^^^^^^^^^^^^ reference [..] EncryptedProp#
#                    ^^^^^ reference [..] EncryptedProp#`foo=`().
   return EncryptedProp.new.encrypted_foo
#         ^^^^^^^^^^^^^ reference [..] EncryptedProp#
#                           ^^^^^^^^^^^^^ reference [..] EncryptedProp#encrypted_foo().
 end
