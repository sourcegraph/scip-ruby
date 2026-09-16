 # typed: true
 # Adapted from resolver/sig_anon_block.rb and desugar/forwarded_restarg_and_kwrestarg.rb.
 
#⌄ enclosing_range_start [..] AnonymousForwarding#
 class AnonymousForwarding
#      ^^^^^^^^^^^^^^^^^^^ definition [..] AnonymousForwarding#
   extend T::Sig
#  ^^^^^^ reference [..] Kernel#extend().
 
   sig { params(block: T.proc.returns(Integer)).returns(Integer) }
#                                     ^^^^^^^ reference [..] Integer#
#                                                       ^^^^^^^ reference [..] Integer#
#  ⌄ enclosing_range_start [..] AnonymousForwarding#accept_block().
   def accept_block(&block)
#      ^^^^^^^^^^^^ definition [..] AnonymousForwarding#accept_block().
#                    ^^^^^ definition local 1$1148434151
     block.call
#    ^^^^^ reference local 1$1148434151
#          ^^^^ reference [..] Proc0#call().
   end
#    ⌃ enclosing_range_end [..] AnonymousForwarding#accept_block().
 
   sig { params(kwargs: Integer).void }
#                       ^^^^^^^ reference [..] Integer#
#  ⌄ enclosing_range_start [..] AnonymousForwarding#accept_keywords().
   def accept_keywords(**kwargs)
#      ^^^^^^^^^^^^^^^ definition [..] AnonymousForwarding#accept_keywords().
#                        ^^^^^^ definition local 1$1743206494
     kwargs.keys
#    ^^^^^^ reference local 1$1743206494
#           ^^^^ reference [..] Hash#keys().
   end
#    ⌃ enclosing_range_end [..] AnonymousForwarding#accept_keywords().
 
#  ⌄ enclosing_range_start [..] AnonymousForwarding#accept_all().
   def accept_all(*values, **kwargs, &block)
#      ^^^^^^^^^^ definition [..] AnonymousForwarding#accept_all().
#                  ^^^^^^ definition local 1$1086838521
#                            ^^^^^^ definition local 2$1086838521
#                                     ^^^^^ definition local 3$1086838521
     values
     kwargs
     block
#    ^^^^^ reference local 3$1086838521
   end
#    ⌃ enclosing_range_end [..] AnonymousForwarding#accept_all().
 
   sig { params("&": T.proc.returns(Integer)).void }
#                                   ^^^^^^^ reference [..] Integer#
#  ⌄ enclosing_range_start [..] AnonymousForwarding#block().
   def block(&)
#      ^^^^^ definition [..] AnonymousForwarding#block().
#            ^ definition local 1$3943480674
     accept_block(&)
#    ^^^^^^^^^^^^ reference [..] AnonymousForwarding#accept_block().
#                 ^ reference local 1$3943480674
     accept_block(&)
#    ^^^^^^^^^^^^ reference [..] AnonymousForwarding#accept_block().
#                 ^ reference local 1$3943480674
     [1].each { accept_block(&) }
#               ^^^^^^^^^^^^ reference [..] AnonymousForwarding#accept_block().
#                            ^ reference local 1$3943480674
     accept_block(
#    ^^^^^^^^^^^^ reference [..] AnonymousForwarding#accept_block().
       & # Forward the anonymous block.
#      ^ reference local 1$3943480674
     )
   end
#    ⌃ enclosing_range_end [..] AnonymousForwarding#block().
 
   sig { params("&": T.proc.returns(Integer)).void }
#                                   ^^^^^^^ reference [..] Integer#
#  ⌄ enclosing_range_start [..] AnonymousForwarding#another_block().
   def another_block(&)
#      ^^^^^^^^^^^^^ definition [..] AnonymousForwarding#another_block().
#                    ^ definition local 1$163266790
     accept_block(&)
#    ^^^^^^^^^^^^ reference [..] AnonymousForwarding#accept_block().
#                 ^ reference local 1$163266790
   end
#    ⌃ enclosing_range_end [..] AnonymousForwarding#another_block().
 
   sig { params("**": Integer).void }
#                     ^^^^^^^ reference [..] Integer#
#  ⌄ enclosing_range_start [..] AnonymousForwarding#keywords().
   def keywords(**)
#      ^^^^^^^^ definition [..] AnonymousForwarding#keywords().
#               ^^ definition local 1$4210524501
     accept_keywords(**)
#    ^^^^^^^^^^^^^^^ reference [..] AnonymousForwarding#accept_keywords().
#                    ^^ reference local 1$4210524501
     T.unsafe(self).accept_keywords(extra: 1, **)
#    ^ reference [..] T#
#      ^^^^^^ reference [..] `<Class:T>`#unsafe().
#                                             ^^ reference local 1$4210524501
     T.unsafe(self).accept_keywords(**, extra: 1)
#    ^ reference [..] T#
#      ^^^^^^ reference [..] `<Class:T>`#unsafe().
#                                   ^^ reference local 1$4210524501
     [1].each { accept_keywords(**) }
#               ^^^^^^^^^^^^^^^ reference [..] AnonymousForwarding#accept_keywords().
#                               ^^ reference local 1$4210524501
     T.unsafe(self).accept_keywords(
#    ^ reference [..] T#
#      ^^^^^^ reference [..] `<Class:T>`#unsafe().
       extra: 1,
       ** # Forward the anonymous keywords.
#      ^^ reference local 1$4210524501
     )
   end
#    ⌃ enclosing_range_end [..] AnonymousForwarding#keywords().
 
   sig { params("*": Integer).void }
#                    ^^^^^^^ reference [..] Integer#
#  ⌄ enclosing_range_start [..] AnonymousForwarding#positional().
   def positional(*)
#      ^^^^^^^^^^ definition [..] AnonymousForwarding#positional().
#                 ^ definition local 1$1639687079
     T.unsafe(self).accept_all(*)
#    ^ reference [..] T#
#      ^^^^^^ reference [..] `<Class:T>`#unsafe().
#                              ^ reference local 1$1639687079
     T.unsafe(self).accept_all("* ** & ...", *)
#    ^ reference [..] T#
#      ^^^^^^ reference [..] `<Class:T>`#unsafe().
#                                            ^ reference local 1$1639687079
     [1].each { T.unsafe(self).accept_all(*) }
#               ^ reference [..] T#
#                 ^^^^^^ reference [..] `<Class:T>`#unsafe().
#                                         ^ reference local 1$1639687079
     T.unsafe(self).accept_all(
#    ^ reference [..] T#
#      ^^^^^^ reference [..] `<Class:T>`#unsafe().
       "* ** & ...", # These are not forwarding tokens.
       *
#      ^ reference local 1$1639687079
     )
   end
#    ⌃ enclosing_range_end [..] AnonymousForwarding#positional().
 
   sig { params("*": Integer, "**": Integer, "&": T.proc.returns(Integer)).void }
#                    ^^^^^^^ reference [..] Integer#
#                                   ^^^^^^^ reference [..] Integer#
#                                                                ^^^^^^^ reference [..] Integer#
#  ⌄ enclosing_range_start [..] AnonymousForwarding#combined().
   def combined(*, **, &)
#      ^^^^^^^^ definition [..] AnonymousForwarding#combined().
#               ^ definition local 1$3855757226
#                  ^^ definition local 2$3855757226
#                      ^ definition local 3$3855757226
     T.unsafe(self).accept_all(*, **, &)
#    ^ reference [..] T#
#      ^^^^^^ reference [..] `<Class:T>`#unsafe().
#                              ^ reference local 1$3855757226
#                                 ^^ reference local 2$3855757226
#                                     ^ reference local 3$3855757226
     T.unsafe(self).accept_all(
#    ^ reference [..] T#
#      ^^^^^^ reference [..] `<Class:T>`#unsafe().
       *,
#      ^ reference local 1$3855757226
       **,
#      ^^ reference local 2$3855757226
       &
#      ^ reference local 3$3855757226
     )
   end
#    ⌃ enclosing_range_end [..] AnonymousForwarding#combined().
 
#  ⌄ enclosing_range_start [..] AnonymousForwarding#forwarding().
   def forwarding(...)
#      ^^^^^^^^^^ definition [..] AnonymousForwarding#forwarding().
#                 ^^^ definition local 1$4262060774
     accept_all(...)
#    ^^^^^^^^^^ reference [..] AnonymousForwarding#accept_all().
#               ^^^ reference local 1$4262060774
     T.unsafe(self).accept_all("...", ...)
#    ^ reference [..] T#
#      ^^^^^^ reference [..] `<Class:T>`#unsafe().
#                                     ^^^ reference local 1$4262060774
     [1].each { accept_all(...) }
#               ^^^^^^^^^^ reference [..] AnonymousForwarding#accept_all().
#                          ^^^ reference local 1$4262060774
     T.unsafe(self).accept_all(
#    ^ reference [..] T#
#      ^^^^^^ reference [..] `<Class:T>`#unsafe().
       "* ** & ...", # These are not forwarding tokens.
       ...
#      ^^^ reference local 1$4262060774
     )
   end
#    ⌃ enclosing_range_end [..] AnonymousForwarding#forwarding().
 
#  ⌄ enclosing_range_start [..] AnonymousForwarding#another_forwarding().
   def another_forwarding(...)
#      ^^^^^^^^^^^^^^^^^^ definition [..] AnonymousForwarding#another_forwarding().
#                         ^^^ definition local 1$205483698
     accept_all(...)
#    ^^^^^^^^^^ reference [..] AnonymousForwarding#accept_all().
#               ^^^ reference local 1$205483698
   end
#    ⌃ enclosing_range_end [..] AnonymousForwarding#another_forwarding().
 
#  ⌄ enclosing_range_start [..] AnonymousForwarding#unused().
   def unused(*, **, &)
#      ^^^^^^ definition [..] AnonymousForwarding#unused().
#             ^ definition local 1$2244945947
#                ^^ definition local 2$2244945947
#                    ^ definition local 3$2244945947
   end
#    ⌃ enclosing_range_end [..] AnonymousForwarding#unused().
 
#  ⌄ enclosing_range_start [..] AnonymousForwarding#no_keywords().
   def no_keywords(**nil)
#      ^^^^^^^^^^^ definition [..] AnonymousForwarding#no_keywords().
   end
#    ⌃ enclosing_range_end [..] AnonymousForwarding#no_keywords().
 
#  ⌄ enclosing_range_start [..] AnonymousForwarding#named().
   def named(*values, **kwargs, &block)
#      ^^^^^ definition [..] AnonymousForwarding#named().
#             ^^^^^^ definition local 1$3555021734
#                       ^^^^^^ definition local 2$3555021734
#                                ^^^^^ definition local 3$3555021734
     T.unsafe(self).accept_all(*values, **kwargs, &block)
#    ^ reference [..] T#
#      ^^^^^^ reference [..] `<Class:T>`#unsafe().
#                                         ^^^^^^ reference local 2$3555021734
#                                                  ^^^^^ reference local 3$3555021734
   end
#    ⌃ enclosing_range_end [..] AnonymousForwarding#named().
 end
#  ⌃ enclosing_range_end [..] AnonymousForwarding#
