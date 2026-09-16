 # typed: true
 
#⌄ enclosing_range_start [..] ToyCards#
 class ToyCards
#      ^^^^^^^^ definition [..] ToyCards#
   extend T::Sig
#  ^^^^^^ reference [..] Kernel#extend().
 
   sig do
     params(
       card: T.any(T.nilable({label: String}), {count: Integer}),
#                                    ^^^^^^ reference [..] String#
#                                                      ^^^^^^^ reference [..] Integer#
       candidate: T.nilable(T::Hash[T.untyped, T.untyped])
     ).void
   end
#  ⌄ enclosing_range_start [..] `<Class:ToyCards>`#compare_optional().
   def self.compare_optional(card, candidate)
#           ^^^^^^^^^^^^^^^^ definition [..] `<Class:ToyCards>`#compare_optional().
#                            ^^^^ definition local 1$2431538817
#                                  ^^^^^^^^^ definition local 2$2431538817
     if candidate == card
#       ^^^^^^^^^ reference local 2$2431538817
#                 ^^ reference [..] BasicObject#`==`().
#                 ^^ reference [..] Hash#`==`().
#                    ^^^^ reference local 1$2431538817
       ToyPrinter.new.print_card(card)
#      ^^^^^^^^^^ reference [..] ToyPrinter#
#                 ^^^ reference [..] Class#new().
#                     ^^^^^^^^^^ reference [..] ToyPrinter#print_card().
#                                ^^^^ reference local 1$2431538817
     end
   end
#    ⌃ enclosing_range_end [..] `<Class:ToyCards>`#compare_optional().
 
   sig do
     params(
       card: T.any(T.nilable({label: String}), {count: Integer}),
#                                    ^^^^^^ reference [..] String#
#                                                      ^^^^^^^ reference [..] Integer#
       candidate: T.nilable(T::Hash[T.untyped, T.untyped])
     ).void
   end
#  ⌄ enclosing_range_start [..] `<Class:ToyCards>`#compare_required().
   def self.compare_required(card, candidate)
#           ^^^^^^^^^^^^^^^^ definition [..] `<Class:ToyCards>`#compare_required().
#                            ^^^^ definition local 1$3800903272
#                                  ^^^^^^^^^ definition local 2$3800903272
     card = T.must(card)
#    ^^^^ reference (write) local 1$3800903272
#           ^ reference [..] T#
#             ^^^^ reference [..] `<Class:T>`#must().
#                  ^^^^ reference local 1$3800903272
     if card == candidate
#       ^^^^ reference local 1$3800903272
#            ^^ reference [..] Hash#`==`().
#               ^^^^^^^^^ reference local 2$3800903272
       ToyPrinter.new.print_card(card)
#      ^^^^^^^^^^ reference [..] ToyPrinter#
#                 ^^^ reference [..] Class#new().
#                     ^^^^^^^^^^ reference [..] ToyPrinter#print_card().
#                                ^^^^ reference local 1$3800903272
     end
   end
#    ⌃ enclosing_range_end [..] `<Class:ToyCards>`#compare_required().
 end
#  ⌃ enclosing_range_end [..] ToyCards#
 
#⌄ enclosing_range_start [..] ToyPrinter#
 class ToyPrinter
#      ^^^^^^^^^^ definition [..] ToyPrinter#
   extend T::Sig
#  ^^^^^^ reference [..] Kernel#extend().
 
   sig {params(card: T.nilable(T::Hash[T.untyped, T.untyped])).returns(String)}
#                                                                      ^^^^^^ reference [..] String#
#  ⌄ enclosing_range_start [..] ToyPrinter#print_card().
   def print_card(card)
#      ^^^^^^^^^^ definition [..] ToyPrinter#print_card().
#                 ^^^^ definition local 1$2636574632
     card.inspect
#    ^^^^ reference local 1$2636574632
#         ^^^^^^^ reference [..] Hash#inspect().
#         ^^^^^^^ reference [..] NilClass#inspect().
   end
#    ⌃ enclosing_range_end [..] ToyPrinter#print_card().
 end
#  ⌃ enclosing_range_end [..] ToyPrinter#
 
 ToyCards.compare_optional({label: "sample"}, nil)
#^^^^^^^^ reference [..] ToyCards#
#         ^^^^^^^^^^^^^^^^ reference [..] `<Class:ToyCards>`#compare_optional().
 ToyCards.compare_required({count: 7}, {count: 7})
#^^^^^^^^ reference [..] ToyCards#
#         ^^^^^^^^^^^^^^^^ reference [..] `<Class:ToyCards>`#compare_required().
 
 # Preserving shapes and tuples in mixed unions must preserve method navigation too.
 # This models a mixed-input validation loop, including empty aggregates.
 [7, true, {}, [], 0.5].each do |value|
#                       ^^^^ reference [..] Array#each().
#                                ^^^^^ definition local 3$217974539
   value.inspect
#  ^^^^^ reference local 3$217974539
#        ^^^^^^^ reference [..] Array#inspect().
#        ^^^^^^^ reference [..] Float#inspect().
#        ^^^^^^^ reference [..] Hash#inspect().
#        ^^^^^^^ reference [..] Integer#inspect().
#        ^^^^^^^ reference [..] Kernel#inspect().
 end
 
 # Direct aggregate receivers use the same Hash/Array methods.
 {label: "toy"}.inspect
#               ^^^^^^^ reference [..] Hash#inspect().
 [7, "toy"].inspect
#           ^^^^^^^ reference [..] Array#inspect().
