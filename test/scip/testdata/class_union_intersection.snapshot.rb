 # typed: true
 
#⌄ enclosing_range_start [..] ToyBox#
 class ToyBox
#      ^^^^^^ definition [..] ToyBox#
#  ⌄ enclosing_range_start [..] ToyBox#mark().
   def mark
#      ^^^^ definition [..] ToyBox#mark().
     "box"
   end
#    ⌃ enclosing_range_end [..] ToyBox#mark().
 end
#  ⌃ enclosing_range_end [..] ToyBox#
 
#⌄ enclosing_range_start [..] ToyShelf#
 class ToyShelf
#      ^^^^^^^^ definition [..] ToyShelf#
#  ⌄ enclosing_range_start [..] ToyShelf#mark().
   def mark
#      ^^^^ definition [..] ToyShelf#mark().
     "shelf"
   end
#    ⌃ enclosing_range_end [..] ToyShelf#mark().
 end
#  ⌃ enclosing_range_end [..] ToyShelf#
 
#⌄ enclosing_range_start [..] ToyFactory#
 class ToyFactory
#      ^^^^^^^^^^ definition [..] ToyFactory#
   extend T::Sig
#  ^^^^^^ reference [..] Kernel#extend().
 
   sig {params(entry: T.any(T.class_of(ToyBox), Symbol, T.class_of(ToyShelf))).void}
#                                      ^^^^^^ reference [..] ToyBox#
#                                               ^^^^^^ reference [..] Symbol#
#                                                                  ^^^^^^^^ reference [..] ToyShelf#
#  ⌄ enclosing_range_start [..] `<Class:ToyFactory>`#build().
   def self.build(entry)
#           ^^^^^ definition [..] `<Class:ToyFactory>`#build().
#                 ^^^^^ definition local 1$3855116076
     klass = if entry.is_a?(Class)
#    ^^^^^ definition local 3$3855116076
#               ^^^^^ reference local 1$3855116076
#                     ^^^^^ reference [..] Kernel#`is_a?`().
#                           ^^^^^ reference [..] Class#
       entry
#      ^^^^^ reference local 1$3855116076
     else
       ToyShelf
#      ^^^^^^^^ reference [..] ToyShelf#
     end
     klass.new.mark
#    ^^^^^ reference local 3$3855116076
#          ^^^ reference [..] Class#new().
#              ^^^^ reference [..] ToyBox#mark().
#              ^^^^ reference [..] ToyShelf#mark().
   end
#    ⌃ enclosing_range_end [..] `<Class:ToyFactory>`#build().
 end
#  ⌃ enclosing_range_end [..] ToyFactory#
 
 ToyFactory.build(ToyBox)
#^^^^^^^^^^ reference [..] ToyFactory#
#           ^^^^^ reference [..] `<Class:ToyFactory>`#build().
#                 ^^^^^^ reference [..] ToyBox#
