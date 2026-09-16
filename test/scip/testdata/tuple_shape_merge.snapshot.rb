 # typed: true
 
 # Entirely synthetic: a rescue joins nil with tuples whose first element
 # changes from a literal to Integer, alongside a hash shape and string.
#⌄ enclosing_range_start [..] ToyCatalog#
 class ToyCatalog
#      ^^^^^^^^^^ definition [..] ToyCatalog#
   extend T::Sig
#  ^^^^^^ reference [..] Kernel#extend().
 
   sig { params(count: Integer).void }
#                      ^^^^^^^ reference [..] Integer#
#  ⌄ enclosing_range_start [..] `<Class:ToyCatalog>`#record().
   def self.record(count)
#           ^^^^^^ definition [..] `<Class:ToyCatalog>`#record().
#                  ^^^^^ definition local 1$1496340684
     entry = nil
#    ^^^^^ definition local 2$1496340684
     begin
       entry = [7, {"label" => "toy"}, "ready"]
#      ^^^^^ reference (write) local 2$1496340684
     rescue StandardError
#           ^^^^^^^^^^^^^ reference [..] StandardError#
       entry = [count, {"label" => "toy"}, "fallback"]
#      ^^^^^ reference (write) local 2$1496340684
#               ^^^^^ reference local 1$1496340684
     end
 
     ToyReporter.new.describe(entry)
#    ^^^^^^^^^^^ reference [..] ToyReporter#
#                ^^^ reference [..] Class#new().
#                    ^^^^^^^^ reference [..] ToyReporter#describe().
#                             ^^^^^ reference local 2$1496340684
   end
#    ⌃ enclosing_range_end [..] `<Class:ToyCatalog>`#record().
 end
#  ⌃ enclosing_range_end [..] ToyCatalog#
 
 # Definitions and references after the failing method must still be indexed.
#⌄ enclosing_range_start [..] ToyReporter#
 class ToyReporter
#      ^^^^^^^^^^^ definition [..] ToyReporter#
#  ⌄ enclosing_range_start [..] ToyReporter#describe().
   def describe(value)
#      ^^^^^^^^ definition [..] ToyReporter#describe().
#               ^^^^^ definition local 1$1360419304
     value.to_s
#    ^^^^^ reference local 1$1360419304
#          ^^^^ reference [..] Kernel#to_s().
   end
#    ⌃ enclosing_range_end [..] ToyReporter#describe().
 end
#  ⌃ enclosing_range_end [..] ToyReporter#
 
 ToyCatalog.record(11)
#^^^^^^^^^^ reference [..] ToyCatalog#
#           ^^^^^^ reference [..] `<Class:ToyCatalog>`#record().
