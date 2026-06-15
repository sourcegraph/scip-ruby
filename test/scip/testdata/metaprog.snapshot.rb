 # typed: false
 
 # Common metaprogramming constructs. Currently not specially handled by the
 # indexer (define_method body is a normal block; method_missing / respond_to_missing?
 # are normal method defs).
 
 class Dynamo
#      ^^^^^^ definition [..] Dynamo#
   define_method(:dynamic) do |x|
#  ^^^^^^^^^^^^^ reference [..] Module#define_method().
#                              ^ definition local 1$119448696
     x + 1
#    ^ reference local 1$119448696
   end
 
   def method_missing(name, *args, &blk)
#      ^^^^^^^^^^^^^^ definition [..] Dynamo#method_missing().
#                     ^^^^ definition local 1$2090704463
     "missed " + name.to_s
#                ^^^^ reference local 1$2090704463
#                     ^^^^ reference [..] Kernel#to_s().
   end
 
   def respond_to_missing?(name, include_private = false)
#      ^^^^^^^^^^^^^^^^^^^ definition [..] Dynamo#`respond_to_missing?`().
     true
   end
 end
 
 def use_meta
#    ^^^^^^^^ definition [..] Object#use_meta().
   Dynamo.new.dynamic(1)
#  ^^^^^^ reference [..] Dynamo#
#         ^^^ reference [..] Class#new().
   Dynamo.new.unknown_method
#  ^^^^^^ reference [..] Dynamo#
#         ^^^ reference [..] Class#new().
 end
