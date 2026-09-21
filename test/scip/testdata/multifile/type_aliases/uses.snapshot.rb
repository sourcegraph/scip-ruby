 # typed: true
 # check-errors: true
 
#⌄ enclosing_range_start [..] Types#
 module Types
#       ^^^^^ definition [..] Types#
   extend T::Sig
#  ^^^^^^ reference [..] Kernel#extend().
   Renamed = T.type_alias { Text }
#  ^^^^^^^ definition [..] Types#Renamed.
#                           ^^^^ reference [..] Types#Text.
 
   sig { params(value: Text).returns(Checked) }
#                      ^^^^ reference [..] Types#Text.
#                                    ^^^^^^^ reference [..] Types#Checked.
#  ⌄ enclosing_range_start [..] `<Class:Types>`#echo().
   def self.echo(value)
#           ^^^^ definition [..] `<Class:Types>`#echo().
#                ^^^^^ definition local 1$1967217148
     T.let(value, Renamed).upcase
#          ^^^^^ reference local 1$1967217148
#                 ^^^^^^^ reference [..] Types#Renamed.
#                          ^^^^^^ reference [..] String#upcase().
   end
#    ⌃ enclosing_range_end [..] `<Class:Types>`#echo().
 
#  ⌄ enclosing_range_start [..] Types#Box#
   class Box
#        ^^^ definition [..] Types#Box#
     sig { params(value: Elem).returns(Elem) }
#                        ^^^^ reference [..] Types#Box#Elem#
#                                      ^^^^ reference [..] Types#Box#Elem#
#    ⌄ enclosing_range_start [..] Types#Box#echo().
     def echo(value)
#        ^^^^ definition [..] Types#Box#echo().
#             ^^^^^ definition local 1$4114529897
       T.let(value, Elem)
#            ^^^^^ reference local 1$4114529897
#                   ^^^^ reference [..] Types#Box#Elem#
     end
#      ⌃ enclosing_range_end [..] Types#Box#echo().
   end
#    ⌃ enclosing_range_end [..] Types#Box#
 end
#  ⌃ enclosing_range_end [..] Types#
 
#⌄ enclosing_range_start [..] AliasConsumer#
 class AliasConsumer
#      ^^^^^^^^^^^^^ definition [..] AliasConsumer#
   extend T::Sig
#  ^^^^^^ reference [..] Kernel#extend().
 
   sig { params(value: Types::Checked).returns(::Types::Text) }
#                      ^^^^^ reference [..] Types#
#                             ^^^^^^^ reference [..] Types#Checked.
#                                                ^^^^^ reference [..] Types#
#                                                       ^^^^ reference [..] Types#Text.
#  ⌄ enclosing_range_start [..] AliasConsumer#echo().
   def echo(value)
#      ^^^^ definition [..] AliasConsumer#echo().
#           ^^^^^ definition local 1$1027927589
     T.let(value, Types::Renamed).upcase
#          ^^^^^ reference local 1$1027927589
#                 ^^^^^ reference [..] Types#
#                        ^^^^^^^ reference [..] Types#Renamed.
#                                 ^^^^^^ reference [..] String#upcase().
   end
#    ⌃ enclosing_range_end [..] AliasConsumer#echo().
 
   sig { params(value: OtherTypes::Text).returns(Types::Other) }
#                      ^^^^^^^^^^ reference [..] OtherTypes#
#                                  ^^^^ reference [..] OtherTypes#Text.
#                                                ^^^^^ reference [..] Types#
#                                                       ^^^^^ reference [..] Types#Other.
#  ⌄ enclosing_range_start [..] AliasConsumer#numeric().
   def numeric(value)
#      ^^^^^^^ definition [..] AliasConsumer#numeric().
#              ^^^^^ definition local 1$3320123079
     value.abs
#    ^^^^^ reference local 1$3320123079
#          ^^^ reference [..] Integer#abs().
   end
#    ⌃ enclosing_range_end [..] AliasConsumer#numeric().
 end
#  ⌃ enclosing_range_end [..] AliasConsumer#
 
 Types.echo("text").upcase
#^^^^^ reference [..] Types#
#      ^^^^ reference [..] `<Class:Types>`#echo().
#                   ^^^^^^ reference [..] String#upcase().
 Types::Box[String].new.echo("text").upcase
#^^^^^ reference [..] Types#
#       ^^^ reference [..] Types#Box#
#          ^ reference [..] T#Generic#`[]`().
#           ^^^^^^ reference [..] String#
#                       ^^^^ reference [..] Types#Box#echo().
#                                    ^^^^^^ reference [..] String#upcase().
 AliasConsumer.new.echo("text").upcase
#^^^^^^^^^^^^^ reference [..] AliasConsumer#
#              ^^^ reference [..] Class#new().
#                  ^^^^ reference [..] AliasConsumer#echo().
#                               ^^^^^^ reference [..] String#upcase().
 AliasConsumer.new.numeric(1).abs
#^^^^^^^^^^^^^ reference [..] AliasConsumer#
#              ^^^ reference [..] Class#new().
#                  ^^^^^^^ reference [..] AliasConsumer#numeric().
#                             ^^^ reference [..] Integer#abs().
