 # typed: true
 # Adapted from test/testdata/infer/call_with_block.rb.
 
#⌄ enclosing_range_start [..] WrappedCalls#
 class WrappedCalls
#      ^^^^^^^^^^^^ definition [..] WrappedCalls#
   extend T::Sig
#  ^^^^^^ reference [..] Kernel#extend().
 
   sig { params(value: Integer, blk: T.proc.returns(Integer)).returns(Integer) }
#                      ^^^^^^^ reference [..] Integer#
#                                                   ^^^^^^^ reference [..] Integer#
#                                                                     ^^^^^^^ reference [..] Integer#
#  ⌄ enclosing_range_start [..] WrappedCalls#target().
   def target(value, &blk)
#      ^^^^^^ definition [..] WrappedCalls#target().
#             ^^^^^ definition local 1$845187144
#                     ^^^ definition local 2$845187144
     value + blk.call
#    ^^^^^ reference local 1$845187144
#          ^ reference [..] Integer#+().
#            ^^^ reference local 2$845187144
#                ^^^^ reference [..] Proc0#call().
   end
#    ⌃ enclosing_range_end [..] WrappedCalls#target().
 
   sig { params(value: Integer, blk: T.nilable(T.proc.returns(Integer))).returns(Integer) }
#                      ^^^^^^^ reference [..] Integer#
#                                                             ^^^^^^^ reference [..] Integer#
#                                                                                ^^^^^^^ reference [..] Integer#
#  ⌄ enclosing_range_start [..] WrappedCalls#plain().
   def plain(value, &blk)
#      ^^^^^ definition [..] WrappedCalls#plain().
#            ^^^^^ definition local 1$3552460647
     value
#    ^^^^^ reference local 1$3552460647
   end
#    ⌃ enclosing_range_end [..] WrappedCalls#plain().
 
   sig { params(value: Integer, blk: T.proc.params(value: Integer).returns(String)).returns(String) }
#                      ^^^^^^^ reference [..] Integer#
#                                                         ^^^^^^^ reference [..] Integer#
#                                                                          ^^^^^^ reference [..] String#
#                                                                                           ^^^^^^ reference [..] String#
#  ⌄ enclosing_range_start [..] WrappedCalls#convert().
   def convert(value, &blk)
#      ^^^^^^^ definition [..] WrappedCalls#convert().
#              ^^^^^ definition local 1$1647949432
#                      ^^^ definition local 2$1647949432
     blk.call(value)
#    ^^^ reference local 2$1647949432
#        ^^^^ reference [..] Proc1#call().
#             ^^^^^ reference local 1$1647949432
   end
#    ⌃ enclosing_range_end [..] WrappedCalls#convert().
 
   sig { params(other: WrappedCalls, value: Integer, blk: T.proc.returns(Integer)).void }
#                      ^^^^^^^^^^^^ reference [..] WrappedCalls#
#                                           ^^^^^^^ reference [..] Integer#
#                                                                        ^^^^^^^ reference [..] Integer#
#  ⌄ enclosing_range_start [..] WrappedCalls#named().
   def named(other, value, &blk)
#      ^^^^^ definition [..] WrappedCalls#named().
#            ^^^^^ definition local 1$3555021734
#                   ^^^^^ definition local 2$3555021734
#                           ^^^ definition local 3$3555021734
     target(value, &blk)
#    ^^^^^^ reference [..] WrappedCalls#target().
#           ^^^^^ reference local 2$3555021734
#                   ^^^ reference local 3$3555021734
     other.target(value, &blk)
#    ^^^^^ reference local 1$3555021734
#          ^^^^^^ reference [..] WrappedCalls#target().
#                 ^^^^^ reference local 2$3555021734
#                         ^^^ reference local 3$3555021734
     target(*[value], &blk)
#    ^^^^^^ reference [..] WrappedCalls#target().
#             ^^^^^ reference local 2$3555021734
#                      ^^^ reference local 3$3555021734
     other.target(*[value], &blk)
#    ^^^^^ reference local 1$3555021734
#          ^^^^^^ reference [..] WrappedCalls#target().
#                   ^^^^^ reference local 2$3555021734
#                            ^^^ reference local 3$3555021734
     target(*[value]) { blk.call }
#    ^^^^^^ reference [..] WrappedCalls#target().
#             ^^^^^ reference local 2$3555021734
#                       ^^^ reference local 3$3555021734
#                           ^^^^ reference [..] Proc0#call().
     other.target(*[value]) { blk.call }
#    ^^^^^ reference local 1$3555021734
#          ^^^^^^ reference [..] WrappedCalls#target().
#                   ^^^^^ reference local 2$3555021734
#                             ^^^ reference local 3$3555021734
#                                 ^^^^ reference [..] Proc0#call().
     other.plain(*[value])
#    ^^^^^ reference local 1$3555021734
#          ^^^^^ reference [..] WrappedCalls#plain().
#                  ^^^^^ reference local 2$3555021734
     other.plain(value, &nil)
#    ^^^^^ reference local 1$3555021734
#          ^^^^^ reference [..] WrappedCalls#plain().
#                ^^^^^ reference local 2$3555021734
     other.plain(*[value], &nil)
#    ^^^^^ reference local 1$3555021734
#          ^^^^^ reference [..] WrappedCalls#plain().
#                  ^^^^^ reference local 2$3555021734
 
     other.target(
#    ^^^^^ reference local 1$3555021734
#          ^^^^^^ reference [..] WrappedCalls#target().
       *[value],
#        ^^^^^ reference local 2$3555021734
       &blk
#       ^^^ reference local 3$3555021734
     )
   end
#    ⌃ enclosing_range_end [..] WrappedCalls#named().
 
   sig { params("&": T.proc.returns(Integer)).void }
#                                   ^^^^^^^ reference [..] Integer#
#  ⌄ enclosing_range_start [..] WrappedCalls#anonymous().
   def anonymous(&)
#      ^^^^^^^^^ definition [..] WrappedCalls#anonymous().
#                ^ definition local 1$1926879790
     target(1, &)
#    ^^^^^^ reference [..] WrappedCalls#target().
     target(*[1], &)
#    ^^^^^^ reference [..] WrappedCalls#target().
   end
#    ⌃ enclosing_range_end [..] WrappedCalls#anonymous().
 
   sig { params(value: Integer).void }
#                      ^^^^^^^ reference [..] Integer#
#  ⌄ enclosing_range_start [..] WrappedCalls#symbols().
   def symbols(value)
#      ^^^^^^^ definition [..] WrappedCalls#symbols().
#              ^^^^^ definition local 1$3064037894
     convert(*[value], &:to_s)
#    ^^^^^^^ reference [..] WrappedCalls#convert().
#              ^^^^^ reference local 1$3064037894
#                        ^^^^ reference [..] Integer#to_s().
     convert(*[value], &:"to_s")
#    ^^^^^^^ reference [..] WrappedCalls#convert().
#              ^^^^^ reference local 1$3064037894
#                         ^^^^ reference [..] Integer#to_s().
     convert(*[value], &:'to_s')
#    ^^^^^^^ reference [..] WrappedCalls#convert().
#              ^^^^^ reference local 1$3064037894
#                         ^^^^ reference [..] Integer#to_s().
   end
#    ⌃ enclosing_range_end [..] WrappedCalls#symbols().
 
   sig { params(array: T::Array[Integer], value: Integer).void }
#                               ^^^^^^^ reference [..] Integer#
#                                                ^^^^^^^ reference [..] Integer#
#  ⌄ enclosing_range_start [..] WrappedCalls#indexed().
   def indexed(array, value)
#      ^^^^^^^ definition [..] WrappedCalls#indexed().
#              ^^^^^ definition local 1$2514986346
#                     ^^^^^ definition local 2$2514986346
     array[0]
#    ^^^^^ reference local 1$2514986346
#         ^ reference [..] Array#`[]`().
     array[*[0]]
#    ^^^^^ reference local 1$2514986346
#         ^ reference [..] Array#`[]`().
     array.[](*[0])
#    ^^^^^ reference local 1$2514986346
#          ^^ reference [..] Array#`[]`().
     array[*[0]] = value
#    ^^^^^ reference local 1$2514986346
#         ^ reference [..] Array#`[]=`().
     array.[]=(*[0, value])
#    ^^^^^ reference local 1$2514986346
#          ^^^ reference [..] Array#`[]=`().
#                   ^^^^^ reference local 2$2514986346
   end
#    ⌃ enclosing_range_end [..] WrappedCalls#indexed().
 
   sig { params(other: T.untyped, blk: T.proc.returns(Integer)).void }
#                                                     ^^^^^^^ reference [..] Integer#
#  ⌄ enclosing_range_start [..] WrappedCalls#unresolved().
   def unresolved(other, &blk)
#      ^^^^^^^^^^ definition [..] WrappedCalls#unresolved().
#                 ^^^^^ definition local 1$1886494218
#                         ^^^ definition local 2$1886494218
     other.target(1, &blk)
#    ^^^^^ reference local 1$1886494218
#                     ^^^ reference local 2$1886494218
     other.target(*[1], &blk)
#    ^^^^^ reference local 1$1886494218
#                        ^^^ reference local 2$1886494218
     other.target(*[1]) { blk.call }
#    ^^^^^ reference local 1$1886494218
#                         ^^^ reference local 2$1886494218
#                             ^^^^ reference [..] Proc0#call().
   end
#    ⌃ enclosing_range_end [..] WrappedCalls#unresolved().
 end
#  ⌃ enclosing_range_end [..] WrappedCalls#
