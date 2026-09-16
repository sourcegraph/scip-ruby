 # typed: true
 # enable-experimental-rbs-comments: true
 
#⌄ enclosing_range_start [..] RBSDefinitions#
 module RBSDefinitions
#       ^^^^^^^^^^^^^^ definition [..] RBSDefinitions#
   #: type text = String
#  ^^^^^^^^^^^^^^^^^^^^^ definition [..] RBSDefinitions#`type text`.
#                 ^^^^^^ reference [..] String#
   #: type copy = text
#  ^^^^^^^^^^^^^^^^^^^ definition [..] RBSDefinitions#`type copy`.
#                 ^^^^ reference [..] RBSDefinitions#`type text`.
 
   #: [Elem]
#      ^^^^ definition [..] RBSDefinitions#Box#Elem#
#  ⌄ enclosing_range_start [..] RBSDefinitions#Box#
   class Box
#        ^^^ definition [..] RBSDefinitions#Box#
     #: (Elem) -> Elem
#        ^^^^ reference [..] RBSDefinitions#Box#Elem#
#                 ^^^^ reference [..] RBSDefinitions#Box#Elem#
#    ⌄ enclosing_range_start [..] RBSDefinitions#Box#echo().
     def echo(value)
#        ^^^^ definition [..] RBSDefinitions#Box#echo().
#             ^^^^^ definition local 1$3567113348
       value #: Elem
#      ^^^^^ reference local 1$3567113348
#               ^^^^ reference [..] RBSDefinitions#Box#Elem#
     end
#      ⌃ enclosing_range_end [..] RBSDefinitions#Box#echo().
 
     #: [Elem] (Elem) -> Elem
#        ^^^^ definition [..] RBSDefinitions#Box#generic_echo().[Elem]
#               ^^^^ reference [..] RBSDefinitions#Box#generic_echo().[Elem]
#                        ^^^^ reference [..] RBSDefinitions#Box#generic_echo().[Elem]
#    ⌄ enclosing_range_start [..] RBSDefinitions#Box#generic_echo().
     def generic_echo(value)
#        ^^^^^^^^^^^^ definition [..] RBSDefinitions#Box#generic_echo().
#                     ^^^^^ definition local 1$4029829318
       value #: Elem
#      ^^^^^ reference local 1$4029829318
#               ^^^^ reference [..] RBSDefinitions#Box#generic_echo().[Elem]
     end
#      ⌃ enclosing_range_end [..] RBSDefinitions#Box#generic_echo().
   end
#    ⌃ enclosing_range_end [..] RBSDefinitions#Box#
 
   #: [Elem < Numeric]
#      ^^^^^^^^^^^^^^ definition [..] RBSDefinitions#Bounded#Elem#
#             ^^^^^^^ reference [..] Numeric#
#  ⌄ enclosing_range_start [..] RBSDefinitions#Bounded#
   class Bounded
#        ^^^^^^^ definition [..] RBSDefinitions#Bounded#
     #: (Elem) -> Elem
#        ^^^^ reference [..] RBSDefinitions#Bounded#Elem#
#                 ^^^^ reference [..] RBSDefinitions#Bounded#Elem#
#    ⌄ enclosing_range_start [..] RBSDefinitions#Bounded#echo().
     def echo(value)
#        ^^^^ definition [..] RBSDefinitions#Bounded#echo().
#             ^^^^^ definition local 1$3567113348
       value
#      ^^^^^ reference local 1$3567113348
     end
#      ⌃ enclosing_range_end [..] RBSDefinitions#Bounded#echo().
   end
#    ⌃ enclosing_range_end [..] RBSDefinitions#Bounded#
 end
#  ⌃ enclosing_range_end [..] RBSDefinitions#
