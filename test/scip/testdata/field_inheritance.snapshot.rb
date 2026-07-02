 # typed: true
 
 # First, check that instance variables are propagated through
 # the inheritance chain.
 
#⌄ enclosing_range_start [..] C1#
 class C1
#      ^^ definition [..] C1#
#  ⌄ enclosing_range_start [..] C1#`h=`().
#  ⌄ enclosing_range_start [..] C1#h().
   attr_accessor :h
#                 ^ definition [..] C1#`h=`().
#                 ^ definition [..] C1#h().
#                 ⌃ enclosing_range_end [..] C1#`h=`().
#                 ⌃ enclosing_range_end [..] C1#h().
#  ⌄ enclosing_range_start [..] C1#`i=`().
#  ⌄ enclosing_range_start [..] C1#i().
   attr_accessor :i
#                 ^ definition [..] C1#`i=`().
#                 ^ definition [..] C1#i().
#                 ⌃ enclosing_range_end [..] C1#`i=`().
#                 ⌃ enclosing_range_end [..] C1#i().
 
#  ⌄ enclosing_range_start [..] C1#set_ivar().
   def set_ivar
#      ^^^^^^^^ definition [..] C1#set_ivar().
     @f = 1
#    ^^ definition [..] C1#`@f`.
     return
   end
#    ⌃ enclosing_range_end [..] C1#set_ivar().
 end
#  ⌃ enclosing_range_end [..] C1#
 
#⌄ enclosing_range_start [..] C2#
 class C2 < C1
#      ^^ definition [..] C2#
#           ^^ reference [..] C1#
#  ⌄ enclosing_range_start [..] C2#get_inherited_ivar().
   def get_inherited_ivar
#      ^^^^^^^^^^^^^^^^^^ definition [..] C2#get_inherited_ivar().
     return @f + @h
#           ^^ reference [..] C2#`@f`.
#           relation definition=[..] C1#`@f`.
#                ^^ reference [..] C2#`@h`.
#                relation definition=[..] C1#`@h`.
   end
#    ⌃ enclosing_range_end [..] C2#get_inherited_ivar().
 
#  ⌄ enclosing_range_start [..] C2#set_inherited_ivar().
   def set_inherited_ivar
#      ^^^^^^^^^^^^^^^^^^ definition [..] C2#set_inherited_ivar().
     @f = 10
#    ^^ definition [..] C2#`@f`.
#    relation definition=[..] C1#`@f`.
     return
   end
#    ⌃ enclosing_range_end [..] C2#set_inherited_ivar().
 
#  ⌄ enclosing_range_start [..] C2#set_new_ivar().
   def set_new_ivar
#      ^^^^^^^^^^^^ definition [..] C2#set_new_ivar().
     @g = 1
#    ^^ definition [..] C2#`@g`.
     return
   end
#    ⌃ enclosing_range_end [..] C2#set_new_ivar().
 
#  ⌄ enclosing_range_start [..] C2#get_new_ivar().
   def get_new_ivar
#      ^^^^^^^^^^^^ definition [..] C2#get_new_ivar().
     return @g
#    ^^^^^^^^^ reference [..] C2#`@g`.
   end
#    ⌃ enclosing_range_end [..] C2#get_new_ivar().
 end
#  ⌃ enclosing_range_end [..] C2#
 
#⌄ enclosing_range_start [..] C3#
 class C3 < C2
#      ^^ definition [..] C3#
#           ^^ reference [..] C2#
#  ⌄ enclosing_range_start [..] C3#refs().
   def refs
#      ^^^^ definition [..] C3#refs().
     @f = @g + @i
#    ^^ definition [..] C3#`@f`.
#    relation definition=[..] C1#`@f`.
#         ^^ reference [..] C3#`@g`.
#         relation definition=[..] C2#`@g`.
#              ^^ reference [..] C3#`@i`.
#              relation definition=[..] C1#`@i`.
     return
   end
#    ⌃ enclosing_range_end [..] C3#refs().
 end
#  ⌃ enclosing_range_end [..] C3#
 
#⌄ enclosing_range_start [..] Object#c_check().
 def c_check
#    ^^^^^^^ definition [..] Object#c_check().
   C1.new.instance_variable_get(:@f)
#  ^^ reference [..] C1#
#     ^^^ reference [..] Class#new().
#         ^^^^^^^^^^^^^^^^^^^^^ reference [..] Kernel#instance_variable_get().
   C1.new.instance_variable_get(:@h)
#  ^^ reference [..] C1#
#     ^^^ reference [..] Class#new().
#         ^^^^^^^^^^^^^^^^^^^^^ reference [..] Kernel#instance_variable_get().
   C1.new.instance_variable_get(:@i)
#  ^^ reference [..] C1#
#     ^^^ reference [..] Class#new().
#         ^^^^^^^^^^^^^^^^^^^^^ reference [..] Kernel#instance_variable_get().
 
   C2.new.instance_variable_get(:@f)
#  ^^ reference [..] C2#
#     ^^^ reference [..] Class#new().
#         ^^^^^^^^^^^^^^^^^^^^^ reference [..] Kernel#instance_variable_get().
   C2.new.instance_variable_get(:@g)
#  ^^ reference [..] C2#
#     ^^^ reference [..] Class#new().
#         ^^^^^^^^^^^^^^^^^^^^^ reference [..] Kernel#instance_variable_get().
   C2.new.instance_variable_get(:@h)
#  ^^ reference [..] C2#
#     ^^^ reference [..] Class#new().
#         ^^^^^^^^^^^^^^^^^^^^^ reference [..] Kernel#instance_variable_get().
   C2.new.instance_variable_get(:@i)
#  ^^ reference [..] C2#
#     ^^^ reference [..] Class#new().
#         ^^^^^^^^^^^^^^^^^^^^^ reference [..] Kernel#instance_variable_get().
 
   C3.new.instance_variable_get(:@f)
#  ^^ reference [..] C3#
#     ^^^ reference [..] Class#new().
#         ^^^^^^^^^^^^^^^^^^^^^ reference [..] Kernel#instance_variable_get().
   C3.new.instance_variable_get(:@g)
#  ^^ reference [..] C3#
#     ^^^ reference [..] Class#new().
#         ^^^^^^^^^^^^^^^^^^^^^ reference [..] Kernel#instance_variable_get().
   C3.new.instance_variable_get(:@h)
#  ^^ reference [..] C3#
#     ^^^ reference [..] Class#new().
#         ^^^^^^^^^^^^^^^^^^^^^ reference [..] Kernel#instance_variable_get().
   C3.new.instance_variable_get(:@i)
#  ^^ reference [..] C3#
#     ^^^ reference [..] Class#new().
#         ^^^^^^^^^^^^^^^^^^^^^ reference [..] Kernel#instance_variable_get().
   return
 end
#  ⌃ enclosing_range_end [..] Object#c_check().
 
 # Now, check that class variables work as expected.
 
#⌄ enclosing_range_start [..] D1#
 class D1
#      ^^ definition [..] D1#
   @@d1_v = 0
#  ^^^^^^ definition [..] `<Class:D1>`#`@@d1_v`.
 
#  ⌄ enclosing_range_start [..] `<Class:D1>`#set_x().
   def self.set_x
#           ^^^^^ definition [..] `<Class:D1>`#set_x().
     @@d1_x = @@d1_v
#    ^^^^^^ definition [..] `<Class:D1>`#`@@d1_x`.
#             ^^^^^^ reference [..] `<Class:D1>`#`@@d1_v`.
     return
   end
#    ⌃ enclosing_range_end [..] `<Class:D1>`#set_x().
 
   # BUG: Emitting a definition for 'self' here seems wrong.
#  ⌄ enclosing_range_start [..] `<Class:D1>`#
   class << self
#           ^^^^ definition [..] `<Class:D1>`#
#    ⌄ enclosing_range_start [..] `<Class:D1>`#set_y().
     def set_y
#        ^^^^^ definition [..] `<Class:D1>`#set_y().
       @@d1_y = @@d1_v
#      ^^^^^^ definition [..] `<Class:D1>`#`@@d1_y`.
#      ^^^^^^^^^^^^^^^ reference [..] `<Class:D1>`#`@@d1_y`.
#               ^^^^^^ reference [..] `<Class:D1>`#`@@d1_v`.
     end
#      ⌃ enclosing_range_end [..] `<Class:D1>`#set_y().
   end
#    ⌃ enclosing_range_end [..] `<Class:D1>`#
 end
#  ⌃ enclosing_range_end [..] D1#
 
#⌄ enclosing_range_start [..] D2#
 class D2 < D1
#      ^^ definition [..] D2#
#           ^^ reference [..] D1#
#  ⌄ enclosing_range_start [..] `<Class:D2>`#get().
   def self.get
#           ^^^ definition [..] `<Class:D2>`#get().
     @@d2_x = @@d1_v + @@d1_x
#    ^^^^^^ definition [..] `<Class:D2>`#`@@d2_x`.
#             ^^^^^^ reference [..] `<Class:D2>`#`@@d1_v`.
#             relation definition=[..] `<Class:D1>`#`@@d1_v`.
#                      ^^^^^^ reference [..] `<Class:D2>`#`@@d1_x`.
#                      relation definition=[..] `<Class:D1>`#`@@d1_x`.
     @@d1_y + @@d1_z
#    ^^^^^^ reference [..] `<Class:D2>`#`@@d1_y`.
#    relation definition=[..] `<Class:D1>`#`@@d1_y`.
#             ^^^^^^ reference [..] `<Class:D2>`#`@@d1_z`.
     return
   end
#    ⌃ enclosing_range_end [..] `<Class:D2>`#get().
 end
#  ⌃ enclosing_range_end [..] D2#
 
#⌄ enclosing_range_start [..] D3#
 class D3 < D2
#      ^^ definition [..] D3#
#           ^^ reference [..] D2#
#  ⌄ enclosing_range_start [..] `<Class:D3>`#get_2().
   def self.get_2
#           ^^^^^ definition [..] `<Class:D3>`#get_2().
     @@d1_v + @@d1_x
#    ^^^^^^ reference [..] `<Class:D3>`#`@@d1_v`.
#    relation definition=[..] `<Class:D1>`#`@@d1_v`.
#             ^^^^^^ reference [..] `<Class:D3>`#`@@d1_x`.
#             relation definition=[..] `<Class:D1>`#`@@d1_x`.
     @@d1_y + @@d1_z
#    ^^^^^^ reference [..] `<Class:D3>`#`@@d1_y`.
#    relation definition=[..] `<Class:D1>`#`@@d1_y`.
#             ^^^^^^ reference [..] `<Class:D3>`#`@@d1_z`.
#             relation definition=[..] `<Class:D2>`#`@@d1_z`.
     @@d2_x
#    ^^^^^^ reference [..] `<Class:D3>`#`@@d2_x`.
#    relation definition=[..] `<Class:D2>`#`@@d2_x`.
     return
   end
#    ⌃ enclosing_range_end [..] `<Class:D3>`#get_2().
 end
#  ⌃ enclosing_range_end [..] D3#
 
#⌄ enclosing_range_start [..] Object#f().
 def f
#    ^ definition [..] Object#f().
   D2.class_variable_get(:@@d1_v)
#  ^^ reference [..] D2#
#     ^^^^^^^^^^^^^^^^^^ reference [..] Module#class_variable_get().
   D2.class_variable_get(:@@d1_x)
#  ^^ reference [..] D2#
#     ^^^^^^^^^^^^^^^^^^ reference [..] Module#class_variable_get().
   D2.class_variable_get(:@@d2_x)
#  ^^ reference [..] D2#
#     ^^^^^^^^^^^^^^^^^^ reference [..] Module#class_variable_get().
   D2.class_variable_get(:@@d1_y)
#  ^^ reference [..] D2#
#     ^^^^^^^^^^^^^^^^^^ reference [..] Module#class_variable_get().
   D2.class_variable_get(:@@d1_z)
#  ^^ reference [..] D2#
#     ^^^^^^^^^^^^^^^^^^ reference [..] Module#class_variable_get().
 
   D3.class_variable_get(:@@d1_v)
#  ^^ reference [..] D3#
#     ^^^^^^^^^^^^^^^^^^ reference [..] Module#class_variable_get().
   D3.class_variable_get(:@@d1_x)
#  ^^ reference [..] D3#
#     ^^^^^^^^^^^^^^^^^^ reference [..] Module#class_variable_get().
   D3.class_variable_get(:@@d2_x)
#  ^^ reference [..] D3#
#     ^^^^^^^^^^^^^^^^^^ reference [..] Module#class_variable_get().
   D3.class_variable_get(:@@d1_y)
#  ^^ reference [..] D3#
#     ^^^^^^^^^^^^^^^^^^ reference [..] Module#class_variable_get().
   D3.class_variable_get(:@@d1_z)
#  ^^ reference [..] D3#
#     ^^^^^^^^^^^^^^^^^^ reference [..] Module#class_variable_get().
   return
 end
#  ⌃ enclosing_range_end [..] Object#f().
 
 ## Check that pre-declared class variables work too
 
#⌄ enclosing_range_start [..] DD1#
 class DD1
#      ^^^ definition [..] DD1#
   @@x = T.let(0, Integer)
#  ^^^ definition [..] `<Class:DD1>`#`@@x`.
#  ^^^^^^^^^^^^^^^^^^^^^^^ reference [..] `<Class:DD1>`#`@@x`.
#                 ^^^^^^^ definition local 1$119448696
#                 ^^^^^^^ reference [..] Integer#
 end
#  ⌃ enclosing_range_end [..] DD1#
 
#⌄ enclosing_range_start [..] DD2#
 class DD2 < DD1
#      ^^^ definition [..] DD2#
#            ^^^ reference [..] DD1#
#  ⌄ enclosing_range_start [..] `<Class:DD2>`#get_x().
   def self.get_x
#           ^^^^^ definition [..] `<Class:DD2>`#get_x().
     @@x
#    ^^^ reference [..] `<Class:DD2>`#`@@x`.
#    relation definition=[..] `<Class:DD1>`#`@@x`.
   end
#    ⌃ enclosing_range_end [..] `<Class:DD2>`#get_x().
 end
#  ⌃ enclosing_range_end [..] DD2#
 
 # Class instance variables are not inherited.
 
#⌄ enclosing_range_start [..] E1#
 class E1
#      ^^ definition [..] E1#
   @x = 0
#  ^^ definition [..] `<Class:E1>`#`@x`.
 
#  ⌄ enclosing_range_start [..] `<Class:E1>`#set_x().
   def self.set_x
#           ^^^^^ definition [..] `<Class:E1>`#set_x().
     @x = @y
#    ^^ definition [..] `<Class:E1>`#`@x`.
#         ^^ reference [..] `<Class:E1>`#`@y`.
     return
   end
#    ⌃ enclosing_range_end [..] `<Class:E1>`#set_x().
 
#  ⌄ enclosing_range_start [..] `<Class:E1>`#set_y().
   def self.set_y
#           ^^^^^ definition [..] `<Class:E1>`#set_y().
     @y = 10
#    ^^ definition [..] `<Class:E1>`#`@y`.
     return
   end
#    ⌃ enclosing_range_end [..] `<Class:E1>`#set_y().
 end
#  ⌃ enclosing_range_end [..] E1#
 
#⌄ enclosing_range_start [..] E2#
 class E2 < E1
#      ^^ definition [..] E2#
#           ^^ reference [..] E1#
   @x = 0
#  ^^ definition [..] `<Class:E2>`#`@x`.
 
#  ⌄ enclosing_range_start [..] `<Class:E2>`#set_x_2().
   def self.set_x_2
#           ^^^^^^^ definition [..] `<Class:E2>`#set_x_2().
     @x = @y
#    ^^ definition [..] `<Class:E2>`#`@x`.
#         ^^ reference [..] `<Class:E2>`#`@y`.
     return
   end
#    ⌃ enclosing_range_end [..] `<Class:E2>`#set_x_2().
 
#  ⌄ enclosing_range_start [..] `<Class:E2>`#set_y_2().
   def self.set_y_2
#           ^^^^^^^ definition [..] `<Class:E2>`#set_y_2().
     @y = 10
#    ^^ definition [..] `<Class:E2>`#`@y`.
#    ^^^^^^^ reference [..] `<Class:E2>`#`@y`.
   end
#    ⌃ enclosing_range_end [..] `<Class:E2>`#set_y_2().
 end
#  ⌃ enclosing_range_end [..] E2#
 
 # Declared fields are inherited the same way as undeclared fields
 
#⌄ enclosing_range_start [..] F1#
 class F1
#      ^^ definition [..] F1#
#  ⌄ enclosing_range_start [..] F1#initialize().
   def initialize
#      ^^^^^^^^^^ definition [..] F1#initialize().
     @x = T.let(0, Integer)
#    ^^ definition [..] F1#`@x`.
#    ^^^^^^^^^^^^^^^^^^^^^^ reference [..] F1#`@x`.
#                  ^^^^^^^ definition local 1$3465713227
#                  ^^^^^^^ reference [..] Integer#
   end
#    ⌃ enclosing_range_end [..] F1#initialize().
 end
#  ⌃ enclosing_range_end [..] F1#
 
#⌄ enclosing_range_start [..] F2#
 class F2
#      ^^ definition [..] F2#
#  ⌄ enclosing_range_start [..] F2#get_x().
   def get_x
#      ^^^^^ definition [..] F2#get_x().
     @x
#    ^^ reference [..] F2#`@x`.
   end
#    ⌃ enclosing_range_end [..] F2#get_x().
 end
#  ⌃ enclosing_range_end [..] F2#
