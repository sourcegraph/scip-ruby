 # typed: true
 # check-errors: true
 # options: showDocs
 
#⌄ enclosing_range_start [..] HoverBox#
 class HoverBox
#      ^^^^^^^^ definition [..] HoverBox#
#      documentation
#      | ```ruby
#      | class HoverBox
#      | ```
   extend T::Sig
#  ^^^^^^ reference [..] Kernel#extend().
   extend T::Generic
#  ^^^^^^ reference [..] Kernel#extend().
   Elem = type_member { {upper: Numeric} }
#  ^^^^ definition [..] HoverBox#Elem#
#  documentation
#  | ```ruby
#  | Elem = type_member
#  | ```
#                               ^^^^^^^ reference [..] Numeric#
 
   sig { params(value: Elem).void }
#                      ^^^^ reference [..] HoverBox#Elem#
#  ⌄ enclosing_range_start [..] HoverBox#initialize().
   def initialize(value)
#      ^^^^^^^^^^ definition [..] HoverBox#initialize().
#      documentation
#      | ```ruby
#      | sig { params(value: HoverBox::Elem).void }
#      | def initialize(value)
#      | ```
#                 ^^^^^ definition local 1$2532515985
#                 documentation
#                 | ```ruby
#                 | value (HoverBox::Elem)
#                 | ```
     @value = value
#    ^^^^^^ definition [..] HoverBox#`@value`.
#    ^^^^^^^^^^^^^^ reference [..] HoverBox#`@value`.
#             ^^^^^ reference local 1$2532515985
   end
#    ⌃ enclosing_range_end [..] HoverBox#initialize().
 
   sig { params(value: Elem).returns(Elem) }
#                      ^^^^ reference [..] HoverBox#Elem#
#                                    ^^^^ reference [..] HoverBox#Elem#
#  ⌄ enclosing_range_start [..] HoverBox#echo().
   def echo(value)
#      ^^^^ definition [..] HoverBox#echo().
#      documentation
#      | ```ruby
#      | sig { params(value: HoverBox::Elem).returns(HoverBox::Elem) }
#      | def echo(value)
#      | ```
#           ^^^^^ definition local 1$2191231058
#           documentation
#           | ```ruby
#           | value (HoverBox::Elem)
#           | ```
     value
#    ^^^^^ reference local 1$2191231058
   end
#    ⌃ enclosing_range_end [..] HoverBox#echo().
 
   sig { type_parameters(:Item).params(value: Elem, other: T.type_parameter(:Item)).returns(T.type_parameter(:Item)) }
#                         ^^^^ definition [..] HoverBox#generic().[Item]
#                         documentation
#                         | ```ruby
#                         | T.type_parameter(:Item)
#                         | ```
#                                             ^^^^ reference [..] HoverBox#Elem#
#                                                                            ^^^^ reference [..] HoverBox#generic().[Item]
#                                                                                                             ^^^^ reference [..] HoverBox#generic().[Item]
#  ⌄ enclosing_range_start [..] HoverBox#generic().
   def generic(value, other)
#      ^^^^^^^ definition [..] HoverBox#generic().
#      documentation
#      | ```ruby
#      | sig do
#      |   type_parameters(:Item)
#      |   .params(
#      |     value: HoverBox::Elem,
#      |     other: T.type_parameter(:Item)
#      |   )
#      |   .returns(T.type_parameter(:Item))
#      | end
#      | def generic(value, other)
#      | ```
#                     ^^^^^ definition local 1$3595372148
#                     documentation
#                     | ```ruby
#                     | other (T.type_parameter(:Item) (of HoverBox#generic))
#                     | ```
     other
#    ^^^^^ reference local 1$3595372148
   end
#    ⌃ enclosing_range_end [..] HoverBox#generic().
 
   alias copied echo
 end
#  ⌃ enclosing_range_end [..] HoverBox#
 
#⌄ enclosing_range_start [..] HoverFixed#
 class HoverFixed
#      ^^^^^^^^^^ definition [..] HoverFixed#
#      documentation
#      | ```ruby
#      | class HoverFixed
#      | ```
   extend T::Sig
#  ^^^^^^ reference [..] Kernel#extend().
   extend T::Generic
#  ^^^^^^ reference [..] Kernel#extend().
   Elem = type_member { {fixed: Integer} }
#  ^^^^ definition [..] HoverFixed#Elem#
#  documentation
#  | ```ruby
#  | Elem = type_member
#  | ```
#                               ^^^^^^^ reference [..] Integer#
 
   sig { params(value: Elem).returns(Elem) }
#                      ^^^^ reference [..] HoverFixed#Elem#
#                                    ^^^^ reference [..] HoverFixed#Elem#
#  ⌄ enclosing_range_start [..] HoverFixed#echo().
   def echo(value)
#      ^^^^ definition [..] HoverFixed#echo().
#      documentation
#      | ```ruby
#      | sig { params(value: Integer).returns(Integer) }
#      | def echo(value)
#      | ```
#           ^^^^^ definition local 1$529720711
#           documentation
#           | ```ruby
#           | value (Integer)
#           | ```
     value
#    ^^^^^ reference local 1$529720711
   end
#    ⌃ enclosing_range_end [..] HoverFixed#echo().
 end
#  ⌃ enclosing_range_end [..] HoverFixed#
 
#⌄ enclosing_range_start [..] HoverTemplate#
 class HoverTemplate
#      ^^^^^^^^^^^^^ definition [..] HoverTemplate#
#      documentation
#      | ```ruby
#      | class HoverTemplate
#      | ```
   extend T::Sig
#  ^^^^^^ reference [..] Kernel#extend().
   extend T::Generic
#  ^^^^^^ reference [..] Kernel#extend().
   Elem = type_template
#  ^^^^ definition [..] `<Class:HoverTemplate>`#Elem#
#  documentation
#  | ```ruby
#  | Elem = type_template
#  | ```
 
   sig { params(value: Elem).returns(Elem) }
#                      ^^^^ reference [..] `<Class:HoverTemplate>`#Elem#
#                                    ^^^^ reference [..] `<Class:HoverTemplate>`#Elem#
#  ⌄ enclosing_range_start [..] `<Class:HoverTemplate>`#echo().
   def self.echo(value)
#           ^^^^ definition [..] `<Class:HoverTemplate>`#echo().
#           documentation
#           | ```ruby
#           | sig do
#           |   params(
#           |     value: T.class_of(HoverTemplate)::Elem
#           |   )
#           |   .returns(T.class_of(HoverTemplate)::Elem)
#           | end
#           | def self.echo(value)
#           | ```
#                ^^^^^ definition local 1$876828381
#                documentation
#                | ```ruby
#                | value (T.class_of(HoverTemplate)::Elem)
#                | ```
     value
#    ^^^^^ reference local 1$876828381
   end
#    ⌃ enclosing_range_end [..] `<Class:HoverTemplate>`#echo().
 end
#  ⌃ enclosing_range_end [..] HoverTemplate#
 
#⌄ enclosing_range_start [..] OrdinaryHovers#
 class OrdinaryHovers
#      ^^^^^^^^^^^^^^ definition [..] OrdinaryHovers#
#      documentation
#      | ```ruby
#      | class OrdinaryHovers
#      | ```
   extend T::Sig
#  ^^^^^^ reference [..] Kernel#extend().
 
   sig { params("value": String).returns(String) }
#                        ^^^^^^ reference [..] String#
#                                        ^^^^^^ reference [..] String#
#  ⌄ enclosing_range_start [..] `<Class:OrdinaryHovers>`#quoted().
   def self.quoted(value)
#           ^^^^^^ definition [..] `<Class:OrdinaryHovers>`#quoted().
#           documentation
#           | ```ruby
#           | sig { params(value: String).returns(String) }
#           | def self.quoted(value)
#           | ```
#                  ^^^^^ definition local 1$3183951499
#                  documentation
#                  | ```ruby
#                  | value (String)
#                  | ```
     value
#    ^^^^^ reference local 1$3183951499
   end
#    ⌃ enclosing_range_end [..] `<Class:OrdinaryHovers>`#quoted().
 
   sig { params("*": Integer, "**": String, "&": T.proc.void).void }
#                    ^^^^^^^ reference [..] Integer#
#                                   ^^^^^^ reference [..] String#
#  ⌄ enclosing_range_start [..] `<Class:OrdinaryHovers>`#anonymous().
   def self.anonymous(*, **, &)
#           ^^^^^^^^^ definition [..] `<Class:OrdinaryHovers>`#anonymous().
#           documentation
#           | ```ruby
#           | sig { params("*": Integer, "**": String, "&": T.proc.void).void }
#           | def self.anonymous(*, **, &)
#           | ```
#                     ^ definition local 1$2225683292
#                     documentation
#                     | ```ruby
#                     | * (T::Array[Integer])
#                     | ```
#                        ^^ definition local 2$2225683292
#                        documentation
#                        | ```ruby
#                        | ** (T::Hash[Symbol, String])
#                        | ```
#                            ^ definition local 3$2225683292
#                            documentation
#                            | ```ruby
#                            | & (T.proc.void)
#                            | ```
   end
#    ⌃ enclosing_range_end [..] `<Class:OrdinaryHovers>`#anonymous().
 
   sig { params(value: String, count: Integer, rest: Symbol, flag: T::Boolean, label: String, extras: Integer, block: T.proc.params(value: String).returns(String)).returns(String) }
#                      ^^^^^^ reference [..] String#
#                                     ^^^^^^^ reference [..] Integer#
#                                                    ^^^^^^ reference [..] Symbol#
#                                                                     ^^^^^^^ reference [..] T#Boolean.
#                                                                                     ^^^^^^ reference [..] String#
#                                                                                                     ^^^^^^^ reference [..] Integer#
#                                                                                                                                          ^^^^^^ reference [..] String#
#                                                                                                                                                          ^^^^^^ reference [..] String#
#                                                                                                                                                                           ^^^^^^ reference [..] String#
#  ⌄ enclosing_range_start [..] `<Class:OrdinaryHovers>`#mixed().
   def self.mixed(value, count = 1, *rest, flag:, label: "", **extras, &block)
#           ^^^^^ definition [..] `<Class:OrdinaryHovers>`#mixed().
#           documentation
#           | ```ruby
#           | sig do
#           |   params(
#           |     value: String,
#           |     count: Integer,
#           |     rest: Symbol,
#           |     flag: T::Boolean,
#           |     label: String,
#           |     extras: Integer,
#           |     block: T.proc.params(arg0: String).returns(String)
#           |   )
#           |   .returns(String)
#           | end
#           | def self.mixed(
#           |   value,
#           |   count=…,
#           |   *rest,
#           |   flag:,
#           |   label: …,
#           |   **extras,
#           |   &block
#           | )
#           | end
#           | ```
#                 ^^^^^ definition local 1$2645842298
#                 documentation
#                 | ```ruby
#                 | value (String)
#                 | ```
#                                          ^^^^ definition [..] `<Class:OrdinaryHovers>`#mixed().(flag)
#                                          documentation
#                                          | ```ruby
#                                          | flag (T::Boolean)
#                                          | ```
#                                                 ^^^^^ definition [..] `<Class:OrdinaryHovers>`#mixed().(label)
#                                                 documentation
#                                                 | ```ruby
#                                                 | label (String)
#                                                 | ```
#                                                                       ^^^^^ definition local 2$2645842298
#                                                                       documentation
#                                                                       | ```ruby
#                                                                       | block (T.proc.params(arg0: String).returns(String))
#                                                                       | ```
     block.call(value)
#    ^^^^^ reference local 2$2645842298
#          ^^^^ reference [..] Proc1#call().
#               ^^^^^ reference local 1$2645842298
   end
#    ⌃ enclosing_range_end [..] `<Class:OrdinaryHovers>`#mixed().
 end
#  ⌃ enclosing_range_end [..] OrdinaryHovers#
 
 box = HoverBox[Integer].new(1)
#^^^ definition local 3$217974539
#documentation
#| ```ruby
#| box (HoverBox[Integer])
#| ```
#      ^^^^^^^^ reference [..] HoverBox#
#              ^ reference [..] T#Generic#`[]`().
#               ^^^^^^^ reference [..] Integer#
 box.echo(1).abs
#^^^ reference local 3$217974539
#    ^^^^ reference [..] HoverBox#echo().
#            ^^^ reference [..] Integer#abs().
 box.copied(1).abs
#^^^ reference local 3$217974539
#    ^^^^^^ reference [..] HoverBox#echo().
#              ^^^ reference [..] Integer#abs().
 box.generic(1, "a").upcase
#^^^ reference local 3$217974539
#    ^^^^^^^ reference [..] HoverBox#generic().
#                    ^^^^^^ reference [..] String#upcase().
 HoverFixed.new.echo(1).abs
#^^^^^^^^^^ reference [..] HoverFixed#
#           ^^^ reference [..] Class#new().
#               ^^^^ reference [..] HoverFixed#echo().
#                       ^^^ reference [..] Integer#abs().
 OrdinaryHovers.quoted("a").upcase
#^^^^^^^^^^^^^^ reference [..] OrdinaryHovers#
#               ^^^^^^ reference [..] `<Class:OrdinaryHovers>`#quoted().
#                           ^^^^^^ reference [..] String#upcase().
 OrdinaryHovers.mixed("a", flag: true) { |value| value.upcase }
#^^^^^^^^^^^^^^ reference [..] OrdinaryHovers#
#               ^^^^^ reference [..] `<Class:OrdinaryHovers>`#mixed().
#                          ^^^^ reference [..] `<Class:OrdinaryHovers>`#mixed().(flag)
#                                         ^^^^^ definition local 7$217974539
#                                         documentation
#                                         | ```ruby
#                                         | value (String)
#                                         | ```
#                                                ^^^^^ reference local 7$217974539
#                                                      ^^^^^^ reference [..] String#upcase().
