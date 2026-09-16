 # typed: true
 # check-errors: true
 
#⌄ enclosing_range_start [..] GenericMethods#
 class GenericMethods
#      ^^^^^^^^^^^^^^ definition [..] GenericMethods#
   extend T::Sig
#  ^^^^^^ reference [..] Kernel#extend().
 
   sig { type_parameters(:U).params(value: T.type_parameter(:U)).returns(T.type_parameter(:U)) }
#                         ^ definition [..] GenericMethods#identity().[U]
#                                                            ^ reference [..] GenericMethods#identity().[U]
#                                                                                          ^ reference [..] GenericMethods#identity().[U]
#  ⌄ enclosing_range_start [..] GenericMethods#identity().
   def identity(value)
#      ^^^^^^^^ definition [..] GenericMethods#identity().
#               ^^^^^ definition local 1$2839884955
     result = T.let(value, T.type_parameter(:U))
#    ^^^^^^ definition local 2$2839884955
#                   ^^^^^ reference local 1$2839884955
#                                            ^ reference [..] GenericMethods#identity().[U]
     1.times { result = T.let(value, T.type_parameter(:U)) }
#      ^^^^^ reference [..] Integer#times().
#              ^^^^^^ reference (write) local 2$2839884955
#              ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ reference local 2$2839884955
#                             ^^^^^ reference local 1$2839884955
#                                                      ^ reference [..] GenericMethods#identity().[U]
     result
#    ^^^^^^ reference local 2$2839884955
   end
#    ⌃ enclosing_range_end [..] GenericMethods#identity().
 
   sig do
     type_parameters(:U, :V)
#                     ^ definition [..] GenericMethods#second().[U]
#                         ^ definition [..] GenericMethods#second().[V]
       .params(first: T.type_parameter(:U), second: T.type_parameter(:V))
#                                       ^ reference [..] GenericMethods#second().[U]
#                                                                     ^ reference [..] GenericMethods#second().[V]
       .returns(T.type_parameter(:V))
#                                 ^ reference [..] GenericMethods#second().[V]
   end
#  ⌄ enclosing_range_start [..] GenericMethods#second().
   def second(first, second)
#      ^^^^^^ definition [..] GenericMethods#second().
#                    ^^^^^^ definition local 1$2885211357
     second
#    ^^^^^^ reference local 1$2885211357
   end
#    ⌃ enclosing_range_end [..] GenericMethods#second().
 
   sig { type_parameters(:Unused).void }
#                         ^^^^^^ definition [..] GenericMethods#unused().[Unused]
#  ⌄ enclosing_range_start [..] GenericMethods#unused().
   def unused; end
#      ^^^^^^ definition [..] GenericMethods#unused().
#                ⌃ enclosing_range_end [..] GenericMethods#unused().
 
   sig { type_parameters(:"U").params(value: T.type_parameter(:'U')).returns(T.type_parameter(:"U")) }
#                          ^ definition [..] `<Class:GenericMethods>`#identity().[U]
#                                                               ^ reference [..] `<Class:GenericMethods>`#identity().[U]
#                                                                                               ^ reference [..] `<Class:GenericMethods>`#identity().[U]
#  ⌄ enclosing_range_start [..] `<Class:GenericMethods>`#identity().
   def self.identity(value)
#           ^^^^^^^^ definition [..] `<Class:GenericMethods>`#identity().
#                    ^^^^^ definition local 1$2839884955
     T.let(value, T.type_parameter(:'U'))
#          ^^^^^ reference local 1$2839884955
#                                    ^ reference [..] `<Class:GenericMethods>`#identity().[U]
   end
#    ⌃ enclosing_range_end [..] `<Class:GenericMethods>`#identity().
 end
#  ⌃ enclosing_range_end [..] GenericMethods#
 
#⌄ enclosing_range_start [..] OtherGenericMethods#
 class OtherGenericMethods
#      ^^^^^^^^^^^^^^^^^^^ definition [..] OtherGenericMethods#
   extend T::Sig
#  ^^^^^^ reference [..] Kernel#extend().
 
   sig { type_parameters(:U).params(value: T.type_parameter(:U)).returns(T.type_parameter(:U)) }
#                         ^ definition [..] OtherGenericMethods#identity().[U]
#                                                            ^ reference [..] OtherGenericMethods#identity().[U]
#                                                                                          ^ reference [..] OtherGenericMethods#identity().[U]
#  ⌄ enclosing_range_start [..] OtherGenericMethods#identity().
   def identity(value)
#      ^^^^^^^^ definition [..] OtherGenericMethods#identity().
#               ^^^^^ definition local 1$2839884955
     value
#    ^^^^^ reference local 1$2839884955
   end
#    ⌃ enclosing_range_end [..] OtherGenericMethods#identity().
 end
#  ⌃ enclosing_range_end [..] OtherGenericMethods#
 
 GenericMethods.new.identity("text").upcase
#^^^^^^^^^^^^^^ reference [..] GenericMethods#
#               ^^^ reference [..] Class#new().
#                   ^^^^^^^^ reference [..] GenericMethods#identity().
#                                    ^^^^^^ reference [..] String#upcase().
 GenericMethods.new.second(1, "text").upcase
#^^^^^^^^^^^^^^ reference [..] GenericMethods#
#               ^^^ reference [..] Class#new().
#                   ^^^^^^ reference [..] GenericMethods#second().
#                                     ^^^^^^ reference [..] String#upcase().
 GenericMethods.identity(1).abs
#^^^^^^^^^^^^^^ reference [..] GenericMethods#
#               ^^^^^^^^ reference [..] `<Class:GenericMethods>`#identity().
#                           ^^^ reference [..] Integer#abs().
 OtherGenericMethods.new.identity("text").upcase
#^^^^^^^^^^^^^^^^^^^ reference [..] OtherGenericMethods#
#                    ^^^ reference [..] Class#new().
#                        ^^^^^^^^ reference [..] OtherGenericMethods#identity().
#                                         ^^^^^^ reference [..] String#upcase().
