 # typed: true
 
 # First, check that instance variables are propagated through
 # the inheritance chain.
 
 class C1
#      ^^ definition [..] C1#
   attr_accessor :h
#                 ^ definition [..] C1#`h=`().
#                 ^ definition [..] C1#h().
   attr_accessor :i
#                 ^ definition [..] C1#`i=`().
#                 ^ definition [..] C1#i().
 
   def set_ivar
#      ^^^^^^^^ definition [..] C1#set_ivar().
     @f = 1
#    ^^ definition [..] C1#`@f`.
     return
   end
 end
 
 class C2 < C1
#      ^^ definition [..] C2#
#           ^^ definition [..] C1#
   def get_inherited_ivar
#      ^^^^^^^^^^^^^^^^^^ definition [..] C2#get_inherited_ivar().
     return @f + @h
#           ^^ reference [..] C2#`@f`.
#           relation definition=[..] C1#`@f`.
#                ^^ reference [..] C2#`@h`.
#                relation definition=[..] C1#`@h`.
   end
 
   def set_inherited_ivar
#      ^^^^^^^^^^^^^^^^^^ definition [..] C2#set_inherited_ivar().
     @f = 10
#    ^^ definition [..] C2#`@f`.
#    relation definition=[..] C1#`@f`.
     return
   end
 
   def set_new_ivar
#      ^^^^^^^^^^^^ definition [..] C2#set_new_ivar().
     @g = 1
#    ^^ definition [..] C2#`@g`.
     return
   end
 
   def get_new_ivar
#      ^^^^^^^^^^^^ definition [..] C2#get_new_ivar().
     return @g
#    ^^^^^^^^^ reference [..] C2#`@g`.
   end
 end
 
 class C3 < C2
#      ^^ definition [..] C3#
#           ^^ definition [..] C2#
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
 end
 
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
 
 # Now, check that class variables work as expected.
 
 class D1
#      ^^ definition [..] D1#
   @@d1_v = 0
#  ^^^^^^ definition [..] `<Class:D1>`#`@@d1_v`.
 
   def self.set_x
#           ^^^^^ definition [..] `<Class:D1>`#set_x().
     @@d1_x = @@d1_v
#    ^^^^^^ definition [..] `<Class:D1>`#`@@d1_x`.
#             ^^^^^^ reference [..] `<Class:D1>`#`@@d1_v`.
     return
   end
 
   class << self
     def set_y
#        ^^^^^ definition [..] `<Class:D1>`#set_y().
       @@d1_y = @@d1_v
#      ^^^^^^ definition [..] `<Class:D1>`#`@@d1_y`.
#      ^^^^^^^^^^^^^^^ reference [..] `<Class:D1>`#`@@d1_y`.
#               ^^^^^^ reference [..] `<Class:D1>`#`@@d1_v`.
     end
   end
 end
 
 class D2 < D1
#      ^^ definition [..] D2#
#           ^^ definition [..] D1#
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
 end
 
 class D3 < D2
#      ^^ definition [..] D3#
#           ^^ definition [..] D2#
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
 end
 
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
 
 # Class instance variables are not inherited.
 
 class E1
#      ^^ definition [..] E1#
   @x = 0
#  ^^ definition [..] `<Class:E1>`#`@x`.
 
   def self.set_x
#           ^^^^^ definition [..] `<Class:E1>`#set_x().
     @x = @y
#    ^^ definition [..] `<Class:E1>`#`@x`.
#         ^^ reference [..] `<Class:E1>`#`@y`.
     return
   end
 
   def self.set_y
#           ^^^^^ definition [..] `<Class:E1>`#set_y().
     @y = 10
#    ^^ definition [..] `<Class:E1>`#`@y`.
     return
   end
 end
 
 class E2 < E1
#      ^^ definition [..] E2#
#           ^^ definition [..] E1#
   @x = 0
#  ^^ definition [..] `<Class:E2>`#`@x`.
 
   def self.set_x_2
#           ^^^^^^^ definition [..] `<Class:E2>`#set_x_2().
     @x = @y
#    ^^ definition [..] `<Class:E2>`#`@x`.
#         ^^ reference [..] `<Class:E2>`#`@y`.
     return
   end
 
   def self.set_y_2
#           ^^^^^^^ definition [..] `<Class:E2>`#set_y_2().
     @y = 10
#    ^^ definition [..] `<Class:E2>`#`@y`.
#    ^^^^^^^ reference [..] `<Class:E2>`#`@y`.
   end
 end
