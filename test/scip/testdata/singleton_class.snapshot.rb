 # typed: true
 
 # Methods and class instance variables defined inside `class << self`.
 # Currently noted as "BUG: Emitting a definition for 'self' here seems wrong."
 # in field_inheritance.rb. This fixture captures the current behavior so a
 # future fix has a regression target.
 
 class K
#      ^ definition [..] K#
   class << self
#           ^^^^ definition [..] `<Class:K>`#
     def class_method
#        ^^^^^^^^^^^^ definition [..] `<Class:K>`#class_method().
       @counter = 0
#      ^^^^^^^^ definition [..] `<Class:K>`#`@counter`.
#      ^^^^^^^^^^^^ reference [..] `<Class:K>`#`@counter`.
     end
 
     def read_counter
#        ^^^^^^^^^^^^ definition [..] `<Class:K>`#read_counter().
       @counter
#      ^^^^^^^^ reference [..] `<Class:K>`#`@counter`.
     end
 
     attr_accessor :name
#                   ^^^^ definition [..] `<Class:K>`#`name=`().
#                   ^^^^ definition [..] `<Class:K>`#name().
   end
 end
 
 def use_K
#    ^^^^^ definition [..] Object#use_K().
   K.class_method
#  ^ reference [..] K#
#    ^^^^^^^^^^^^ reference [..] `<Class:K>`#class_method().
   _ = K.read_counter
#  ^ definition local 2$2530843406
#      ^ reference [..] K#
#        ^^^^^^^^^^^^ reference [..] `<Class:K>`#read_counter().
   K.name = "k"
#  ^ reference [..] K#
#    ^^^^^^ reference [..] `<Class:K>`#`name=`().
   _ = K.name
#  ^ reference (write) local 2$2530843406
#      ^ reference [..] K#
#        ^^^^ reference [..] `<Class:K>`#name().
   return
 end
