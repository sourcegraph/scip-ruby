 # typed: true
 # enable-experimental-rbs-comments: true
 
#⌄ enclosing_range_start [..] RBSDefinitions#
 module RBSDefinitions
#       ^^^^^^^^^^^^^^ definition [..] RBSDefinitions#
   #: (text) -> copy
#      ^^^^ reference [..] RBSDefinitions#`type text`.
#               ^^^^ reference [..] RBSDefinitions#`type copy`.
#  ⌄ enclosing_range_start [..] `<Class:RBSDefinitions>`#echo().
   def self.echo(value)
#           ^^^^ definition [..] `<Class:RBSDefinitions>`#echo().
#                ^^^^^ definition local 1$2473692514
     value
#    ^^^^^ reference local 1$2473692514
   end
#    ⌃ enclosing_range_end [..] `<Class:RBSDefinitions>`#echo().
 end
#  ⌃ enclosing_range_end [..] RBSDefinitions#
 
 #: (RBSDefinitions::text) -> RBSDefinitions::copy
#    ^^^^^^^^^^^^^^ reference [..] RBSDefinitions#
#                    ^^^^ reference [..] RBSDefinitions#`type text`.
#                             ^^^^^^^^^^^^^^ reference [..] RBSDefinitions#
#                                             ^^^^ reference [..] RBSDefinitions#`type copy`.
#⌄ enclosing_range_start [..] Object#alias_echo().
 def alias_echo(value)
#    ^^^^^^^^^^ definition [..] Object#alias_echo().
#               ^^^^^ definition local 1$520138687
   value.upcase
#  ^^^^^ reference local 1$520138687
#        ^^^^^^ reference [..] String#upcase().
 end
#  ⌃ enclosing_range_end [..] Object#alias_echo().
 
 #: [Elem] (Elem) -> Elem
#    ^^^^ definition [..] Object#generic_echo().[Elem]
#           ^^^^ reference [..] Object#generic_echo().[Elem]
#                    ^^^^ reference [..] Object#generic_echo().[Elem]
#⌄ enclosing_range_start [..] Object#generic_echo().
 def generic_echo(value)
#    ^^^^^^^^^^^^ definition [..] Object#generic_echo().
#                 ^^^^^ definition local 1$1919837280
   value #: Elem
#  ^^^^^ reference local 1$1919837280
#           ^^^^ reference [..] Object#generic_echo().[Elem]
 end
#  ⌃ enclosing_range_end [..] Object#generic_echo().
 
 #: [Elem] (Elem) -> Elem
#    ^^^^ definition [..] Object#other_echo().[Elem]
#           ^^^^ reference [..] Object#other_echo().[Elem]
#                    ^^^^ reference [..] Object#other_echo().[Elem]
#⌄ enclosing_range_start [..] Object#other_echo().
 def other_echo(value)
#    ^^^^^^^^^^ definition [..] Object#other_echo().
#               ^^^^^ definition local 1$536836473
   value
#  ^^^^^ reference local 1$536836473
 end
#  ⌃ enclosing_range_end [..] Object#other_echo().
 
 alias_echo("text").upcase
#^^^^^^^^^^ reference [..] Object#alias_echo().
#                   ^^^^^^ reference [..] String#upcase().
 generic_echo("text").upcase
#^^^^^^^^^^^^ reference [..] Object#generic_echo().
#                     ^^^^^^ reference [..] String#upcase().
 other_echo(1).abs
#^^^^^^^^^^ reference [..] Object#other_echo().
#              ^^^ reference [..] Integer#abs().
 RBSDefinitions.echo("text").upcase
#^^^^^^^^^^^^^^ reference [..] RBSDefinitions#
#               ^^^^ reference [..] `<Class:RBSDefinitions>`#echo().
#                            ^^^^^^ reference [..] String#upcase().
 box = RBSDefinitions::Box.new #: RBSDefinitions::Box[String]
#^^^ definition local 6$217974539
#      ^^^^^^^^^^^^^^ reference [..] RBSDefinitions#
#                      ^^^ reference [..] RBSDefinitions#Box#
#                                 ^^^^^^^^^^^^^^ reference [..] RBSDefinitions#
#                                                 ^^^ reference [..] RBSDefinitions#Box#
#                                                     ^^^^^^ reference [..] String#
 box.echo("text").upcase
#^^^ reference local 6$217974539
#    ^^^^ reference [..] RBSDefinitions#Box#echo().
#                 ^^^^^^ reference [..] String#upcase().
 box.generic_echo(1).abs
#^^^ reference local 6$217974539
#    ^^^^^^^^^^^^ reference [..] RBSDefinitions#Box#generic_echo().
#                    ^^^ reference [..] Integer#abs().
 bounded = RBSDefinitions::Bounded.new #: RBSDefinitions::Bounded[Numeric]
#^^^^^^^ definition local 11$217974539
#          ^^^^^^^^^^^^^^ reference [..] RBSDefinitions#
#                          ^^^^^^^ reference [..] RBSDefinitions#Bounded#
#                                         ^^^^^^^^^^^^^^ reference [..] RBSDefinitions#
#                                                         ^^^^^^^ reference [..] RBSDefinitions#Bounded#
#                                                                 ^^^^^^^ reference [..] Numeric#
 bounded.echo(1).abs
#^^^^^^^ reference local 11$217974539
#        ^^^^ reference [..] RBSDefinitions#Bounded#echo().
#                ^^^ reference [..] Numeric#abs().
