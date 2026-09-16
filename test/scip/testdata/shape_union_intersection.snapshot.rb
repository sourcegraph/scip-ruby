 # typed: true
 
#⌄ enclosing_range_start [..] ToyLabels#
 class ToyLabels
#      ^^^^^^^^^ definition [..] ToyLabels#
   extend T::Sig
#  ^^^^^^ reference [..] Kernel#extend().
 
   sig do
     params(
       item: T.any(Integer, {label: String}, Symbol),
#                  ^^^^^^^ reference [..] Integer#
#                                   ^^^^^^ reference [..] String#
#                                            ^^^^^^ reference [..] Symbol#
       candidate: T.any(Integer, Symbol, T::Hash[Symbol, String])
#                       ^^^^^^^ reference [..] Integer#
#                                ^^^^^^ reference [..] Symbol#
#                                                ^^^^^^ reference [..] Symbol#
#                                                        ^^^^^^ reference [..] String#
     ).void
   end
#  ⌄ enclosing_range_start [..] `<Class:ToyLabels>`#describe().
   def self.describe(item, candidate)
#           ^^^^^^^^ definition [..] `<Class:ToyLabels>`#describe().
#                    ^^^^ definition local 1$1360419304
#                          ^^^^^^^^^ definition local 2$1360419304
     if item == candidate
#       ^^^^ reference local 1$1360419304
#            ^^ reference [..] Hash#`==`().
#            ^^ reference [..] Integer#`==`().
#            ^^ reference [..] Symbol#`==`().
#               ^^^^^^^^^ reference local 2$1360419304
       if candidate.is_a?(Hash)
#         ^^^^^^^^^ reference local 2$1360419304
#                   ^^^^^ reference [..] Kernel#`is_a?`().
#                         ^^^^ reference [..] Hash#
         ToyPrinter.new.print_label(candidate[:label])
#        ^^^^^^^^^^ reference [..] ToyPrinter#
#                   ^^^ reference [..] Class#new().
#                       ^^^^^^^^^^^ reference [..] ToyPrinter#print_label().
#                                   ^^^^^^^^^ reference local 2$1360419304
#                                            ^ reference [..] Hash#`[]`().
       end
     end
   end
#    ⌃ enclosing_range_end [..] `<Class:ToyLabels>`#describe().
 end
#  ⌃ enclosing_range_end [..] ToyLabels#
 
#⌄ enclosing_range_start [..] ToyPrinter#
 class ToyPrinter
#      ^^^^^^^^^^ definition [..] ToyPrinter#
   extend T::Sig
#  ^^^^^^ reference [..] Kernel#extend().
 
   sig {params(value: String).returns(String)}
#                     ^^^^^^ reference [..] String#
#                                     ^^^^^^ reference [..] String#
#  ⌄ enclosing_range_start [..] ToyPrinter#print_label().
   def print_label(value)
#      ^^^^^^^^^^^ definition [..] ToyPrinter#print_label().
#                  ^^^^^ definition local 1$1435598925
     value.upcase
#    ^^^^^ reference local 1$1435598925
#          ^^^^^^ reference [..] String#upcase().
   end
#    ⌃ enclosing_range_end [..] ToyPrinter#print_label().
 end
#  ⌃ enclosing_range_end [..] ToyPrinter#
 
 ToyLabels.describe({label: "sample"}, {label: "sample"})
#^^^^^^^^^ reference [..] ToyLabels#
#          ^^^^^^^^ reference [..] `<Class:ToyLabels>`#describe().
