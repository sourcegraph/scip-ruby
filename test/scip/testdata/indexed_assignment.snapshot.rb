 # typed: true
 
 extend T::Sig
#^^^^^^ reference [..] Kernel#extend().
#       ^ reference [..] T#
#          ^^^ reference [..] T#Sig#
 
#⌄ enclosing_range_start [..] IndexedWriter#
 class IndexedWriter
#      ^^^^^^^^^^^^^ definition [..] IndexedWriter#
   extend T::Sig
#  ^^^^^^ reference [..] Kernel#extend().
 
   sig { params(key: Symbol, value: String).returns(String) }
#                    ^^^^^^ reference [..] Symbol#
#                                   ^^^^^^ reference [..] String#
#                                                   ^^^^^^ reference [..] String#
#  ⌄ enclosing_range_start [..] IndexedWriter#`[]=`().
   def []=(key, value)
#      ^^^ definition [..] IndexedWriter#`[]=`().
#               ^^^^^ definition local 1$1459296072
     value
#    ^^^^^ reference local 1$1459296072
   end
#    ⌃ enclosing_range_end [..] IndexedWriter#`[]=`().
 end
#  ⌃ enclosing_range_end [..] IndexedWriter#
 
 sig { params(hash: T::Hash[Symbol, String], array: T::Array[String], writer: IndexedWriter, value: String).void }
#^^^ reference [..] T#Sig#sig().
#      ^^^^^^ reference [..] T#Private#Methods#DeclBuilder#params().
#                   ^ reference [..] T#
#                      ^^^^ reference [..] T#Hash#
#                           ^^^^^^ reference [..] Symbol#
#                                   ^^^^^^ reference [..] String#
#                                                   ^ reference [..] T#
#                                                      ^^^^^ reference [..] T#Array#
#                                                            ^^^^^^ reference [..] String#
#                                                                             ^^^^^^^^^^^^^ reference [..] IndexedWriter#
#                                                                                                   ^^^^^^ reference [..] String#
#                                                                                                           ^^^^ reference [..] T#Private#Methods#DeclBuilder#void().
#⌄ enclosing_range_start [..] Object#indexed_assignment().
 def indexed_assignment(hash, array, writer, value)
#    ^^^^^^^^^^^^^^^^^^ definition [..] Object#indexed_assignment().
#                       ^^^^ definition local 1$604258566
#                             ^^^^^ definition local 2$604258566
#                                    ^^^^^^ definition local 3$604258566
#                                            ^^^^^ definition local 4$604258566
   hash[:key] = value
#  ^^^^ reference local 1$604258566
#      ^ reference [..] Hash#`[]=`().
#               ^^^^^ reference local 4$604258566
   array[0] = value
#  ^^^^^ reference local 2$604258566
#       ^ reference [..] Array#`[]=`().
#             ^^^^^ reference local 4$604258566
   writer[:key] = value
#  ^^^^^^ reference local 3$604258566
#        ^ reference [..] IndexedWriter#`[]=`().
#                 ^^^^^ reference local 4$604258566
   hash.[]=(:explicit, value)
#  ^^^^ reference local 1$604258566
#       ^^^ reference [..] Hash#`[]=`().
#                      ^^^^^ reference local 4$604258566
   hash[:default] ||= value
#  ^^^^^^^^^^^^^^ reference local 1$604258566
#                     ^^^^^ reference local 4$604258566
   hash[
#  ^^^^ reference local 1$604258566
#      ^ reference [..] Hash#`[]=`().
     :multiline
   ] = value
#      ^^^^^ reference local 4$604258566
 end
#  ⌃ enclosing_range_end [..] Object#indexed_assignment().
