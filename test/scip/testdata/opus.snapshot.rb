 # typed: true
 
#⌄ enclosing_range_start [..] Opus#Base#
 class Opus::Base
#      ^^^^ reference [..] Opus#
#            ^^^^ definition [..] Opus#Base#
 end
#  ⌃ enclosing_range_end [..] Opus#Base#
 
#⌄ enclosing_range_start [..] Opus#Derived#
 class Opus::Derived < Opus::Base
#      ^^^^ reference [..] Opus#
#            ^^^^^^^ definition [..] Opus#Derived#
#                      ^^^^ reference [..] Opus#
#                            ^^^^ reference [..] Opus#Base#
 end
#  ⌃ enclosing_range_end [..] Opus#Derived#
 
 TYPES = T.let({ derived: -> { Opus::Derived } }, T::Hash[Symbol, T.proc.returns(T.class_of(Opus::Base))])
#^^^^^ definition [..] TYPES.
#                         ^^ reference [..] Kernel#
#                         ^^ reference [..] Kernel#lambda().
#                              ^^^^ reference [..] Opus#
#                                    ^^^^^^^ reference [..] Opus#Derived#
#                                                 ^ reference [..] T#
#                                                    ^^^^ reference [..] T#Hash#
#                                                         ^^^^^^ reference [..] Symbol#
#                                                                 ^ reference [..] T#
#                                                                   ^^^^ reference [..] `<Class:T>`#proc().
#                                                                                ^ reference [..] T#
#                                                                                  ^^^^^^^^ reference [..] `<Class:T>`#class_of().
#                                                                                           ^^^^ reference [..] Opus#
#                                                                                                 ^^^^ reference [..] Opus#Base#
#                                                                                                 ^^^^^^^ definition local 4$119448696
#                                                                                                 ^^^^^^^^ reference [..] TYPES.
 
#⌄ enclosing_range_start [..] ABC#
 module ABC
#       ^^^ definition [..] ABC#
   TYPES_IN_MODULE = T.let({ derived: -> { Opus::Derived } }, T::Hash[Symbol, T.proc.returns(T.class_of(Opus::Base))])
#  ^^^^^^^^^^^^^^^ definition [..] ABC#TYPES_IN_MODULE.
#                                     ^^ reference [..] Kernel#
#                                     ^^ reference [..] Kernel#lambda().
#                                          ^^^^ reference [..] Opus#
#                                                ^^^^^^^ reference [..] Opus#Derived#
#                                                                     ^^^^^^ reference [..] Symbol#
#                                                                                                       ^^^^ reference [..] Opus#
#                                                                                                             ^^^^ reference [..] Opus#Base#
#                                                                                                             ^^^^^^^ definition local 4$119448696
#                                                                                                             ^^^^^^^^ reference [..] ABC#TYPES_IN_MODULE.
 end
#  ⌃ enclosing_range_end [..] ABC#
 
#⌄ enclosing_range_start [..] Other#
 class Other
#      ^^^^^ definition [..] Other#
   TYPES_IN_CLASS = T.let({ derived: -> { Opus::Derived } }, T::Hash[Symbol, T.proc.returns(T.class_of(Opus::Base))])
#  ^^^^^^^^^^^^^^ definition [..] Other#TYPES_IN_CLASS.
#                                    ^^ reference [..] Kernel#
#                                    ^^ reference [..] Kernel#lambda().
#                                         ^^^^ reference [..] Opus#
#                                               ^^^^^^^ reference [..] Opus#Derived#
#                                                                    ^^^^^^ reference [..] Symbol#
#                                                                                                      ^^^^ reference [..] Opus#
#                                                                                                            ^^^^ reference [..] Opus#Base#
#                                                                                                            ^^^^^^^ definition local 4$119448696
#                                                                                                            ^^^^^^^^ reference [..] Other#TYPES_IN_CLASS.
 end
#  ⌃ enclosing_range_end [..] Other#
