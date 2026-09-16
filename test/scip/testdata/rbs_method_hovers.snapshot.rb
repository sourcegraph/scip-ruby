 # typed: true
 # enable-experimental-rbs-comments: true
 # options: showDocs
 
#⌄ enclosing_range_start [..] RBSHovers#
 class RBSHovers
#      ^^^^^^^^^ definition [..] RBSHovers#
#      documentation
#      | ```ruby
#      | class RBSHovers
#      | ```
   #: (String) -> String
#      ^^^^^^ reference [..] String#
#                 ^^^^^^ reference [..] String#
#  ⌄ enclosing_range_start [..] RBSHovers#unnamed().
   def unnamed(customer)
#      ^^^^^^^ definition [..] RBSHovers#unnamed().
#      documentation
#      | ```ruby
#      | sig { params(customer: String).returns(String) }
#      | def unnamed(customer)
#      | ```
#      documentation
#      | : (String) -> String
#              ^^^^^^^^ definition local 1$4207552351
#              documentation
#              | ```ruby
#              | customer (String)
#              | ```
     customer
#    ^^^^^^^^ reference local 1$4207552351
   end
#    ⌃ enclosing_range_end [..] RBSHovers#unnamed().
 
   #: (String customer) -> String
#      ^^^^^^ reference [..] String#
#                          ^^^^^^ reference [..] String#
#  ⌄ enclosing_range_start [..] RBSHovers#named().
   def named(customer)
#      ^^^^^ definition [..] RBSHovers#named().
#      documentation
#      | ```ruby
#      | sig { params(customer: String).returns(String) }
#      | def named(customer)
#      | ```
#      documentation
#      | : (String customer) -> String
#            ^^^^^^^^ definition local 1$3555021734
#            documentation
#            | ```ruby
#            | customer (String)
#            | ```
     customer
#    ^^^^^^^^ reference local 1$3555021734
   end
#    ⌃ enclosing_range_end [..] RBSHovers#named().
 
   #: (
   #|   String first,
#       ^^^^^^ reference [..] String#
   #|   ?Integer count,
#        ^^^^^^^ reference [..] Integer#
   #|   *Symbol rest, enabled: bool,
#        ^^^^^^ reference [..] Symbol#
#                              ^^^^ reference [..] T#Boolean.
   #|   ?label: String,
#               ^^^^^^ reference [..] String#
   #|   **Integer extras
#         ^^^^^^^ reference [..] Integer#
   #| ) { (String) -> String } -> String
#          ^^^^^^ reference [..] String#
#                     ^^^^^^ reference [..] String#
#                                 ^^^^^^ reference [..] String#
#  ⌄ enclosing_range_start [..] RBSHovers#mixed().
   def mixed(first, count = 1, *rest, enabled:, label: "ok", **extras, &transform)
#      ^^^^^ definition [..] RBSHovers#mixed().
#      documentation
#      | ```ruby
#      | sig do
#      |   params(
#      |     first: String,
#      |     count: Integer,
#      |     rest: Symbol,
#      |     enabled: T::Boolean,
#      |     label: String,
#      |     extras: Integer,
#      |     transform: T.proc.params(arg0: String).returns(String)
#      |   )
#      |   .returns(String)
#      | end
#      | def mixed(
#      |   first,
#      |   count=…,
#      |   *rest,
#      |   enabled:,
#      |   label: …,
#      |   **extras,
#      |   &transform
#      | )
#      | end
#      | ```
#      documentation
#      | : (
#      | |   String first,
#      | |   ?Integer count,
#      | |   *Symbol rest, enabled: bool,
#      | |   ?label: String,
#      | |   **Integer extras
#      | | ) { (String) -> String } -> String
#            ^^^^^ definition local 1$3845391352
#            documentation
#            | ```ruby
#            | first (String)
#            | ```
#                                                                       ^^^^^^^^^ definition local 2$3845391352
#                                                                       documentation
#                                                                       | ```ruby
#                                                                       | transform (T.proc.params(arg0: String).returns(String))
#                                                                       | ```
     transform.call(first)
#    ^^^^^^^^^ reference local 2$3845391352
#              ^^^^ reference [..] Proc1#call().
#                   ^^^^^ reference local 1$3845391352
   end
#    ⌃ enclosing_range_end [..] RBSHovers#mixed().
 
   #: (?String, *Integer, Integer, flag: bool, ?limit: Integer, **String) ?{ -> void } -> void
#       ^^^^^^ reference [..] String#
#                ^^^^^^^ reference [..] Integer#
#                         ^^^^^^^ reference [..] Integer#
#                                        ^^^^ reference [..] T#Boolean.
#                                                      ^^^^^^^ reference [..] Integer#
#                                                                 ^^^^^^ reference [..] String#
#  ⌄ enclosing_range_start [..] RBSHovers#unnamed_mixed().
   def unnamed_mixed(first = "", *rest, last, flag:, limit: 1, **extras, &block)
#      ^^^^^^^^^^^^^ definition [..] RBSHovers#unnamed_mixed().
#      documentation
#      | ```ruby
#      | sig do
#      |   params(
#      |     first: String,
#      |     rest: Integer,
#      |     last: Integer,
#      |     flag: T::Boolean,
#      |     limit: Integer,
#      |     extras: String,
#      |     block: T.nilable(T.proc.void)
#      |   )
#      |   .void
#      | end
#      | def unnamed_mixed(
#      |   first=…,
#      |   *rest,
#      |   last,
#      |   flag:,
#      |   limit: …,
#      |   **extras,
#      |   &block
#      | )
#      | end
#      | ```
#      documentation
#      | : (?String, *Integer, Integer, flag: bool, ?limit: Integer, **String) ?{ -> void } -> void
   end
#    ⌃ enclosing_range_end [..] RBSHovers#unnamed_mixed().
 
   #: (String) -> String
#      ^^^^^^ reference [..] String#
#                 ^^^^^^ reference [..] String#
#  ⌄ enclosing_range_start [..] `<Class:RBSHovers>`#singleton().
   def self.singleton(customer)
#           ^^^^^^^^^ definition [..] `<Class:RBSHovers>`#singleton().
#           documentation
#           | ```ruby
#           | sig { params(customer: String).returns(String) }
#           | def self.singleton(customer)
#           | ```
#           documentation
#           | : (String) -> String
#                     ^^^^^^^^ definition local 1$622135554
#                     documentation
#                     | ```ruby
#                     | customer (String)
#                     | ```
     customer
#    ^^^^^^^^ reference local 1$622135554
   end
#    ⌃ enclosing_range_end [..] `<Class:RBSHovers>`#singleton().
 
   #: [Item] (Item) -> Item
#      ^^^^ definition [..] RBSHovers#identity().[Item]
#      documentation
#      | ```ruby
#      | T.type_parameter(:Item)
#      | ```
#             ^^^^ reference [..] RBSHovers#identity().[Item]
#                      ^^^^ reference [..] RBSHovers#identity().[Item]
#  ⌄ enclosing_range_start [..] RBSHovers#identity().
   def identity(value)
#      ^^^^^^^^ definition [..] RBSHovers#identity().
#      documentation
#      | ```ruby
#      | sig { type_parameters(:Item).params(value: T.type_parameter(:Item)).returns(T.type_parameter(:Item)) }
#      | def identity(value)
#      | ```
#      documentation
#      | : [Item] (Item) -> Item
#               ^^^^^ definition local 1$2839884955
#               documentation
#               | ```ruby
#               | value (T.type_parameter(:Item) (of RBSHovers#identity))
#               | ```
     value
#    ^^^^^ reference local 1$2839884955
   end
#    ⌃ enclosing_range_end [..] RBSHovers#identity().
 
   alias copied unnamed
 
   #: String
#     ^^^^^^ reference [..] String#
#  ⌄ enclosing_range_start [..] RBSHovers#`title=`().
   attr_writer :title
#               ^^^^^ definition [..] RBSHovers#`title=`().
#               documentation
#               | ```ruby
#               | sig { params(title: String).returns(String) }
#               | def title=(title)
#               | ```
#               documentation
#               | : String
#                   ⌃ enclosing_range_end [..] RBSHovers#`title=`().
 
   #: String
#     ^^^^^^ reference [..] String#
#     ^^^^^^ reference [..] String#
#  ⌄ enclosing_range_start [..] RBSHovers#`label=`().
#  ⌄ enclosing_range_start [..] RBSHovers#label().
   attr_accessor :label
#                 ^^^^^ definition [..] RBSHovers#`label=`().
#                 documentation
#                 | ```ruby
#                 | sig { params(label: String).returns(String) }
#                 | def label=(label)
#                 | ```
#                 documentation
#                 | : String
#                 ^^^^^ definition [..] RBSHovers#label().
#                 documentation
#                 | ```ruby
#                 | sig { returns(String) }
#                 | def label
#                 | ```
#                 documentation
#                 | : String
#                     ⌃ enclosing_range_end [..] RBSHovers#`label=`().
#                     ⌃ enclosing_range_end [..] RBSHovers#label().
 
   #: (*Integer) -> void
#       ^^^^^^^ reference [..] Integer#
#  ⌄ enclosing_range_start [..] RBSHovers#anonymous_rest().
   def anonymous_rest(*)
#      ^^^^^^^^^^^^^^ definition [..] RBSHovers#anonymous_rest().
#      documentation
#      | ```ruby
#      | sig { params("*": Integer).void }
#      | def anonymous_rest(*)
#      | ```
#      documentation
#      | : (*Integer) -> void
#                     ^ definition local 1$3430227973
#                     documentation
#                     | ```ruby
#                     | * (T::Array[Integer])
#                     | ```
   end
#    ⌃ enclosing_range_end [..] RBSHovers#anonymous_rest().
 
   #: (**String) -> void
#        ^^^^^^ reference [..] String#
#  ⌄ enclosing_range_start [..] RBSHovers#anonymous_keywords().
   def anonymous_keywords(**)
#      ^^^^^^^^^^^^^^^^^^ definition [..] RBSHovers#anonymous_keywords().
#      documentation
#      | ```ruby
#      | sig { params("**": String).void }
#      | def anonymous_keywords(**)
#      | ```
#      documentation
#      | : (**String) -> void
#                         ^^ definition local 1$1395658551
#                         documentation
#                         | ```ruby
#                         | ** (T::Hash[Symbol, String])
#                         | ```
   end
#    ⌃ enclosing_range_end [..] RBSHovers#anonymous_keywords().
 
   #: { -> void } -> void
#  ⌄ enclosing_range_start [..] RBSHovers#anonymous_block().
   def anonymous_block(&)
#      ^^^^^^^^^^^^^^^ definition [..] RBSHovers#anonymous_block().
#      documentation
#      | ```ruby
#      | sig { params("&": T.proc.void).void }
#      | def anonymous_block(&)
#      | ```
#      documentation
#      | : { -> void } -> void
#                      ^ definition local 1$380570012
#                      documentation
#                      | ```ruby
#                      | & (T.proc.void)
#                      | ```
   end
#    ⌃ enclosing_range_end [..] RBSHovers#anonymous_block().
 end
#  ⌃ enclosing_range_end [..] RBSHovers#
 
 #: [Elem < Numeric]
#    ^^^^ definition [..] RBSHoverBox#Elem#
#    documentation
#    | ```ruby
#    | Elem = type_member
#    | ```
#           ^^^^^^^ reference [..] Numeric#
#⌄ enclosing_range_start [..] RBSHoverBox#
 class RBSHoverBox
#      ^^^^^^^^^^^ definition [..] RBSHoverBox#
#      documentation
#      | ```ruby
#      | class RBSHoverBox
#      | ```
#      documentation
#      | : [Elem < Numeric]
   #: (Elem) -> void
#      ^^^^ reference [..] RBSHoverBox#Elem#
#  ⌄ enclosing_range_start [..] RBSHoverBox#initialize().
   def initialize(value)
#      ^^^^^^^^^^ definition [..] RBSHoverBox#initialize().
#      documentation
#      | ```ruby
#      | sig { params(value: RBSHoverBox::Elem).void }
#      | def initialize(value)
#      | ```
#      documentation
#      | : (Elem) -> void
#                 ^^^^^ definition local 1$3465713227
#                 documentation
#                 | ```ruby
#                 | value (RBSHoverBox::Elem)
#                 | ```
     @value = value
#    ^^^^^^ definition [..] RBSHoverBox#`@value`.
#    ^^^^^^^^^^^^^^ reference [..] RBSHoverBox#`@value`.
#             ^^^^^ reference local 1$3465713227
   end
#    ⌃ enclosing_range_end [..] RBSHoverBox#initialize().
 
   #: Elem
#     ^^^^ reference [..] RBSHoverBox#Elem#
#  ⌄ enclosing_range_start [..] RBSHoverBox#value().
   attr_reader :value
#               ^^^^^ definition [..] RBSHoverBox#value().
#               documentation
#               | ```ruby
#               | sig { returns(RBSHoverBox::Elem) }
#               | def value
#               | ```
#               documentation
#               | : Elem
#                   ⌃ enclosing_range_end [..] RBSHoverBox#value().
 
   #: (Elem) -> Elem
#      ^^^^ reference [..] RBSHoverBox#Elem#
#               ^^^^ reference [..] RBSHoverBox#Elem#
#  ⌄ enclosing_range_start [..] RBSHoverBox#echo().
   def echo(value)
#      ^^^^ definition [..] RBSHoverBox#echo().
#      documentation
#      | ```ruby
#      | sig { params(value: RBSHoverBox::Elem).returns(RBSHoverBox::Elem) }
#      | def echo(value)
#      | ```
#      documentation
#      | : (Elem) -> Elem
#           ^^^^^ definition local 1$3567113348
#           documentation
#           | ```ruby
#           | value (Integer)
#           | ```
     value
#    ^^^^^ reference local 1$3567113348
   end
#    ⌃ enclosing_range_end [..] RBSHoverBox#echo().
 
   #: [Item] (Elem, Item) -> Item
#      ^^^^ definition [..] RBSHoverBox#generic().[Item]
#      documentation
#      | ```ruby
#      | T.type_parameter(:Item)
#      | ```
#             ^^^^ reference [..] RBSHoverBox#Elem#
#                   ^^^^ reference [..] RBSHoverBox#generic().[Item]
#                            ^^^^ reference [..] RBSHoverBox#generic().[Item]
#  ⌄ enclosing_range_start [..] RBSHoverBox#generic().
   def generic(value, other)
#      ^^^^^^^ definition [..] RBSHoverBox#generic().
#      documentation
#      | ```ruby
#      | sig do
#      |   type_parameters(:Item)
#      |   .params(
#      |     value: RBSHoverBox::Elem,
#      |     other: T.type_parameter(:Item)
#      |   )
#      |   .returns(T.type_parameter(:Item))
#      | end
#      | def generic(value, other)
#      | ```
#      documentation
#      | : [Item] (Elem, Item) -> Item
#                     ^^^^^ definition local 1$1372385274
#                     documentation
#                     | ```ruby
#                     | other (T.type_parameter(:Item) (of RBSHoverBox#generic))
#                     | ```
     other
#    ^^^^^ reference local 1$1372385274
   end
#    ⌃ enclosing_range_end [..] RBSHoverBox#generic().
 end
#  ⌃ enclosing_range_end [..] RBSHoverBox#
 
 #: [Elem = Integer]
#    ^^^^ definition [..] RBSHoverFixed#Elem#
#    documentation
#    | ```ruby
#    | Elem = type_member
#    | ```
#           ^^^^^^^ reference [..] Integer#
#⌄ enclosing_range_start [..] RBSHoverFixed#
 class RBSHoverFixed
#      ^^^^^^^^^^^^^ definition [..] RBSHoverFixed#
#      documentation
#      | ```ruby
#      | class RBSHoverFixed
#      | ```
#      documentation
#      | : [Elem = Integer]
   #: (Elem) -> Elem
#      ^^^^ reference [..] RBSHoverFixed#Elem#
#               ^^^^ reference [..] RBSHoverFixed#Elem#
#  ⌄ enclosing_range_start [..] RBSHoverFixed#echo().
   def echo(value)
#      ^^^^ definition [..] RBSHoverFixed#echo().
#      documentation
#      | ```ruby
#      | sig { params(value: Integer).returns(Integer) }
#      | def echo(value)
#      | ```
#      documentation
#      | : (Elem) -> Elem
#           ^^^^^ definition local 1$3567113348
#           documentation
#           | ```ruby
#           | value (Integer)
#           | ```
     value
#    ^^^^^ reference local 1$3567113348
   end
#    ⌃ enclosing_range_end [..] RBSHoverFixed#echo().
 end
#  ⌃ enclosing_range_end [..] RBSHoverFixed#
 
 hovers = RBSHovers.new
#^^^^^^ definition local 1$119448696
#documentation
#| ```ruby
#| hovers (RBSHovers)
#| ```
#         ^^^^^^^^^ reference [..] RBSHovers#
#                   ^^^ reference [..] Class#new().
 hovers.unnamed("a").upcase
#^^^^^^ reference local 1$119448696
#       ^^^^^^^ reference [..] RBSHovers#unnamed().
#                    ^^^^^^ reference [..] String#upcase().
 hovers.named("b").upcase
#^^^^^^ reference local 1$119448696
#       ^^^^^ reference [..] RBSHovers#named().
#                  ^^^^^^ reference [..] String#upcase().
 hovers.copied("c").upcase
#^^^^^^ reference local 1$119448696
#       ^^^^^^ reference [..] RBSHovers#unnamed().
#                   ^^^^^^ reference [..] String#upcase().
 hovers.mixed("a", 1, :x, enabled: true, label: "b", x: 2) { |value| value.upcase }
#^^^^^^ reference local 1$119448696
#       ^^^^^ reference [..] RBSHovers#mixed().
#                                                             ^^^^^ definition local 3$119448696
#                                                             documentation
#                                                             | ```ruby
#                                                             | value (String)
#                                                             | ```
#                                                                    ^^^^^ reference local 3$119448696
#                                                                          ^^^^^^ reference [..] String#upcase().
 hovers.unnamed_mixed("a", 1, 2, flag: true)
#^^^^^^ reference local 1$119448696
#       ^^^^^^^^^^^^^ reference [..] RBSHovers#unnamed_mixed().
 hovers.identity(1).abs
#^^^^^^ reference local 1$119448696
#       ^^^^^^^^ reference [..] RBSHovers#identity().
#                   ^^^ reference [..] Integer#abs().
 RBSHovers.singleton("a").upcase
#^^^^^^^^^ reference [..] RBSHovers#
#          ^^^^^^^^^ reference [..] `<Class:RBSHovers>`#singleton().
#                         ^^^^^^ reference [..] String#upcase().
 hovers.title = "a"
#^^^^^^ reference local 1$119448696
#       ^^^^^ reference [..] RBSHovers#`title=`().
 hovers.label = "b"
#^^^^^^ reference local 1$119448696
#       ^^^^^ reference [..] RBSHovers#`label=`().
 hovers.label.upcase
#^^^^^^ reference local 1$119448696
#       ^^^^^ reference [..] RBSHovers#label().
#             ^^^^^^ reference [..] String#upcase().
 box = RBSHoverBox.new(1) #: RBSHoverBox[Integer]
#^^^ definition local 9$119448696
#documentation
#| ```ruby
#| box (RBSHoverBox[Integer])
#| ```
#      ^^^^^^^^^^^ reference [..] RBSHoverBox#
#                            ^^^^^^^^^^^ reference [..] RBSHoverBox#
#                                        ^^^^^^^ reference [..] Integer#
 box.echo(1).abs
#^^^ reference local 9$119448696
#    ^^^^ reference [..] RBSHoverBox#echo().
#            ^^^ reference [..] Integer#abs().
 box.value.abs
#^^^ reference local 9$119448696
#    ^^^^^ reference [..] RBSHoverBox#value().
#          ^^^ reference [..] Integer#abs().
 box.generic(1, "a").upcase
#^^^ reference local 9$119448696
#    ^^^^^^^ reference [..] RBSHoverBox#generic().
#                    ^^^^^^ reference [..] String#upcase().
 RBSHoverFixed.new.echo(1).abs
#^^^^^^^^^^^^^ reference [..] RBSHoverFixed#
#              ^^^ reference [..] Class#new().
#                  ^^^^ reference [..] RBSHoverFixed#echo().
#                          ^^^ reference [..] Integer#abs().
