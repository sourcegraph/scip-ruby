 # typed: true
 # Adapted from test/testdata/lsp/rename/method_union_2.rb and method_union_types.rb.
 
#⌄ enclosing_range_start [..] Dog#
 class Dog
#      ^^^ definition [..] Dog#
#  ⌄ enclosing_range_start [..] Dog#sound().
   def sound; "Bark"; end
#      ^^^^^ definition [..] Dog#sound().
#                       ⌃ enclosing_range_end [..] Dog#sound().
 end
#  ⌃ enclosing_range_end [..] Dog#
 
#⌄ enclosing_range_start [..] Cat#
 class Cat
#      ^^^ definition [..] Cat#
#  ⌄ enclosing_range_start [..] Cat#sound().
   def sound; "Meow"; end
#      ^^^^^ definition [..] Cat#sound().
#                       ⌃ enclosing_range_end [..] Cat#sound().
 end
#  ⌃ enclosing_range_end [..] Cat#
 
#⌄ enclosing_range_start [..] Puppy#
 class Puppy < Dog; end
#      ^^^^^ definition [..] Puppy#
#              ^^^ reference [..] Dog#
#                     ⌃ enclosing_range_end [..] Puppy#
 
 extend T::Sig
#^^^^^^ reference [..] Kernel#extend().
#       ^ reference [..] T#
#          ^^^ reference [..] T#Sig#
 
 sig { params(animal: T.any(Dog, Cat)).void }
#^^^ reference [..] T#Sig#sig().
#      ^^^^^^ reference [..] T#Private#Methods#DeclBuilder#params().
#                     ^ reference [..] T#
#                       ^^^ reference [..] `<Class:T>`#any().
#                           ^^^ reference [..] Dog#
#                                ^^^ reference [..] Cat#
#                                      ^^^^ reference [..] T#Private#Methods#DeclBuilder#void().
#⌄ enclosing_range_start [..] Object#union_receiver().
 def union_receiver(animal)
#    ^^^^^^^^^^^^^^ definition [..] Object#union_receiver().
#                   ^^^^^^ definition local 1$1635871106
   animal.sound
#  ^^^^^^ reference local 1$1635871106
#         ^^^^^ reference [..] Cat#sound().
#         ^^^^^ reference [..] Dog#sound().
   animal.inspect
#  ^^^^^^ reference local 1$1635871106
#         ^^^^^^^ reference [..] Kernel#inspect().
 end
#  ⌃ enclosing_range_end [..] Object#union_receiver().
 
 sig { params(dog: T.any(Dog, Puppy)).void }
#^^^ reference [..] T#Sig#sig().
#      ^^^^^^ reference [..] T#Private#Methods#DeclBuilder#params().
#                  ^ reference [..] T#
#                    ^^^ reference [..] `<Class:T>`#any().
#                        ^^^ reference [..] Dog#
#                             ^^^^^ reference [..] Puppy#
#                                     ^^^^ reference [..] T#Private#Methods#DeclBuilder#void().
#⌄ enclosing_range_start [..] Object#shared_method().
 def shared_method(dog)
#    ^^^^^^^^^^^^^ definition [..] Object#shared_method().
#                  ^^^ definition local 1$3604507294
   dog.sound
#  ^^^ reference local 1$3604507294
#      ^^^^^ reference [..] Dog#sound().
 end
#  ⌃ enclosing_range_end [..] Object#shared_method().
