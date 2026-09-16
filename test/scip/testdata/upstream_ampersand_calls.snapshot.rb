 # typed: true
 # Adapted from test/testdata/lsp/hover_ampersand_operations.rb.
 
#⌄ enclosing_range_start [..] Dog#
 class Dog
#      ^^^ definition [..] Dog#
   extend T::Sig
#  ^^^^^^ reference [..] Kernel#extend().
 
   sig { returns(String) }
#                ^^^^^^ reference [..] String#
#  ⌄ enclosing_range_start [..] Dog#breed().
   attr_reader :breed
#               ^^^^^ definition [..] Dog#breed().
#                   ⌃ enclosing_range_end [..] Dog#breed().
 
   sig { params(breed: String).void }
#                      ^^^^^^ reference [..] String#
#  ⌄ enclosing_range_start [..] Dog#initialize().
   def initialize(breed)
#      ^^^^^^^^^^ definition [..] Dog#initialize().
#                 ^^^^^ definition local 1$3465713227
     @breed = T.let(breed, String)
#    ^^^^^^ definition [..] Dog#`@breed`.
#    ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ reference [..] Dog#`@breed`.
#                   ^^^^^ reference local 1$3465713227
#                          ^^^^^^ reference [..] String#
   end
#    ⌃ enclosing_range_end [..] Dog#initialize().
 end
#  ⌃ enclosing_range_end [..] Dog#
 
 extend T::Sig
#^^^^^^ reference [..] Kernel#extend().
#       ^ reference [..] T#
#          ^^^ reference [..] T#Sig#
 
 sig { params(dogs: T::Array[Dog], maybe_dog: T.nilable(Dog)).void }
#^^^ reference [..] T#Sig#sig().
#      ^^^^^^ reference [..] T#Private#Methods#DeclBuilder#params().
#                   ^ reference [..] T#
#                      ^^^^^ reference [..] T#Array#
#                            ^^^ reference [..] Dog#
#                                             ^ reference [..] T#
#                                               ^^^^^^^ reference [..] `<Class:T>`#nilable().
#                                                       ^^^ reference [..] Dog#
#                                                             ^^^^ reference [..] T#Private#Methods#DeclBuilder#void().
#⌄ enclosing_range_start [..] Object#ampersand_calls().
 def ampersand_calls(dogs, maybe_dog)
#    ^^^^^^^^^^^^^^^ definition [..] Object#ampersand_calls().
#                    ^^^^ definition local 1$2457444546
#                          ^^^^^^^^^ definition local 2$2457444546
   dogs.map(&:breed)
#  ^^^^ reference local 1$2457444546
#       ^^^ reference [..] Array#map().
#             ^^^^^ reference [..] Dog#breed().
   dogs.map(&:"breed")
#  ^^^^ reference local 1$2457444546
#       ^^^ reference [..] Array#map().
#              ^^^^^ reference [..] Dog#breed().
   dogs.map(&:'breed')
#  ^^^^ reference local 1$2457444546
#       ^^^ reference [..] Array#map().
#              ^^^^^ reference [..] Dog#breed().
   dogs.map(&:itself)
#  ^^^^ reference local 1$2457444546
#       ^^^ reference [..] Array#map().
#             ^^^^^^ reference [..] Kernel#itself().
   maybe_dog&.breed
#  ^^^^^^^^^ reference local 2$2457444546
#             ^^^^^ reference [..] Dog#breed().
   maybe_dog&.breed&.upcase
#  ^^^^^^^^^ reference local 2$2457444546
#             ^^^^^ reference [..] Dog#breed().
#                    ^^^^^^ reference [..] String#upcase().
   breed = T.let(nil, T.nilable(String))
#  ^^^^^ definition local 5$2457444546
#                     ^ reference [..] T#
#                       ^^^^^^^ reference [..] `<Class:T>`#nilable().
#                               ^^^^^^ reference [..] String#
   breed ||= maybe_dog&.breed
#  ^^^^^ reference (write) local 5$2457444546
#            ^^^^^^^^^ reference local 2$2457444546
#                       ^^^^^ reference [..] Dog#breed().
   breed &&= maybe_dog&.breed
#  ^^^^^ reference (write) local 5$2457444546
#  ^^^^^ reference local 5$2457444546
#  ^^^^^^^^^^^^^^^^^^^^^^^^^^ reference local 5$2457444546
#            ^^^^^^^^^ reference local 2$2457444546
#                       ^^^^^ reference [..] Dog#breed().
 end
#  ⌃ enclosing_range_end [..] Object#ampersand_calls().
 
 sig { params(dog: Dog).void }
#^^^ reference [..] T#Sig#sig().
#      ^^^^^^ reference [..] T#Private#Methods#DeclBuilder#params().
#                  ^^^ reference [..] Dog#
#                       ^^^^ reference [..] T#Private#Methods#DeclBuilder#void().
#⌄ enclosing_range_start [..] Object#known_receiver().
 def known_receiver(dog)
#    ^^^^^^^^^^^^^^ definition [..] Object#known_receiver().
#                   ^^^ definition local 1$283871188
   dog&.breed
#  ^^^ reference local 1$283871188
#       ^^^^^ reference [..] Dog#breed().
   (dog)&.breed
#   ^^^ reference local 1$283871188
#         ^^^^^ reference [..] Dog#breed().
   dog.breed&.upcase
#  ^^^ reference local 1$283871188
#      ^^^^^ reference [..] Dog#breed().
#             ^^^^^^ reference [..] String#upcase().
   Dog.new("Labrador")&.breed
#  ^^^ reference [..] Dog#
#      ^^^ reference [..] Class#new().
#                       ^^^^^ reference [..] Dog#breed().
   nil&.breed
 end
#  ⌃ enclosing_range_end [..] Object#known_receiver().
