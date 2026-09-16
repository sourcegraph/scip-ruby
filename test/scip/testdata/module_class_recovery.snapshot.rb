 # typed: true
 
 # Synthetic error-recovery case: including a class is invalid Ruby, but recovery
 # can retain Object in a module's ancestry. Indexing must not require the
 # experimental requires_ancestor feature for Object#class or #singleton_class.
#⌄ enclosing_range_start [..] ObjectAncestor#
 module ObjectAncestor
#       ^^^^^^^^^^^^^^ definition [..] ObjectAncestor#
   include Object
#  ^^^^^^^ reference [..] Module#include().
#          ^^^^^^ reference [..] Object#
#          ^^^^^^ reference [..] Object#
 
#  ⌄ enclosing_range_start [..] ObjectAncestor#marker().
   def marker
#      ^^^^^^ definition [..] ObjectAncestor#marker().
     :sample
   end
#    ⌃ enclosing_range_end [..] ObjectAncestor#marker().
 end
#  ⌃ enclosing_range_end [..] ObjectAncestor#
 
#⌄ enclosing_range_start [..] IndirectObjectAncestor#
 module IndirectObjectAncestor
#       ^^^^^^^^^^^^^^^^^^^^^^ definition [..] IndirectObjectAncestor#
   include ObjectAncestor
#  ^^^^^^^ reference [..] Module#include().
#          ^^^^^^^^^^^^^^ reference [..] ObjectAncestor#
#          ^^^^^^^^^^^^^^ reference [..] ObjectAncestor#
 end
#  ⌃ enclosing_range_end [..] IndirectObjectAncestor#
 
#⌄ enclosing_range_start [..] ToyRecord#
 class ToyRecord
#      ^^^^^^^^^ definition [..] ToyRecord#
   include IndirectObjectAncestor
#  ^^^^^^^ reference [..] Module#include().
#          ^^^^^^^^^^^^^^^^^^^^^^ reference [..] IndirectObjectAncestor#
#          ^^^^^^^^^^^^^^^^^^^^^^ reference [..] IndirectObjectAncestor#
 end
#  ⌃ enclosing_range_end [..] ToyRecord#
 
#⌄ enclosing_range_start [..] ClassQueries#
 class ClassQueries
#      ^^^^^^^^^^^^ definition [..] ClassQueries#
   extend T::Sig
#  ^^^^^^ reference [..] Kernel#extend().
 
   # The result must retain the module type so the marker call is indexed.
   sig { params(item: ObjectAncestor).returns(Symbol) }
#                     ^^^^^^^^^^^^^^ reference [..] ObjectAncestor#
#                                             ^^^^^^ reference [..] Symbol#
#  ⌄ enclosing_range_start [..] `<Class:ClassQueries>`#direct().
   def self.direct(item)
#           ^^^^^^ definition [..] `<Class:ClassQueries>`#direct().
#                  ^^^^ definition local 1$1608975516
     item.class.new.marker
#    ^^^^ reference local 1$1608975516
#               ^^^ reference [..] Class#new().
#                   ^^^^^^ reference [..] ObjectAncestor#marker().
   end
#    ⌃ enclosing_range_end [..] `<Class:ClassQueries>`#direct().
 
   sig { params(item: IndirectObjectAncestor).returns(Symbol) }
#                     ^^^^^^^^^^^^^^^^^^^^^^ reference [..] IndirectObjectAncestor#
#                                                     ^^^^^^ reference [..] Symbol#
#  ⌄ enclosing_range_start [..] `<Class:ClassQueries>`#indirect().
   def self.indirect(item)
#           ^^^^^^^^ definition [..] `<Class:ClassQueries>`#indirect().
#                    ^^^^ definition local 1$2847369447
     item.class.new.marker
#    ^^^^ reference local 1$2847369447
#               ^^^ reference [..] Class#new().
#                   ^^^^^^ reference [..] ObjectAncestor#marker().
   end
#    ⌃ enclosing_range_end [..] `<Class:ClassQueries>`#indirect().
 
   # singleton_class uses the same intrinsic as class.
   sig { params(item: ObjectAncestor).returns(T.nilable(String)) }
#                     ^^^^^^^^^^^^^^ reference [..] ObjectAncestor#
#                                                       ^^^^^^ reference [..] String#
#  ⌄ enclosing_range_start [..] `<Class:ClassQueries>`#singleton_label().
   def self.singleton_label(item)
#           ^^^^^^^^^^^^^^^ definition [..] `<Class:ClassQueries>`#singleton_label().
#                           ^^^^ definition local 1$1223203295
     item.singleton_class.name
#    ^^^^ reference local 1$1223203295
#                         ^^^^ reference [..] Class#name().
   end
#    ⌃ enclosing_range_end [..] `<Class:ClassQueries>`#singleton_label().
 
   # Ordinary class receivers should retain their existing behavior.
   sig { params(item: ToyRecord).returns(Symbol) }
#                     ^^^^^^^^^ reference [..] ToyRecord#
#                                        ^^^^^^ reference [..] Symbol#
#  ⌄ enclosing_range_start [..] `<Class:ClassQueries>`#concrete().
   def self.concrete(item)
#           ^^^^^^^^ definition [..] `<Class:ClassQueries>`#concrete().
#                    ^^^^ definition local 1$1914782654
     item.class.new.marker
#    ^^^^ reference local 1$1914782654
#               ^^^ reference [..] Class#new().
#                   ^^^^^^ reference [..] ObjectAncestor#marker().
   end
#    ⌃ enclosing_range_end [..] `<Class:ClassQueries>`#concrete().
 end
#  ⌃ enclosing_range_end [..] ClassQueries#
 
 ClassQueries.direct(ToyRecord.new)
#^^^^^^^^^^^^ reference [..] ClassQueries#
#             ^^^^^^ reference [..] `<Class:ClassQueries>`#direct().
#                    ^^^^^^^^^ reference [..] ToyRecord#
#                              ^^^ reference [..] Class#new().
 ClassQueries.indirect(ToyRecord.new)
#^^^^^^^^^^^^ reference [..] ClassQueries#
#             ^^^^^^^^ reference [..] `<Class:ClassQueries>`#indirect().
#                      ^^^^^^^^^ reference [..] ToyRecord#
#                                ^^^ reference [..] Class#new().
 ClassQueries.singleton_label(ToyRecord.new)
#^^^^^^^^^^^^ reference [..] ClassQueries#
#             ^^^^^^^^^^^^^^^ reference [..] `<Class:ClassQueries>`#singleton_label().
#                             ^^^^^^^^^ reference [..] ToyRecord#
#                                       ^^^ reference [..] Class#new().
 ClassQueries.concrete(ToyRecord.new)
#^^^^^^^^^^^^ reference [..] ClassQueries#
#             ^^^^^^^^ reference [..] `<Class:ClassQueries>`#concrete().
#                      ^^^^^^^^^ reference [..] ToyRecord#
#                                ^^^ reference [..] Class#new().
