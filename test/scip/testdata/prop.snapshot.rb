 # typed: true
 
#⌄ enclosing_range_start [..] SomeODM#
 class SomeODM
#      ^^^^^^^ definition [..] SomeODM#
     extend T::Sig
#    ^^^^^^ reference [..] Kernel#extend().
     include T::Props
#    ^^^^^^^ reference [..] Module#include().
#            ^ reference [..] T#
#               ^^^^^ reference [..] T#Props#
 
#    ⌄ enclosing_range_start [..] SomeODM#`foo=`().
#    ⌄ enclosing_range_start [..] SomeODM#foo().
     prop :foo, String
#          ^^^ definition [..] SomeODM#`foo=`().
#          ^^^ definition [..] SomeODM#foo().
#               ^^^^^^ reference [..] String#
#                    ⌃ enclosing_range_end [..] SomeODM#`foo=`().
#                    ⌃ enclosing_range_end [..] SomeODM#foo().
 
     sig {returns(T.nilable(String))}
#                           ^^^^^^ reference [..] String#
#    ⌄ enclosing_range_start [..] SomeODM#foo2().
     def foo2; T.cast(T.unsafe(nil), T.nilable(String)); end
#        ^^^^ definition [..] SomeODM#foo2().
#                     ^ reference [..] T#
#                       ^^^^^^ reference [..] `<Class:T>`#unsafe().
#                                    ^ reference [..] T#
#                                    ^^^^^^^^^^^^^^^^^ definition local 1$1867563647
#                                      ^^^^^^^ reference [..] `<Class:T>`#nilable().
#                                              ^^^^^^ reference [..] String#
#                                                          ⌃ enclosing_range_end [..] SomeODM#foo2().
     sig {params(arg0: String).returns(String)}
#                      ^^^^^^ reference [..] String#
#                                      ^^^^^^ reference [..] String#
#    ⌄ enclosing_range_start [..] SomeODM#`foo2=`().
     def foo2=(arg0); T.cast(nil, String); end
#        ^^^^^ definition [..] SomeODM#`foo2=`().
#                                 ^^^^^^ definition local 1$2116144614
#                                 ^^^^^^ reference [..] String#
#                                            ⌃ enclosing_range_end [..] SomeODM#`foo2=`().
 end
#  ⌃ enclosing_range_end [..] SomeODM#
 
#⌄ enclosing_range_start [..] ForeignClass#
 class ForeignClass
#      ^^^^^^^^^^^^ definition [..] ForeignClass#
 end
#  ⌃ enclosing_range_end [..] ForeignClass#
 
#⌄ enclosing_range_start [..] AdvancedODM#
 class AdvancedODM
#      ^^^^^^^^^^^ definition [..] AdvancedODM#
     include T::Props
#    ^^^^^^^ reference [..] Module#include().
#            ^ reference [..] T#
#               ^^^^^ reference [..] T#Props#
#    ⌄ enclosing_range_start [..] AdvancedODM#`default=`().
#    ⌄ enclosing_range_start [..] AdvancedODM#default().
     prop :default, String, default: ""
#          ^^^^^^^ definition [..] AdvancedODM#`default=`().
#          ^^^^^^^ definition [..] AdvancedODM#default().
#                   ^^^^^^ reference [..] String#
#                                     ⌃ enclosing_range_end [..] AdvancedODM#`default=`().
#                                     ⌃ enclosing_range_end [..] AdvancedODM#default().
#    ⌄ enclosing_range_start [..] AdvancedODM#`t_nilable=`().
#    ⌄ enclosing_range_start [..] AdvancedODM#t_nilable().
     prop :t_nilable, T.nilable(String)
#          ^^^^^^^^^ definition [..] AdvancedODM#`t_nilable=`().
#          ^^^^^^^^^ definition [..] AdvancedODM#t_nilable().
#                               ^^^^^^ reference [..] String#
#                                     ⌃ enclosing_range_end [..] AdvancedODM#`t_nilable=`().
#                                     ⌃ enclosing_range_end [..] AdvancedODM#t_nilable().
 
#    ⌄ enclosing_range_start [..] AdvancedODM#`array=`().
#    ⌄ enclosing_range_start [..] AdvancedODM#array().
     prop :array, Array
#          ^^^^^ definition [..] AdvancedODM#`array=`().
#          ^^^^^ definition [..] AdvancedODM#array().
#                 ^^^^^ reference [..] Array#
#                     ⌃ enclosing_range_end [..] AdvancedODM#`array=`().
#                     ⌃ enclosing_range_end [..] AdvancedODM#array().
#    ⌄ enclosing_range_start [..] AdvancedODM#`t_array=`().
#    ⌄ enclosing_range_start [..] AdvancedODM#t_array().
     prop :t_array, T::Array[String]
#          ^^^^^^^ definition [..] AdvancedODM#`t_array=`().
#          ^^^^^^^ definition [..] AdvancedODM#t_array().
#                            ^^^^^^ reference [..] String#
#                                  ⌃ enclosing_range_end [..] AdvancedODM#`t_array=`().
#                                  ⌃ enclosing_range_end [..] AdvancedODM#t_array().
#    ⌄ enclosing_range_start [..] AdvancedODM#`hash_of=`().
#    ⌄ enclosing_range_start [..] AdvancedODM#hash_of().
     prop :hash_of, T::Hash[Symbol, String]
#          ^^^^^^^ definition [..] AdvancedODM#`hash_of=`().
#          ^^^^^^^ definition [..] AdvancedODM#hash_of().
#                           ^^^^^^ reference [..] Symbol#
#                                   ^^^^^^ reference [..] String#
#                                         ⌃ enclosing_range_end [..] AdvancedODM#`hash_of=`().
#                                         ⌃ enclosing_range_end [..] AdvancedODM#hash_of().
 
#    ⌄ enclosing_range_start [..] AdvancedODM#const_explicit().
     prop :const_explicit, String, immutable: true
#          ^^^^^^^^^^^^^^ definition [..] AdvancedODM#const_explicit().
#                          ^^^^^^ reference [..] String#
#                                                ⌃ enclosing_range_end [..] AdvancedODM#const_explicit().
#    ⌄ enclosing_range_start [..] AdvancedODM#const().
     const :const, String
#           ^^^^^ definition [..] AdvancedODM#const().
#                  ^^^^^^ reference [..] String#
#                       ⌃ enclosing_range_end [..] AdvancedODM#const().
 
#    ⌄ enclosing_range_start [..] AdvancedODM#`enum_prop=`().
#    ⌄ enclosing_range_start [..] AdvancedODM#enum_prop().
     prop :enum_prop, String, enum: ["hello", "goodbye"]
#          ^^^^^^^^^ definition [..] AdvancedODM#`enum_prop=`().
#          ^^^^^^^^^ definition [..] AdvancedODM#enum_prop().
#                     ^^^^^^ reference [..] String#
#                                                      ⌃ enclosing_range_end [..] AdvancedODM#`enum_prop=`().
#                                                      ⌃ enclosing_range_end [..] AdvancedODM#enum_prop().
 
#    ⌄ enclosing_range_start [..] AdvancedODM#`foreign_lazy=`().
#    ⌄ enclosing_range_start [..] AdvancedODM#`foreign_lazy_!`().
#    ⌄ enclosing_range_start [..] AdvancedODM#foreign_lazy().
#    ⌄ enclosing_range_start [..] AdvancedODM#foreign_lazy_().
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
#                                                         ⌃ enclosing_range_end [..] AdvancedODM#`foreign_lazy=`().
#                                                         ⌃ enclosing_range_end [..] AdvancedODM#`foreign_lazy_!`().
#                                                         ⌃ enclosing_range_end [..] AdvancedODM#foreign_lazy().
#                                                         ⌃ enclosing_range_end [..] AdvancedODM#foreign_lazy_().
#    ⌄ enclosing_range_start [..] AdvancedODM#`foreign_proc=`().
#    ⌄ enclosing_range_start [..] AdvancedODM#`foreign_proc_!`().
#    ⌄ enclosing_range_start [..] AdvancedODM#foreign_proc().
#    ⌄ enclosing_range_start [..] AdvancedODM#foreign_proc_().
     prop :foreign_proc, String, foreign: proc {ForeignClass}
#    ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ reference [..] T#Boolean.
#          ^^^^^^^^^^^^ definition [..] AdvancedODM#`foreign_proc=`().
#          ^^^^^^^^^^^^ definition [..] AdvancedODM#`foreign_proc_!`().
#          ^^^^^^^^^^^^ definition [..] AdvancedODM#foreign_proc().
#          ^^^^^^^^^^^^ definition [..] AdvancedODM#foreign_proc_().
#                        ^^^^^^ reference [..] String#
#                                         ^^^^ reference [..] Kernel#proc().
#                                               ^^^^^^^^^^^^ reference [..] ForeignClass#
#                                                           ⌃ enclosing_range_end [..] AdvancedODM#`foreign_proc=`().
#                                                           ⌃ enclosing_range_end [..] AdvancedODM#`foreign_proc_!`().
#                                                           ⌃ enclosing_range_end [..] AdvancedODM#foreign_proc().
#                                                           ⌃ enclosing_range_end [..] AdvancedODM#foreign_proc_().
#    ⌄ enclosing_range_start [..] AdvancedODM#`foreign_invalid=`().
#    ⌄ enclosing_range_start [..] AdvancedODM#`foreign_invalid_!`().
#    ⌄ enclosing_range_start [..] AdvancedODM#foreign_invalid().
#    ⌄ enclosing_range_start [..] AdvancedODM#foreign_invalid_().
     prop :foreign_invalid, String, foreign: proc { :not_a_type }
#    ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ reference [..] T#Boolean.
#          ^^^^^^^^^^^^^^^ definition [..] AdvancedODM#`foreign_invalid=`().
#          ^^^^^^^^^^^^^^^ definition [..] AdvancedODM#`foreign_invalid_!`().
#          ^^^^^^^^^^^^^^^ definition [..] AdvancedODM#foreign_invalid().
#          ^^^^^^^^^^^^^^^ definition [..] AdvancedODM#foreign_invalid_().
#                           ^^^^^^ reference [..] String#
#                                            ^^^^ reference [..] Kernel#proc().
#                                                               ⌃ enclosing_range_end [..] AdvancedODM#`foreign_invalid=`().
#                                                               ⌃ enclosing_range_end [..] AdvancedODM#`foreign_invalid_!`().
#                                                               ⌃ enclosing_range_end [..] AdvancedODM#foreign_invalid().
#                                                               ⌃ enclosing_range_end [..] AdvancedODM#foreign_invalid_().
 
#    ⌄ enclosing_range_start [..] AdvancedODM#`ifunset=`().
#    ⌄ enclosing_range_start [..] AdvancedODM#ifunset().
     prop :ifunset, String, ifunset: ''
#          ^^^^^^^ definition [..] AdvancedODM#`ifunset=`().
#          ^^^^^^^ definition [..] AdvancedODM#ifunset().
#                   ^^^^^^ reference [..] String#
#                                     ⌃ enclosing_range_end [..] AdvancedODM#`ifunset=`().
#                                     ⌃ enclosing_range_end [..] AdvancedODM#ifunset().
#    ⌄ enclosing_range_start [..] AdvancedODM#`ifunset_nilable=`().
#    ⌄ enclosing_range_start [..] AdvancedODM#ifunset_nilable().
     prop :ifunset_nilable, T.nilable(String), ifunset: ''
#          ^^^^^^^^^^^^^^^ definition [..] AdvancedODM#`ifunset_nilable=`().
#          ^^^^^^^^^^^^^^^ definition [..] AdvancedODM#ifunset_nilable().
#                                     ^^^^^^ reference [..] String#
#                                                        ⌃ enclosing_range_end [..] AdvancedODM#`ifunset_nilable=`().
#                                                        ⌃ enclosing_range_end [..] AdvancedODM#ifunset_nilable().
 
#    ⌄ enclosing_range_start [..] AdvancedODM#`empty_hash_rules=`().
#    ⌄ enclosing_range_start [..] AdvancedODM#empty_hash_rules().
     prop :empty_hash_rules, String, {}
#          ^^^^^^^^^^^^^^^^ definition [..] AdvancedODM#`empty_hash_rules=`().
#          ^^^^^^^^^^^^^^^^ definition [..] AdvancedODM#empty_hash_rules().
#                            ^^^^^^ reference [..] String#
#                                     ⌃ enclosing_range_end [..] AdvancedODM#`empty_hash_rules=`().
#                                     ⌃ enclosing_range_end [..] AdvancedODM#empty_hash_rules().
#    ⌄ enclosing_range_start [..] AdvancedODM#`hash_rules=`().
#    ⌄ enclosing_range_start [..] AdvancedODM#hash_rules().
     prop :hash_rules, String, { enum: ["hello", "goodbye" ] }
#          ^^^^^^^^^^ definition [..] AdvancedODM#`hash_rules=`().
#          ^^^^^^^^^^ definition [..] AdvancedODM#hash_rules().
#                      ^^^^^^ reference [..] String#
#                                                            ⌃ enclosing_range_end [..] AdvancedODM#`hash_rules=`().
#                                                            ⌃ enclosing_range_end [..] AdvancedODM#hash_rules().
 end
#  ⌃ enclosing_range_end [..] AdvancedODM#
 
#⌄ enclosing_range_start [..] PropHelpers#
 class PropHelpers
#      ^^^^^^^^^^^ definition [..] PropHelpers#
   include T::Props
#  ^^^^^^^ reference [..] Module#include().
#          ^ reference [..] T#
#             ^^^^^ reference [..] T#Props#
#  ⌄ enclosing_range_start [..] `<Class:PropHelpers>`#token_prop().
   def self.token_prop(opts={}); end
#           ^^^^^^^^^^ definition [..] `<Class:PropHelpers>`#token_prop().
#                                  ⌃ enclosing_range_end [..] `<Class:PropHelpers>`#token_prop().
#  ⌄ enclosing_range_start [..] `<Class:PropHelpers>`#created_prop().
   def self.created_prop(opts={}); end
#           ^^^^^^^^^^^^ definition [..] `<Class:PropHelpers>`#created_prop().
#                                    ⌃ enclosing_range_end [..] `<Class:PropHelpers>`#created_prop().
#  ⌄ enclosing_range_start [..] PropHelpers#`token=`().
#  ⌄ enclosing_range_start [..] PropHelpers#token().
   token_prop
#  ^^^^^ definition [..] PropHelpers#`token=`().
#  ^^^^^ definition [..] PropHelpers#token().
#  ^^^^^^^^^^ reference [..] `<Class:PropHelpers>`#token_prop().
#  ^^^^^^^^^^ reference [..] String#
#           ⌃ enclosing_range_end [..] PropHelpers#`token=`().
#           ⌃ enclosing_range_end [..] PropHelpers#token().
#  ⌄ enclosing_range_start [..] PropHelpers#`created=`().
#  ⌄ enclosing_range_start [..] PropHelpers#created().
   created_prop
#  ^^^^^^^ definition [..] PropHelpers#`created=`().
#  ^^^^^^^ definition [..] PropHelpers#created().
#  ^^^^^^^^^^^^ reference [..] `<Class:PropHelpers>`#created_prop().
#  ^^^^^^^^^^^^ reference [..] Float#
#             ⌃ enclosing_range_end [..] PropHelpers#`created=`().
#             ⌃ enclosing_range_end [..] PropHelpers#created().
 end
#  ⌃ enclosing_range_end [..] PropHelpers#
 
#⌄ enclosing_range_start [..] PropHelpers2#
 class PropHelpers2
#      ^^^^^^^^^^^^ definition [..] PropHelpers2#
   include T::Props
#  ^^^^^^^ reference [..] Module#include().
#          ^ reference [..] T#
#             ^^^^^ reference [..] T#Props#
#  ⌄ enclosing_range_start [..] `<Class:PropHelpers2>`#timestamped_token_prop().
   def self.timestamped_token_prop(opts={}); end
#           ^^^^^^^^^^^^^^^^^^^^^^ definition [..] `<Class:PropHelpers2>`#timestamped_token_prop().
#                                              ⌃ enclosing_range_end [..] `<Class:PropHelpers2>`#timestamped_token_prop().
#  ⌄ enclosing_range_start [..] `<Class:PropHelpers2>`#created_prop().
   def self.created_prop(opts={}); end
#           ^^^^^^^^^^^^ definition [..] `<Class:PropHelpers2>`#created_prop().
#                                    ⌃ enclosing_range_end [..] `<Class:PropHelpers2>`#created_prop().
#  ⌄ enclosing_range_start [..] PropHelpers2#`token=`().
#  ⌄ enclosing_range_start [..] PropHelpers2#token().
   timestamped_token_prop
#  ^^^^^^^^^^^^^^^^^^^^^^ reference [..] `<Class:PropHelpers2>`#timestamped_token_prop().
#  ^^^^^^^^^^^^^^^^^^^^^^ reference [..] String#
#              ^^^^^ definition [..] PropHelpers2#`token=`().
#              ^^^^^ definition [..] PropHelpers2#token().
#                       ⌃ enclosing_range_end [..] PropHelpers2#`token=`().
#                       ⌃ enclosing_range_end [..] PropHelpers2#token().
#  ⌄ enclosing_range_start [..] PropHelpers2#created().
   created_prop(immutable: true)
#  ^^^^^^^^^^^^ reference [..] `<Class:PropHelpers2>`#created_prop().
#  ^^^^^^^^^^^^^^^^^^^^^^^^ definition [..] PropHelpers2#created().
#  ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ reference [..] Float#
#                              ⌃ enclosing_range_end [..] PropHelpers2#created().
 end
#  ⌃ enclosing_range_end [..] PropHelpers2#
 
#⌄ enclosing_range_start [..] Object#main().
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
#  ⌃ enclosing_range_end [..] Object#main().
