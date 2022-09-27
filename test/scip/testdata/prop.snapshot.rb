 # typed: true
 
 class SomeODM
#      ^^^^^^^ definition [..] SomeODM#
     extend T::Sig
#    ^^^^^^ reference [..] Kernel#extend().
     include T::Props
#    ^^^^^^^ reference [..] Module#include().
 
     prop :foo, String
#          ^^^ definition [..] SomeODM#`foo=`().
#          ^^^ definition [..] SomeODM#foo().
#               ^^^^^^ reference [..] String#
 
     sig {returns(T.nilable(String))}
#                           ^^^^^^ reference [..] String#
     def foo2; T.cast(T.unsafe(nil), T.nilable(String)); end
#        ^^^^ definition [..] SomeODM#foo2().
#                     ^ reference [..] T#
#                       ^^^^^^ reference [..] `<Class:T>`#unsafe().
#                                    ^ reference [..] T#
#                                    ^^^^^^^^^^^^^^^^^ definition local 1~#1867563647
#                                      ^^^^^^^ reference [..] `<Class:T>`#nilable().
#                                              ^^^^^^ reference [..] String#
     sig {params(arg0: String).returns(String)}
#                      ^^^^^^ reference [..] String#
#                                      ^^^^^^ reference [..] String#
     def foo2=(arg0); T.cast(nil, String); end
#        ^^^^^ definition [..] SomeODM#`foo2=`().
#                                 ^^^^^^ definition local 1~#2116144614
#                                 ^^^^^^ reference [..] String#
 end
 
 class ForeignClass
#      ^^^^^^^^^^^^ definition [..] ForeignClass#
 end
 
 class AdvancedODM
#      ^^^^^^^^^^^ definition [..] AdvancedODM#
     include T::Props
#    ^^^^^^^ reference [..] Module#include().
     prop :default, String, default: ""
#          ^^^^^^^ definition [..] AdvancedODM#`default=`().
#          ^^^^^^^ definition [..] AdvancedODM#default().
#                   ^^^^^^ reference [..] String#
     prop :t_nilable, T.nilable(String)
#          ^^^^^^^^^ definition [..] AdvancedODM#`t_nilable=`().
#          ^^^^^^^^^ definition [..] AdvancedODM#t_nilable().
#                               ^^^^^^ reference [..] String#
 
     prop :array, Array
#          ^^^^^ definition [..] AdvancedODM#`array=`().
#          ^^^^^ definition [..] AdvancedODM#array().
#                 ^^^^^ reference [..] Array#
     prop :t_array, T::Array[String]
#          ^^^^^^^ definition [..] AdvancedODM#`t_array=`().
#          ^^^^^^^ definition [..] AdvancedODM#t_array().
#                            ^^^^^^ reference [..] String#
     prop :hash_of, T::Hash[Symbol, String]
#          ^^^^^^^ definition [..] AdvancedODM#`hash_of=`().
#          ^^^^^^^ definition [..] AdvancedODM#hash_of().
#                           ^^^^^^ reference [..] Symbol#
#                                   ^^^^^^ reference [..] String#
 
     prop :const_explicit, String, immutable: true
#          ^^^^^^^^^^^^^^ definition [..] AdvancedODM#const_explicit().
#                          ^^^^^^ reference [..] String#
     const :const, String
#           ^^^^^ definition [..] AdvancedODM#const().
#                  ^^^^^^ reference [..] String#
 
     prop :enum_prop, String, enum: ["hello", "goodbye"]
#          ^^^^^^^^^ definition [..] AdvancedODM#`enum_prop=`().
#          ^^^^^^^^^ definition [..] AdvancedODM#enum_prop().
#                     ^^^^^^ reference [..] String#
 
     prop :foreign_lazy, String, foreign: -> {ForeignClass}
#    ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ reference [..] T#Boolean.
#          ^^^^^^^^^^^^ definition [..] AdvancedODM#`foreign_lazy=`().
#          ^^^^^^^^^^^^ definition [..] AdvancedODM#`foreign_lazy_!`().
#          ^^^^^^^^^^^^ definition [..] AdvancedODM#foreign_lazy().
#          ^^^^^^^^^^^^ definition [..] AdvancedODM#foreign_lazy_().
#                        ^^^^^^ reference [..] String#
#                                         ^^ reference [..] Kernel#
#                                         ^^ reference [..] Kernel#lambda().
#                                             ^^^^^^^^^^^^ reference [..] ForeignClass#
     prop :foreign_proc, String, foreign: proc {ForeignClass}
#    ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ reference [..] T#Boolean.
#          ^^^^^^^^^^^^ definition [..] AdvancedODM#`foreign_proc=`().
#          ^^^^^^^^^^^^ definition [..] AdvancedODM#`foreign_proc_!`().
#          ^^^^^^^^^^^^ definition [..] AdvancedODM#foreign_proc().
#          ^^^^^^^^^^^^ definition [..] AdvancedODM#foreign_proc_().
#                        ^^^^^^ reference [..] String#
#                                         ^^^^ reference [..] Kernel#proc().
#                                               ^^^^^^^^^^^^ reference [..] ForeignClass#
     prop :foreign_invalid, String, foreign: proc { :not_a_type }
#    ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ reference [..] T#Boolean.
#          ^^^^^^^^^^^^^^^ definition [..] AdvancedODM#`foreign_invalid=`().
#          ^^^^^^^^^^^^^^^ definition [..] AdvancedODM#`foreign_invalid_!`().
#          ^^^^^^^^^^^^^^^ definition [..] AdvancedODM#foreign_invalid().
#          ^^^^^^^^^^^^^^^ definition [..] AdvancedODM#foreign_invalid_().
#                           ^^^^^^ reference [..] String#
#                                            ^^^^ reference [..] Kernel#proc().
 
     prop :ifunset, String, ifunset: ''
#          ^^^^^^^ definition [..] AdvancedODM#`ifunset=`().
#          ^^^^^^^ definition [..] AdvancedODM#ifunset().
#                   ^^^^^^ reference [..] String#
     prop :ifunset_nilable, T.nilable(String), ifunset: ''
#          ^^^^^^^^^^^^^^^ definition [..] AdvancedODM#`ifunset_nilable=`().
#          ^^^^^^^^^^^^^^^ definition [..] AdvancedODM#ifunset_nilable().
#                                     ^^^^^^ reference [..] String#
 
     prop :empty_hash_rules, String, {}
#          ^^^^^^^^^^^^^^^^ definition [..] AdvancedODM#`empty_hash_rules=`().
#          ^^^^^^^^^^^^^^^^ definition [..] AdvancedODM#empty_hash_rules().
#                            ^^^^^^ reference [..] String#
     prop :hash_rules, String, { enum: ["hello", "goodbye" ] }
#          ^^^^^^^^^^ definition [..] AdvancedODM#`hash_rules=`().
#          ^^^^^^^^^^ definition [..] AdvancedODM#hash_rules().
#                      ^^^^^^ reference [..] String#
 end
 
 class PropHelpers
#      ^^^^^^^^^^^ definition [..] PropHelpers#
   include T::Props
#  ^^^^^^^ reference [..] Module#include().
   def self.token_prop(opts={}); end
#           ^^^^^^^^^^ definition [..] `<Class:PropHelpers>`#token_prop().
   def self.created_prop(opts={}); end
#           ^^^^^^^^^^^^ definition [..] `<Class:PropHelpers>`#created_prop().
   token_prop
#  ^^^^^ definition [..] PropHelpers#`token=`().
#  ^^^^^ definition [..] PropHelpers#token().
#  ^^^^^^^^^^ reference [..] String#
#  ^^^^^^^^^^ reference [..] `<Class:PropHelpers>`#token_prop().
   created_prop
#  ^^^^^^^ definition [..] PropHelpers#`created=`().
#  ^^^^^^^ definition [..] PropHelpers#created().
#  ^^^^^^^^^^^^ reference [..] Float#
#  ^^^^^^^^^^^^ reference [..] `<Class:PropHelpers>`#created_prop().
 end
 
 class PropHelpers2
#      ^^^^^^^^^^^^ definition [..] PropHelpers2#
   include T::Props
#  ^^^^^^^ reference [..] Module#include().
   def self.timestamped_token_prop(opts={}); end
#           ^^^^^^^^^^^^^^^^^^^^^^ definition [..] `<Class:PropHelpers2>`#timestamped_token_prop().
   def self.created_prop(opts={}); end
#           ^^^^^^^^^^^^ definition [..] `<Class:PropHelpers2>`#created_prop().
   timestamped_token_prop
#  ^^^^^^^^^^^^^^^^^^^^^^ reference [..] String#
#  ^^^^^^^^^^^^^^^^^^^^^^ reference [..] `<Class:PropHelpers2>`#timestamped_token_prop().
#              ^^^^^ definition [..] PropHelpers2#`token=`().
#              ^^^^^ definition [..] PropHelpers2#token().
   created_prop(immutable: true)
#  ^^^^^^^^^^^^ reference [..] `<Class:PropHelpers2>`#created_prop().
#  ^^^^^^^^^^^^^^^^^^^^^^^^ definition [..] PropHelpers2#created().
#  ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ reference [..] Float#
 end
 
 def main
#    ^^^^ definition [..] Object#main().
     SomeODM.new.foo
#    ^^^^^^^ reference [..] SomeODM#
#            ^^^ reference [..] Class#new().
#                ^^^ reference [..] SomeODM#foo().
     SomeODM.new.foo = 'b'
#    ^^^^^^^ reference [..] SomeODM#
#            ^^^ reference [..] Class#new().
#                ^^^^^ reference [..] SomeODM#`foo=`().
     SomeODM.new.foo2
#    ^^^^^^^ reference [..] SomeODM#
#            ^^^ reference [..] Class#new().
#                ^^^^ reference [..] SomeODM#foo2().
     SomeODM.new.foo2 = 'b'
#    ^^^^^^^ reference [..] SomeODM#
#            ^^^ reference [..] Class#new().
#                ^^^^^^ reference [..] SomeODM#`foo2=`().
 
     AdvancedODM.new.default
#    ^^^^^^^^^^^ reference [..] AdvancedODM#
#                ^^^ reference [..] Class#new().
#                    ^^^^^^^ reference [..] AdvancedODM#default().
     AdvancedODM.new.t_nilable
#    ^^^^^^^^^^^ reference [..] AdvancedODM#
#                ^^^ reference [..] Class#new().
#                    ^^^^^^^^^ reference [..] AdvancedODM#t_nilable().
 
     AdvancedODM.new.t_array
#    ^^^^^^^^^^^ reference [..] AdvancedODM#
#                ^^^ reference [..] Class#new().
#                    ^^^^^^^ reference [..] AdvancedODM#t_array().
     AdvancedODM.new.hash_of
#    ^^^^^^^^^^^ reference [..] AdvancedODM#
#                ^^^ reference [..] Class#new().
#                    ^^^^^^^ reference [..] AdvancedODM#hash_of().
 
     AdvancedODM.new.const_explicit
#    ^^^^^^^^^^^ reference [..] AdvancedODM#
#                ^^^ reference [..] Class#new().
#                    ^^^^^^^^^^^^^^ reference [..] AdvancedODM#const_explicit().
     AdvancedODM.new.const_explicit = 'b'
#    ^^^^^^^^^^^ reference [..] AdvancedODM#
#                ^^^ reference [..] Class#new().
     AdvancedODM.new.const
#    ^^^^^^^^^^^ reference [..] AdvancedODM#
#                ^^^ reference [..] Class#new().
#                    ^^^^^ reference [..] AdvancedODM#const().
     AdvancedODM.new.const = 'b'
#    ^^^^^^^^^^^ reference [..] AdvancedODM#
#                ^^^ reference [..] Class#new().
 
     AdvancedODM.new.enum_prop
#    ^^^^^^^^^^^ reference [..] AdvancedODM#
#                ^^^ reference [..] Class#new().
#                    ^^^^^^^^^ reference [..] AdvancedODM#enum_prop().
     AdvancedODM.new.enum_prop = "hello"
#    ^^^^^^^^^^^ reference [..] AdvancedODM#
#                ^^^ reference [..] Class#new().
#                    ^^^^^^^^^^^ reference [..] AdvancedODM#`enum_prop=`().
 
     AdvancedODM.new.foreign_
#    ^^^^^^^^^^^ reference [..] AdvancedODM#
#                ^^^ reference [..] Class#new().
     AdvancedODM.new.foreign_
#    ^^^^^^^^^^^ reference [..] AdvancedODM#
#                ^^^ reference [..] Class#new().
     AdvancedODM.new.foreign_lazy_
#    ^^^^^^^^^^^ reference [..] AdvancedODM#
#                ^^^ reference [..] Class#new().
#                    ^^^^^^^^^^^^^ reference [..] AdvancedODM#foreign_lazy_().
 
     # Check that the method still exists even if we can't parse the type
     AdvancedODM.new.foreign_invalid_
#    ^^^^^^^^^^^ reference [..] AdvancedODM#
#                ^^^ reference [..] Class#new().
#                    ^^^^^^^^^^^^^^^^ reference [..] AdvancedODM#foreign_invalid_().
 
     PropHelpers.new.token
#    ^^^^^^^^^^^ reference [..] PropHelpers#
#                ^^^ reference [..] Class#new().
#                    ^^^^^ reference [..] PropHelpers#token().
     PropHelpers.new.token = "tok_token"
#    ^^^^^^^^^^^ reference [..] PropHelpers#
#                ^^^ reference [..] Class#new().
#                    ^^^^^^^ reference [..] PropHelpers#`token=`().
     PropHelpers.new.token = nil
#    ^^^^^^^^^^^ reference [..] PropHelpers#
#                ^^^ reference [..] Class#new().
#                    ^^^^^^^ reference [..] PropHelpers#`token=`().
 
     PropHelpers.new.created
#    ^^^^^^^^^^^ reference [..] PropHelpers#
#                ^^^ reference [..] Class#new().
#                    ^^^^^^^ reference [..] PropHelpers#created().
     PropHelpers.new.created = 0.0
#    ^^^^^^^^^^^ reference [..] PropHelpers#
#                ^^^ reference [..] Class#new().
#                    ^^^^^^^^^ reference [..] PropHelpers#`created=`().
     PropHelpers.new.created = nil
#    ^^^^^^^^^^^ reference [..] PropHelpers#
#                ^^^ reference [..] Class#new().
#                    ^^^^^^^^^ reference [..] PropHelpers#`created=`().
 
     PropHelpers2.new.token
#    ^^^^^^^^^^^^ reference [..] PropHelpers2#
#                 ^^^ reference [..] Class#new().
#                     ^^^^^ reference [..] PropHelpers2#token().
     PropHelpers2.new.token = "tok_token"
#    ^^^^^^^^^^^^ reference [..] PropHelpers2#
#                 ^^^ reference [..] Class#new().
#                     ^^^^^^^ reference [..] PropHelpers2#`token=`().
     PropHelpers2.new.token = nil
#    ^^^^^^^^^^^^ reference [..] PropHelpers2#
#                 ^^^ reference [..] Class#new().
#                     ^^^^^^^ reference [..] PropHelpers2#`token=`().
 
     PropHelpers2.new.created
#    ^^^^^^^^^^^^ reference [..] PropHelpers2#
#                 ^^^ reference [..] Class#new().
#                     ^^^^^^^ reference [..] PropHelpers2#created().
     PropHelpers2.new.created = 0.0
#    ^^^^^^^^^^^^ reference [..] PropHelpers2#
#                 ^^^ reference [..] Class#new().
 
     AdvancedODM.new.ifunset
#    ^^^^^^^^^^^ reference [..] AdvancedODM#
#                ^^^ reference [..] Class#new().
#                    ^^^^^^^ reference [..] AdvancedODM#ifunset().
     AdvancedODM.new.ifunset_nilable
#    ^^^^^^^^^^^ reference [..] AdvancedODM#
#                ^^^ reference [..] Class#new().
#                    ^^^^^^^^^^^^^^^ reference [..] AdvancedODM#ifunset_nilable().
     AdvancedODM.new.ifunset = nil
#    ^^^^^^^^^^^ reference [..] AdvancedODM#
#                ^^^ reference [..] Class#new().
#                    ^^^^^^^^^ reference [..] AdvancedODM#`ifunset=`().
     AdvancedODM.new.ifunset_nilable = nil
#    ^^^^^^^^^^^ reference [..] AdvancedODM#
#                ^^^ reference [..] Class#new().
#                    ^^^^^^^^^^^^^^^^^ reference [..] AdvancedODM#`ifunset_nilable=`().
 end
