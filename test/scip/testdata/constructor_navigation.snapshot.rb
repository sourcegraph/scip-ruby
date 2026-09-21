 # typed: true
 
#⌄ enclosing_range_start [..] ConstructorParent#
 class ConstructorParent
#      ^^^^^^^^^^^^^^^^^ definition [..] ConstructorParent#
#  ⌄ enclosing_range_start [..] ConstructorParent#initialize().
   def initialize(value)
#      ^^^^^^^^^^ definition [..] ConstructorParent#initialize().
#                 ^^^^^ definition local 1$2244941930
     @value = value
#    ^^^^^^ definition [..] ConstructorParent#`@value`.
#    ^^^^^^^^^^^^^^ reference [..] ConstructorParent#`@value`.
#             ^^^^^ reference local 1$2244941930
   end
#    ⌃ enclosing_range_end [..] ConstructorParent#initialize().
 end
#  ⌃ enclosing_range_end [..] ConstructorParent#
 
#⌄ enclosing_range_start [..] ConstructorChild#
 class ConstructorChild < ConstructorParent
#      ^^^^^^^^^^^^^^^^ definition [..] ConstructorChild#
#                         ^^^^^^^^^^^^^^^^^ reference [..] ConstructorParent#
 end
#  ⌃ enclosing_range_end [..] ConstructorChild#
 
#⌄ enclosing_range_start [..] ConstructorOverride#
 class ConstructorOverride < ConstructorParent
#      ^^^^^^^^^^^^^^^^^^^ definition [..] ConstructorOverride#
#                            ^^^^^^^^^^^^^^^^^ reference [..] ConstructorParent#
#  ⌄ enclosing_range_start [..] `<Class:ConstructorOverride>`#new().
   def self.new(value)
#           ^^^ definition [..] `<Class:ConstructorOverride>`#new().
#               ^^^^^ definition local 1$2397702286
     super
   end
#    ⌃ enclosing_range_end [..] `<Class:ConstructorOverride>`#new().
 end
#  ⌃ enclosing_range_end [..] ConstructorOverride#
 
#⌄ enclosing_range_start [..] ConstructorEmpty#
 class ConstructorEmpty
#      ^^^^^^^^^^^^^^^^ definition [..] ConstructorEmpty#
 end
#  ⌃ enclosing_range_end [..] ConstructorEmpty#
 
 ConstructorParent.new('parent')
#^^^^^^^^^^^^^^^^^ reference [..] ConstructorParent#
#                  ^^^ reference [..] ConstructorParent#initialize().
 ConstructorChild.new('child')
#^^^^^^^^^^^^^^^^ reference [..] ConstructorChild#
#                 ^^^ reference [..] ConstructorParent#initialize().
 ConstructorOverride.new('override')
#^^^^^^^^^^^^^^^^^^^ reference [..] ConstructorOverride#
#                    ^^^ reference [..] `<Class:ConstructorOverride>`#new().
 ConstructorEmpty.new
#^^^^^^^^^^^^^^^^ reference [..] ConstructorEmpty#
#                 ^^^ reference [..] Class#new().
 Net::HTTP.new('localhost')
#^^^ reference [..] Net#
#     ^^^^ reference [..] Net#HTTP#
#          ^^^ reference [..] Net#HTTP#initialize().
 Gem::Version.new('1.2.3')
#^^^ reference [..] Gem#
#     ^^^^^^^ reference [..] Gem#Version#
#             ^^^ reference [..] Gem#Version#initialize().
