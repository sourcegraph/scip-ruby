 # typed: strict
 
 class CR
#      ^^ definition [..] CR#
   extend T::Sig
#  ^^^^^^ reference [..] Kernel#extend().
   cattr_reader :both, :foo
#               ^^^^^ definition [..] CR#both().
#               ^^^^^ definition [..] `<Class:CR>`#both().
#                      ^^^^ definition [..] CR#foo().
#                      ^^^^ definition [..] `<Class:CR>`#foo().
   cattr_reader :no_instance, instance_accessor: false
#               ^^^^^^^^^^^^ definition [..] `<Class:CR>`#no_instance().
   cattr_reader :bar, :no_reader, instance_reader: false
#               ^^^^ definition [..] `<Class:CR>`#bar().
#                     ^^^^^^^^^^ definition [..] `<Class:CR>`#no_reader().
 
   sig {void}
   def usages
#      ^^^^^^ definition [..] CR#usages().
     both
#    ^^^^ reference [..] CR#both().
   end
 
   both
#  ^^^^ reference [..] `<Class:CR>`#both().
   no_instance
#  ^^^^^^^^^^^ reference [..] `<Class:CR>`#no_instance().
   no_reader
#  ^^^^^^^^^ reference [..] `<Class:CR>`#no_reader().
 end
 
 class CW
#      ^^ definition [..] CW#
   extend T::Sig
#  ^^^^^^ reference [..] Kernel#extend().
   cattr_writer :both, :foo
#               ^^^^^ definition [..] CW#`both=`().
#               ^^^^^ definition [..] `<Class:CW>`#`both=`().
#                      ^^^^ definition [..] CW#`foo=`().
#                      ^^^^ definition [..] `<Class:CW>`#`foo=`().
   cattr_writer :no_instance, instance_accessor: false
#               ^^^^^^^^^^^^ definition [..] `<Class:CW>`#`no_instance=`().
   cattr_writer :bar, :no_instance_writer, instance_writer: false
#               ^^^^ definition [..] `<Class:CW>`#`bar=`().
#                     ^^^^^^^^^^^^^^^^^^^ definition [..] `<Class:CW>`#`no_instance_writer=`().
 
   sig {void}
   def usages
#      ^^^^^^ definition [..] CW#usages().
     self.both = 1
#         ^^^^^^ reference [..] CW#`both=`().
   end
 
   self.both = 1
#       ^^^^^^ reference [..] `<Class:CW>`#`both=`().
   self.no_instance = 1
#       ^^^^^^^^^^^^^ reference [..] `<Class:CW>`#`no_instance=`().
   self.no_instance_writer = 1
#       ^^^^^^^^^^^^^^^^^^^^ reference [..] `<Class:CW>`#`no_instance_writer=`().
 end
 
 class CA
#      ^^ definition [..] CA#
   extend T::Sig
#  ^^^^^^ reference [..] Kernel#extend().
   cattr_accessor :both, :foo
#                 ^^^^^ definition [..] CA#`both=`().
#                 ^^^^^ definition [..] `<Class:CA>`#both().
#                 ^^^^^ definition [..] `<Class:CA>`#`both=`().
#                 ^^^^^ definition [..] CA#both().
#                        ^^^^ definition [..] CA#foo().
#                        ^^^^ definition [..] `<Class:CA>`#foo().
#                        ^^^^ definition [..] CA#`foo=`().
#                        ^^^^ definition [..] `<Class:CA>`#`foo=`().
   cattr_accessor :no_instance, instance_accessor: false
#                 ^^^^^^^^^^^^ definition [..] `<Class:CA>`#no_instance().
#                 ^^^^^^^^^^^^ definition [..] `<Class:CA>`#`no_instance=`().
   cattr_accessor :no_instance_reader, instance_reader: false
#                 ^^^^^^^^^^^^^^^^^^^ definition [..] `<Class:CA>`#no_instance_reader().
#                 ^^^^^^^^^^^^^^^^^^^ definition [..] CA#`no_instance_reader=`().
#                 ^^^^^^^^^^^^^^^^^^^ definition [..] `<Class:CA>`#`no_instance_reader=`().
   cattr_accessor :bar, :no_instance_writer, instance_writer: false
#                 ^^^^ definition [..] CA#bar().
#                 ^^^^ definition [..] `<Class:CA>`#bar().
#                 ^^^^ definition [..] `<Class:CA>`#`bar=`().
#                       ^^^^^^^^^^^^^^^^^^^ definition [..] `<Class:CA>`#no_instance_writer().
#                       ^^^^^^^^^^^^^^^^^^^ definition [..] `<Class:CA>`#`no_instance_writer=`().
#                       ^^^^^^^^^^^^^^^^^^^ definition [..] CA#no_instance_writer().
 
   sig {void}
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
