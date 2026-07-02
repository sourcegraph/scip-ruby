 # typed: strict
 
#⌄ enclosing_range_start [..] CR#
 class CR
#      ^^ definition [..] CR#
   extend T::Sig
#  ^^^^^^ reference [..] Kernel#extend().
#               ⌄ enclosing_range_start [..] CR#both().
#               ⌄ enclosing_range_start [..] `<Class:CR>`#both().
#                      ⌄ enclosing_range_start [..] CR#foo().
#                      ⌄ enclosing_range_start [..] `<Class:CR>`#foo().
   cattr_reader :both, :foo
#               ^^^^^ definition [..] CR#both().
#               ^^^^^ definition [..] `<Class:CR>`#both().
#                      ^^^^ definition [..] CR#foo().
#                      ^^^^ definition [..] `<Class:CR>`#foo().
#                   ⌃ enclosing_range_end [..] CR#both().
#                   ⌃ enclosing_range_end [..] `<Class:CR>`#both().
#                         ⌃ enclosing_range_end [..] CR#foo().
#                         ⌃ enclosing_range_end [..] `<Class:CR>`#foo().
#               ⌄ enclosing_range_start [..] `<Class:CR>`#no_instance().
   cattr_reader :no_instance, instance_accessor: false
#               ^^^^^^^^^^^^ definition [..] `<Class:CR>`#no_instance().
#                          ⌃ enclosing_range_end [..] `<Class:CR>`#no_instance().
#               ⌄ enclosing_range_start [..] `<Class:CR>`#bar().
#                     ⌄ enclosing_range_start [..] `<Class:CR>`#no_reader().
   cattr_reader :bar, :no_reader, instance_reader: false
#               ^^^^ definition [..] `<Class:CR>`#bar().
#                     ^^^^^^^^^^ definition [..] `<Class:CR>`#no_reader().
#                  ⌃ enclosing_range_end [..] `<Class:CR>`#bar().
#                              ⌃ enclosing_range_end [..] `<Class:CR>`#no_reader().
 
   sig {void}
#  ⌄ enclosing_range_start [..] CR#usages().
   def usages
#      ^^^^^^ definition [..] CR#usages().
     both
#    ^^^^ reference [..] CR#both().
   end
#    ⌃ enclosing_range_end [..] CR#usages().
 
   both
#  ^^^^ reference [..] `<Class:CR>`#both().
   no_instance
#  ^^^^^^^^^^^ reference [..] `<Class:CR>`#no_instance().
   no_reader
#  ^^^^^^^^^ reference [..] `<Class:CR>`#no_reader().
 end
#  ⌃ enclosing_range_end [..] CR#
 
#⌄ enclosing_range_start [..] CW#
 class CW
#      ^^ definition [..] CW#
   extend T::Sig
#  ^^^^^^ reference [..] Kernel#extend().
#               ⌄ enclosing_range_start [..] CW#`both=`().
#               ⌄ enclosing_range_start [..] `<Class:CW>`#`both=`().
#                      ⌄ enclosing_range_start [..] CW#`foo=`().
#                      ⌄ enclosing_range_start [..] `<Class:CW>`#`foo=`().
   cattr_writer :both, :foo
#               ^^^^^ definition [..] CW#`both=`().
#               ^^^^^ definition [..] `<Class:CW>`#`both=`().
#                      ^^^^ definition [..] CW#`foo=`().
#                      ^^^^ definition [..] `<Class:CW>`#`foo=`().
#                   ⌃ enclosing_range_end [..] CW#`both=`().
#                   ⌃ enclosing_range_end [..] `<Class:CW>`#`both=`().
#                         ⌃ enclosing_range_end [..] CW#`foo=`().
#                         ⌃ enclosing_range_end [..] `<Class:CW>`#`foo=`().
#               ⌄ enclosing_range_start [..] `<Class:CW>`#`no_instance=`().
   cattr_writer :no_instance, instance_accessor: false
#               ^^^^^^^^^^^^ definition [..] `<Class:CW>`#`no_instance=`().
#                          ⌃ enclosing_range_end [..] `<Class:CW>`#`no_instance=`().
#               ⌄ enclosing_range_start [..] `<Class:CW>`#`bar=`().
#                     ⌄ enclosing_range_start [..] `<Class:CW>`#`no_instance_writer=`().
   cattr_writer :bar, :no_instance_writer, instance_writer: false
#               ^^^^ definition [..] `<Class:CW>`#`bar=`().
#                     ^^^^^^^^^^^^^^^^^^^ definition [..] `<Class:CW>`#`no_instance_writer=`().
#                  ⌃ enclosing_range_end [..] `<Class:CW>`#`bar=`().
#                                       ⌃ enclosing_range_end [..] `<Class:CW>`#`no_instance_writer=`().
 
   sig {void}
#  ⌄ enclosing_range_start [..] CW#usages().
   def usages
#      ^^^^^^ definition [..] CW#usages().
     self.both = 1
#         ^^^^^^ reference [..] CW#`both=`().
   end
#    ⌃ enclosing_range_end [..] CW#usages().
 
   self.both = 1
#       ^^^^^^ reference [..] `<Class:CW>`#`both=`().
   self.no_instance = 1
#       ^^^^^^^^^^^^^ reference [..] `<Class:CW>`#`no_instance=`().
   self.no_instance_writer = 1
#       ^^^^^^^^^^^^^^^^^^^^ reference [..] `<Class:CW>`#`no_instance_writer=`().
 end
#  ⌃ enclosing_range_end [..] CW#
 
#⌄ enclosing_range_start [..] CA#
 class CA
#      ^^ definition [..] CA#
   extend T::Sig
#  ^^^^^^ reference [..] Kernel#extend().
#                 ⌄ enclosing_range_start [..] CA#`both=`().
#                 ⌄ enclosing_range_start [..] CA#both().
#                 ⌄ enclosing_range_start [..] `<Class:CA>`#`both=`().
#                 ⌄ enclosing_range_start [..] `<Class:CA>`#both().
#                        ⌄ enclosing_range_start [..] CA#`foo=`().
#                        ⌄ enclosing_range_start [..] CA#foo().
#                        ⌄ enclosing_range_start [..] `<Class:CA>`#`foo=`().
#                        ⌄ enclosing_range_start [..] `<Class:CA>`#foo().
   cattr_accessor :both, :foo
#                 ^^^^^ definition [..] CA#both().
#                 ^^^^^ definition [..] CA#`both=`().
#                 ^^^^^ definition [..] `<Class:CA>`#`both=`().
#                 ^^^^^ definition [..] `<Class:CA>`#both().
#                        ^^^^ definition [..] CA#`foo=`().
#                        ^^^^ definition [..] CA#foo().
#                        ^^^^ definition [..] `<Class:CA>`#`foo=`().
#                        ^^^^ definition [..] `<Class:CA>`#foo().
#                     ⌃ enclosing_range_end [..] CA#`both=`().
#                     ⌃ enclosing_range_end [..] CA#both().
#                     ⌃ enclosing_range_end [..] `<Class:CA>`#`both=`().
#                     ⌃ enclosing_range_end [..] `<Class:CA>`#both().
#                           ⌃ enclosing_range_end [..] CA#`foo=`().
#                           ⌃ enclosing_range_end [..] CA#foo().
#                           ⌃ enclosing_range_end [..] `<Class:CA>`#`foo=`().
#                           ⌃ enclosing_range_end [..] `<Class:CA>`#foo().
#                 ⌄ enclosing_range_start [..] `<Class:CA>`#`no_instance=`().
#                 ⌄ enclosing_range_start [..] `<Class:CA>`#no_instance().
   cattr_accessor :no_instance, instance_accessor: false
#                 ^^^^^^^^^^^^ definition [..] `<Class:CA>`#`no_instance=`().
#                 ^^^^^^^^^^^^ definition [..] `<Class:CA>`#no_instance().
#                            ⌃ enclosing_range_end [..] `<Class:CA>`#`no_instance=`().
#                            ⌃ enclosing_range_end [..] `<Class:CA>`#no_instance().
#                 ⌄ enclosing_range_start [..] CA#`no_instance_reader=`().
#                 ⌄ enclosing_range_start [..] `<Class:CA>`#`no_instance_reader=`().
#                 ⌄ enclosing_range_start [..] `<Class:CA>`#no_instance_reader().
   cattr_accessor :no_instance_reader, instance_reader: false
#                 ^^^^^^^^^^^^^^^^^^^ definition [..] CA#`no_instance_reader=`().
#                 ^^^^^^^^^^^^^^^^^^^ definition [..] `<Class:CA>`#`no_instance_reader=`().
#                 ^^^^^^^^^^^^^^^^^^^ definition [..] `<Class:CA>`#no_instance_reader().
#                                   ⌃ enclosing_range_end [..] CA#`no_instance_reader=`().
#                                   ⌃ enclosing_range_end [..] `<Class:CA>`#`no_instance_reader=`().
#                                   ⌃ enclosing_range_end [..] `<Class:CA>`#no_instance_reader().
#                 ⌄ enclosing_range_start [..] CA#bar().
#                 ⌄ enclosing_range_start [..] `<Class:CA>`#`bar=`().
#                 ⌄ enclosing_range_start [..] `<Class:CA>`#bar().
#                       ⌄ enclosing_range_start [..] CA#no_instance_writer().
#                       ⌄ enclosing_range_start [..] `<Class:CA>`#`no_instance_writer=`().
#                       ⌄ enclosing_range_start [..] `<Class:CA>`#no_instance_writer().
   cattr_accessor :bar, :no_instance_writer, instance_writer: false
#                 ^^^^ definition [..] CA#bar().
#                 ^^^^ definition [..] `<Class:CA>`#`bar=`().
#                 ^^^^ definition [..] `<Class:CA>`#bar().
#                       ^^^^^^^^^^^^^^^^^^^ definition [..] CA#no_instance_writer().
#                       ^^^^^^^^^^^^^^^^^^^ definition [..] `<Class:CA>`#`no_instance_writer=`().
#                       ^^^^^^^^^^^^^^^^^^^ definition [..] `<Class:CA>`#no_instance_writer().
#                    ⌃ enclosing_range_end [..] CA#bar().
#                    ⌃ enclosing_range_end [..] `<Class:CA>`#`bar=`().
#                    ⌃ enclosing_range_end [..] `<Class:CA>`#bar().
#                                         ⌃ enclosing_range_end [..] CA#no_instance_writer().
#                                         ⌃ enclosing_range_end [..] `<Class:CA>`#`no_instance_writer=`().
#                                         ⌃ enclosing_range_end [..] `<Class:CA>`#no_instance_writer().
 
   sig {void}
#  ⌄ enclosing_range_start [..] CA#usages().
   def usages
#      ^^^^^^ definition [..] CA#usages().
     both
#    ^^^^ reference [..] CA#both().
     self.both = 1
#         ^^^^^^ reference [..] CA#`both=`().
     self.no_instance_reader= 1
#         ^^^^^^^^^^^^^^^^^^^ reference [..] CA#`no_instance_reader=`().
     no_instance_writer
#    ^^^^^^^^^^^^^^^^^^ reference [..] CA#no_instance_writer().
   end
#    ⌃ enclosing_range_end [..] CA#usages().
 
   both
#  ^^^^ reference [..] `<Class:CA>`#both().
   self.both = 1
#       ^^^^^^ reference [..] `<Class:CA>`#`both=`().
 
   no_instance
#  ^^^^^^^^^^^ reference [..] `<Class:CA>`#no_instance().
   self.no_instance = 1
#       ^^^^^^^^^^^^^ reference [..] `<Class:CA>`#`no_instance=`().
 
   no_instance_reader
#  ^^^^^^^^^^^^^^^^^^ reference [..] `<Class:CA>`#no_instance_reader().
   self.no_instance_reader = 1
#       ^^^^^^^^^^^^^^^^^^^^ reference [..] `<Class:CA>`#`no_instance_reader=`().
 
   no_instance_writer
#  ^^^^^^^^^^^^^^^^^^ reference [..] `<Class:CA>`#no_instance_writer().
   self.no_instance_writer = 1
#       ^^^^^^^^^^^^^^^^^^^^ reference [..] `<Class:CA>`#`no_instance_writer=`().
 end
#  ⌃ enclosing_range_end [..] CA#
