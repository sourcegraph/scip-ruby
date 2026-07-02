 # typed: strong
 
 # At `typed: strong` Sorbet requires that nothing be T.untyped. Locks in
 # indexer behavior for fully-typed code.
 
#⌄ enclosing_range_start [..] StrongClass#
 class StrongClass
#      ^^^^^^^^^^^ definition [..] StrongClass#
   extend T::Sig
#  ^^^^^^ reference [..] Kernel#extend().
 
   sig { params(x: Integer).returns(Integer) }
#                  ^^^^^^^ reference [..] Integer#
#                                   ^^^^^^^ reference [..] Integer#
#  ⌄ enclosing_range_start [..] StrongClass#add_one().
   def add_one(x)
#      ^^^^^^^ definition [..] StrongClass#add_one().
#              ^ definition local 1$272034907
     x + 1
#    ^ reference local 1$272034907
#      ^ reference [..] Integer#+().
   end
#    ⌃ enclosing_range_end [..] StrongClass#add_one().
 
   sig { params(x: String).returns(String) }
#                  ^^^^^^ reference [..] String#
#                                  ^^^^^^ reference [..] String#
#  ⌄ enclosing_range_start [..] StrongClass#shout().
   def shout(x)
#      ^^^^^ definition [..] StrongClass#shout().
#            ^ definition local 1$3089998242
     x.upcase
#    ^ reference local 1$3089998242
#      ^^^^^^ reference [..] String#upcase().
   end
#    ⌃ enclosing_range_end [..] StrongClass#shout().
 end
#  ⌃ enclosing_range_end [..] StrongClass#
 
#⌄ enclosing_range_start [..] StrongUse#
 class StrongUse
#      ^^^^^^^^^ definition [..] StrongUse#
   extend T::Sig
#  ^^^^^^ reference [..] Kernel#extend().
 
   sig { void }
#  ⌄ enclosing_range_start [..] StrongUse#call_them().
   def call_them
#      ^^^^^^^^^ definition [..] StrongUse#call_them().
     s = StrongClass.new
#    ^ definition local 1$1369514212
#        ^^^^^^^^^^^ reference [..] StrongClass#
#                    ^^^ reference [..] Class#new().
     _ = s.add_one(1)
#    ^ definition local 3$1369514212
#        ^ reference local 1$1369514212
#          ^^^^^^^ reference [..] StrongClass#add_one().
     _ = s.shout("hi")
#    ^ reference (write) local 3$1369514212
#        ^ reference local 1$1369514212
#          ^^^^^ reference [..] StrongClass#shout().
     nil
   end
#    ⌃ enclosing_range_end [..] StrongUse#call_them().
 end
#  ⌃ enclosing_range_end [..] StrongUse#
