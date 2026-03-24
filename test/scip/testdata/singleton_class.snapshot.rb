 # typed: true
 
 # Methods and class instance variables defined inside `class << self`.
 # Currently noted as "BUG: Emitting a definition for 'self' here seems wrong."
 # in field_inheritance.rb. This fixture captures the current behavior so a
 # future fix has a regression target.
 
#⌄ enclosing_range_start [..] K#
 class K
#      ^ definition [..] K#
#  ⌄ enclosing_range_start [..] `<Class:K>`#
   class << self
#           ^^^^ definition [..] `<Class:K>`#
#    ⌄ enclosing_range_start [..] `<Class:K>`#class_method().
     def class_method
#        ^^^^^^^^^^^^ definition [..] `<Class:K>`#class_method().
       @counter = 0
#      ^^^^^^^^ definition [..] `<Class:K>`#`@counter`.
#      ^^^^^^^^^^^^ reference [..] `<Class:K>`#`@counter`.
     end
#      ⌃ enclosing_range_end [..] `<Class:K>`#class_method().
 
#    ⌄ enclosing_range_start [..] `<Class:K>`#read_counter().
     def read_counter
#        ^^^^^^^^^^^^ definition [..] `<Class:K>`#read_counter().
       @counter
#      ^^^^^^^^ reference [..] `<Class:K>`#`@counter`.
     end
#      ⌃ enclosing_range_end [..] `<Class:K>`#read_counter().
 
#    ⌄ enclosing_range_start [..] `<Class:K>`#`name=`().
#    ⌄ enclosing_range_start [..] `<Class:K>`#name().
     attr_accessor :name
#                   ^^^^ definition [..] `<Class:K>`#`name=`().
#                   ^^^^ definition [..] `<Class:K>`#name().
#                      ⌃ enclosing_range_end [..] `<Class:K>`#`name=`().
#                      ⌃ enclosing_range_end [..] `<Class:K>`#name().
   end
#    ⌃ enclosing_range_end [..] `<Class:K>`#
 end
#  ⌃ enclosing_range_end [..] K#
 
#⌄ enclosing_range_start [..] Object#use_K().
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
#  ⌃ enclosing_range_end [..] Object#use_K().
