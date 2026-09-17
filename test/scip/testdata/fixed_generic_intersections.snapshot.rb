 # typed: true
 # check-errors: true
 # options: showDocs
 
#⌄ enclosing_range_start [..] FixedHash#
 class FixedHash < Hash
#      ^^^^^^^^^ definition [..] FixedHash#
#      documentation
#      | ```ruby
#      | class FixedHash < Hash
#      | ```
#                  ^^^^ reference [..] Hash#
   extend T::Generic
#  ^^^^^^ reference [..] Kernel#extend().
   K = type_member { { fixed: Symbol } }
#  ^ definition [..] FixedHash#K#
#  documentation
#  | ```ruby
#  | K = type_member
#  | ```
#                             ^^^^^^ reference [..] Symbol#
   V = type_member { { fixed: Object } }
#  ^ definition [..] FixedHash#V#
#  documentation
#  | ```ruby
#  | V = type_member
#  | ```
#                             ^^^^^^ reference [..] Object#
   Elem = type_member { { fixed: [Symbol, Object] } }
#  ^^^^ definition [..] FixedHash#Elem#
#  documentation
#  | ```ruby
#  | Elem = type_member
#  | ```
#                                 ^^^^^^ reference [..] Symbol#
#                                         ^^^^^^ reference [..] Object#
 
#  ⌄ enclosing_range_start [..] FixedHash#custom_method().
   def custom_method; 'custom'; end
#      ^^^^^^^^^^^^^ definition [..] FixedHash#custom_method().
#      documentation
#      | ```ruby
#      | sig { returns(T.untyped) }
#      | def custom_method
#      | ```
#                                 ⌃ enclosing_range_end [..] FixedHash#custom_method().
 end
#  ⌃ enclosing_range_end [..] FixedHash#
 
 extend T::Sig
#^^^^^^ reference [..] Kernel#extend().
#       ^ reference [..] T#
#          ^^^ reference [..] T#Sig#
 sig { params(value: T.all(FixedHash, T::Hash[Symbol, String])).void }
#^^^ reference [..] T#Sig#sig().
#      ^^^^^^ reference [..] T#Private#Methods#DeclBuilder#params().
#                    ^ reference [..] T#
#                      ^^^ reference [..] `<Class:T>`#all().
#                          ^^^^^^^^^ reference [..] FixedHash#
#                                     ^ reference [..] T#
#                                        ^^^^ reference [..] T#Hash#
#                                            ^ reference [..] T#`<Class:Hash>`#`[]`().
#                                             ^^^^^^ reference [..] Symbol#
#                                                     ^^^^^^ reference [..] String#
#                                                               ^^^^ reference [..] T#Private#Methods#DeclBuilder#void().
#⌄ enclosing_range_start [..] Object#child_first().
 def child_first(value)
#    ^^^^^^^^^^^ definition [..] Object#child_first().
#    documentation
#    | ```ruby
#    | sig { params(value: T.all(FixedHash, T::Hash[Symbol, String])).void }
#    | def child_first(value)
#    | ```
#                ^^^^^ definition local 1$87271818
#                documentation
#                | ```ruby
#                | value (T.all(FixedHash, T::Hash[Symbol, String]))
#                | ```
   value.fetch(:version).upcase
#  ^^^^^ reference local 1$87271818
#        ^^^^^ reference [..] Hash#`fetch (overload.1)`().
#                        ^^^^^^ reference [..] String#upcase().
   value.custom_method.upcase
#  ^^^^^ reference local 1$87271818
#        ^^^^^^^^^^^^^ reference [..] FixedHash#custom_method().
 end
#  ⌃ enclosing_range_end [..] Object#child_first().
 
 sig { params(value: T.all(T::Hash[Symbol, String], FixedHash)).void }
#^^^ reference [..] T#Sig#sig().
#      ^^^^^^ reference [..] T#Private#Methods#DeclBuilder#params().
#                    ^ reference [..] T#
#                      ^^^ reference [..] `<Class:T>`#all().
#                          ^ reference [..] T#
#                             ^^^^ reference [..] T#Hash#
#                                 ^ reference [..] T#`<Class:Hash>`#`[]`().
#                                  ^^^^^^ reference [..] Symbol#
#                                          ^^^^^^ reference [..] String#
#                                                   ^^^^^^^^^ reference [..] FixedHash#
#                                                               ^^^^ reference [..] T#Private#Methods#DeclBuilder#void().
#⌄ enclosing_range_start [..] Object#parent_first().
 def parent_first(value)
#    ^^^^^^^^^^^^ definition [..] Object#parent_first().
#    documentation
#    | ```ruby
#    | sig { params(value: T.all(T::Hash[Symbol, String], FixedHash)).void }
#    | def parent_first(value)
#    | ```
#                 ^^^^^ definition local 1$1905096266
#                 documentation
#                 | ```ruby
#                 | value (T.all(T::Hash[Symbol, String], FixedHash))
#                 | ```
   value.fetch(:version).upcase
#  ^^^^^ reference local 1$1905096266
#        ^^^^^ reference [..] Hash#`fetch (overload.1)`().
#                        ^^^^^^ reference [..] String#upcase().
   value.custom_method.upcase
#  ^^^^^ reference local 1$1905096266
#        ^^^^^^^^^^^^^ reference [..] FixedHash#custom_method().
 end
#  ⌃ enclosing_range_end [..] Object#parent_first().
 
 sig { params(value: T.any(FixedHash, T::Hash[Symbol, String])).void }
#^^^ reference [..] T#Sig#sig().
#      ^^^^^^ reference [..] T#Private#Methods#DeclBuilder#params().
#                    ^ reference [..] T#
#                      ^^^ reference [..] `<Class:T>`#any().
#                          ^^^^^^^^^ reference [..] FixedHash#
#                                     ^ reference [..] T#
#                                        ^^^^ reference [..] T#Hash#
#                                            ^ reference [..] T#`<Class:Hash>`#`[]`().
#                                             ^^^^^^ reference [..] Symbol#
#                                                     ^^^^^^ reference [..] String#
#                                                               ^^^^ reference [..] T#Private#Methods#DeclBuilder#void().
#⌄ enclosing_range_start [..] Object#narrowing().
 def narrowing(value)
#    ^^^^^^^^^ definition [..] Object#narrowing().
#    documentation
#    | ```ruby
#    | sig { params(value: T::Hash[Symbol, Object]).void }
#    | def narrowing(value)
#    | ```
#              ^^^^^ definition local 1$1411181596
#              documentation
#              | ```ruby
#              | value (T::Hash[Symbol, Object])
#              | ```
   if value.is_a?(FixedHash)
#     ^^^^^ reference local 1$1411181596
#           ^^^^^ reference [..] Kernel#`is_a?`().
#                 ^^^^^^^^^ reference [..] FixedHash#
     value.custom_method.upcase
#    ^^^^^ reference local 1$1411181596
#    override_documentation
#    | ```ruby
#    | value (FixedHash)
#    | ```
#          ^^^^^^^^^^^^^ reference [..] FixedHash#custom_method().
   else
     value.fetch(:version).to_s.upcase
#    ^^^^^ reference local 1$1411181596
#          ^^^^^ reference [..] Hash#fetch().
#                          ^^^^ reference [..] Kernel#to_s().
#                               ^^^^^^ reference [..] String#upcase().
   end
 end
#  ⌃ enclosing_range_end [..] Object#narrowing().
 
 # Parent members that are still covariant can retain their narrower types.
 sig { params(value: T.all(T::Hash[Symbol, Object], T::Hash[Symbol, String])).void }
#^^^ reference [..] T#Sig#sig().
#      ^^^^^^ reference [..] T#Private#Methods#DeclBuilder#params().
#                    ^ reference [..] T#
#                      ^^^ reference [..] `<Class:T>`#all().
#                          ^ reference [..] T#
#                             ^^^^ reference [..] T#Hash#
#                                 ^ reference [..] T#`<Class:Hash>`#`[]`().
#                                  ^^^^^^ reference [..] Symbol#
#                                          ^^^^^^ reference [..] Object#
#                                                   ^ reference [..] T#
#                                                      ^^^^ reference [..] T#Hash#
#                                                          ^ reference [..] T#`<Class:Hash>`#`[]`().
#                                                           ^^^^^^ reference [..] Symbol#
#                                                                   ^^^^^^ reference [..] String#
#                                                                             ^^^^ reference [..] T#Private#Methods#DeclBuilder#void().
#⌄ enclosing_range_start [..] Object#ordinary_covariance().
 def ordinary_covariance(value)
#    ^^^^^^^^^^^^^^^^^^^ definition [..] Object#ordinary_covariance().
#    documentation
#    | ```ruby
#    | sig { params(value: T::Hash[Symbol, String]).void }
#    | def ordinary_covariance(value)
#    | ```
#    documentation
#    | Parent members that are still covariant can retain their narrower types.
#                        ^^^^^ definition local 1$1646336863
#                        documentation
#                        | ```ruby
#                        | value (T::Hash[Symbol, String])
#                        | ```
   value.fetch(:version).upcase
#  ^^^^^ reference local 1$1646336863
#        ^^^^^ reference [..] Hash#fetch().
#                        ^^^^^^ reference [..] String#upcase().
 end
#  ⌃ enclosing_range_end [..] Object#ordinary_covariance().
 
 # An invariant child obtained by is_a? starts with an untyped member. It can
 # still be refined from the typed ancestor without violating subtyping.
#⌄ enclosing_range_start [..] CovariantResult#
 class CovariantResult
#      ^^^^^^^^^^^^^^^ definition [..] CovariantResult#
#      documentation
#      | ```ruby
#      | class CovariantResult
#      | ```
#      documentation
#      | An invariant child obtained by is_a? starts with an untyped member. It can
#      | still be refined from the typed ancestor without violating subtyping.
   extend T::Generic
#  ^^^^^^ reference [..] Kernel#extend().
   extend T::Sig
#  ^^^^^^ reference [..] Kernel#extend().
   Value = type_member(:out)
#  ^^^^^ definition [..] CovariantResult#Value#
#  documentation
#  | ```ruby
#  | Value = type_member
#  | ```
 
   sig { returns(Value) }
#                ^^^^^ reference [..] CovariantResult#Value#
#  ⌄ enclosing_range_start [..] CovariantResult#value().
   def value; T.unsafe(nil); end
#      ^^^^^ definition [..] CovariantResult#value().
#      documentation
#      | ```ruby
#      | sig { returns(CovariantResult::Value) }
#      | def value
#      | ```
#             ^ reference [..] T#
#               ^^^^^^ reference [..] `<Class:T>`#unsafe().
#                              ⌃ enclosing_range_end [..] CovariantResult#value().
 end
#  ⌃ enclosing_range_end [..] CovariantResult#
 
#⌄ enclosing_range_start [..] InvariantResult#
 class InvariantResult < CovariantResult
#      ^^^^^^^^^^^^^^^ definition [..] InvariantResult#
#      documentation
#      | ```ruby
#      | class InvariantResult < CovariantResult
#      | ```
#                        ^^^^^^^^^^^^^^^ reference [..] CovariantResult#
   Value = type_member
#  ^^^^^ definition [..] InvariantResult#Value#
#  documentation
#  | ```ruby
#  | Value = type_member
#  | ```
 end
#  ⌃ enclosing_range_end [..] InvariantResult#
 
 sig { params(result: CovariantResult[String]).void }
#^^^ reference [..] T#Sig#sig().
#      ^^^^^^ reference [..] T#Private#Methods#DeclBuilder#params().
#                     ^^^^^^^^^^^^^^^ reference [..] CovariantResult#
#                                    ^ reference [..] T#Generic#`[]`().
#                                     ^^^^^^ reference [..] String#
#                                              ^^^^ reference [..] T#Private#Methods#DeclBuilder#void().
#⌄ enclosing_range_start [..] Object#refine_untyped_member().
 def refine_untyped_member(result)
#    ^^^^^^^^^^^^^^^^^^^^^ definition [..] Object#refine_untyped_member().
#    documentation
#    | ```ruby
#    | sig { params(result: CovariantResult[String]).void }
#    | def refine_untyped_member(result)
#    | ```
#                          ^^^^^^ definition local 1$21420159
#                          documentation
#                          | ```ruby
#                          | result (CovariantResult[String])
#                          | ```
   if result.is_a?(InvariantResult)
#     ^^^^^^ reference local 1$21420159
#            ^^^^^ reference [..] Kernel#`is_a?`().
#                  ^^^^^^^^^^^^^^^ reference [..] InvariantResult#
     result.value.upcase
#    ^^^^^^ reference local 1$21420159
#    override_documentation
#    | ```ruby
#    | result (InvariantResult[String])
#    | ```
#           ^^^^^ reference [..] CovariantResult#value().
#                 ^^^^^^ reference [..] String#upcase().
   end
 end
#  ⌃ enclosing_range_end [..] Object#refine_untyped_member().
 
 sig { params(result: CovariantResult[T::Array[String]]).void }
#^^^ reference [..] T#Sig#sig().
#      ^^^^^^ reference [..] T#Private#Methods#DeclBuilder#params().
#                     ^^^^^^^^^^^^^^^ reference [..] CovariantResult#
#                                    ^ reference [..] T#Generic#`[]`().
#                                     ^ reference [..] T#
#                                        ^^^^^ reference [..] T#Array#
#                                             ^ reference [..] T#`<Class:Array>`#`[]`().
#                                              ^^^^^^ reference [..] String#
#                                                        ^^^^ reference [..] T#Private#Methods#DeclBuilder#void().
#⌄ enclosing_range_start [..] Object#refine_aggregate_member().
 def refine_aggregate_member(result)
#    ^^^^^^^^^^^^^^^^^^^^^^^ definition [..] Object#refine_aggregate_member().
#    documentation
#    | ```ruby
#    | sig { params(result: CovariantResult[T::Array[String]]).void }
#    | def refine_aggregate_member(result)
#    | ```
#                            ^^^^^^ definition local 1$3489819473
#                            documentation
#                            | ```ruby
#                            | result (CovariantResult[T::Array[String]])
#                            | ```
   if result.is_a?(InvariantResult)
#     ^^^^^^ reference local 1$3489819473
#            ^^^^^ reference [..] Kernel#`is_a?`().
#                  ^^^^^^^^^^^^^^^ reference [..] InvariantResult#
     result.value.join(', ').upcase
#    ^^^^^^ reference local 1$3489819473
#    override_documentation
#    | ```ruby
#    | result (InvariantResult[T::Array[String]])
#    | ```
#           ^^^^^ reference [..] CovariantResult#value().
#                 ^^^^ reference [..] Array#join().
#                            ^^^^^^ reference [..] String#upcase().
   end
 end
#  ⌃ enclosing_range_end [..] Object#refine_aggregate_member().
