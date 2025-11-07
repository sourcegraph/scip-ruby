 # typed: true
 
 # NOTE: The methods have bodies to make sure that we're not
 # accidentally skipping emitting references for the method body
 # due to changes in rewriter/Command.cc
 
 class Opus::Command
#      ^^^^ reference [..] Opus#
#            ^^^^^^^ definition [..] Opus#Command#
 end
 
 # NOTE: This is nested inside Opus as a convention,
 # but the key thing is the subclassing relationship.
 class Opus::MyThing::Command::GetThing < Opus::Command
#      ^^^^ reference [..] Opus#
#            ^^^^^^^ reference [..] Opus#MyThing#
#                     ^^^^^^^ reference [..] Opus#MyThing#Command#
#                              ^^^^^^^^ definition [..] Opus#MyThing#Command#GetThing#
#                                         ^^^^ reference [..] Opus#
#                                               ^^^^^^^ reference [..] Opus#Command#
   def call()
#      ^^^^ definition [..] Opus#MyThing#Command#GetThing#call().
     x = 1
#    ^ definition local 1$3018949801
     y = x
#    ^ definition local 2$3018949801
#    ^^^^^ reference local 2$3018949801
#        ^ reference local 1$3018949801
   end
 end
 
 # Forgot < Opus::Command relationship here
 class Opus::MyThing::BadCommand::GetThing
#      ^^^^ reference [..] Opus#
#            ^^^^^^^ reference [..] Opus#MyThing#
#                     ^^^^^^^^^^ reference [..] Opus#MyThing#BadCommand#
#                                 ^^^^^^^^ definition [..] Opus#MyThing#BadCommand#GetThing#
   def call()
#      ^^^^ definition [..] Opus#MyThing#BadCommand#GetThing#call().
     x = 1
#    ^ definition local 1$3018949801
     y = x
#    ^ definition local 2$3018949801
#    ^^^^^ reference local 2$3018949801
#        ^ reference local 1$3018949801
   end
 end
 
 class NotOpus::Command1::GetThing
#      ^^^^^^^ reference [..] NotOpus#
#               ^^^^^^^^ reference [..] NotOpus#Command1#
#                         ^^^^^^^^ definition [..] NotOpus#Command1#GetThing#
   # Class method
   def self.call()
#           ^^^^ definition [..] NotOpus#Command1#`<Class:GetThing>`#call().
     x = 1
#    ^ definition local 1$3018949801
     y = x
#    ^ definition local 2$3018949801
#    ^^^^^ reference local 2$3018949801
#        ^ reference local 1$3018949801
   end
 end
 
 class NotOpus::Command2::GetThing
#      ^^^^^^^ reference [..] NotOpus#
#               ^^^^^^^^ reference [..] NotOpus#Command2#
#                         ^^^^^^^^ definition [..] NotOpus#Command2#GetThing#
   # Instance method
   def call()
#      ^^^^ definition [..] NotOpus#Command2#GetThing#call().
     x = 1
#    ^ definition local 1$3018949801
     y = x
#    ^ definition local 2$3018949801
#    ^^^^^ reference local 2$3018949801
#        ^ reference local 1$3018949801
   end
 end
 
 def make_call()
#    ^^^^^^^^^ definition [..] Object#make_call().
   # Should navigate to instance method
   Opus::MyThing::Command::GetThing.call()
#  ^^^^ reference [..] Opus#
#        ^^^^^^^ reference [..] Opus#MyThing#
#                 ^^^^^^^ reference [..] Opus#MyThing#Command#
#                          ^^^^^^^^ reference [..] Opus#MyThing#Command#GetThing#
#                                   ^^^^ reference [..] Opus#MyThing#Command#GetThing#call().
   # Actually wrong, because < Opus::Command was missed
   Opus::MyThing::BadCommand::GetThing.call()
#  ^^^^ reference [..] Opus#
#        ^^^^^^^ reference [..] Opus#MyThing#
#                 ^^^^^^^^^^ reference [..] Opus#MyThing#BadCommand#
#                             ^^^^^^^^ reference [..] Opus#MyThing#BadCommand#GetThing#
   # Not expected to work since type is not in Opus namespace
   NotOpus::Command1::GetThing.call()
#  ^^^^^^^ reference [..] NotOpus#
#           ^^^^^^^^ reference [..] NotOpus#Command1#
#                     ^^^^^^^^ reference [..] NotOpus#Command1#GetThing#
#                              ^^^^ reference [..] NotOpus#Command1#`<Class:GetThing>`#call().
   # Should navigate to instance method
   NotOpus::Command2::GetThing.new().call()
#  ^^^^^^^ reference [..] NotOpus#
#           ^^^^^^^^ reference [..] NotOpus#Command2#
#                     ^^^^^^^^ reference [..] NotOpus#Command2#GetThing#
#                              ^^^ reference [..] Class#new().
#                                    ^^^^ reference [..] NotOpus#Command2#GetThing#call().
 end
