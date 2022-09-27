 # typed: strict
 
 class MR
#      ^^ definition [..] MR#
   extend T::Sig
#  ^^^^^^ reference [..] Kernel#extend().
   mattr_reader :both, :foo
#               ^^^^^ definition [..] MR#both().
#               ^^^^^ definition [..] `<Class:MR>`#both().
#                      ^^^^ definition [..] MR#foo().
#                      ^^^^ definition [..] `<Class:MR>`#foo().
   mattr_reader :no_instance, instance_accessor: false
#               ^^^^^^^^^^^^ definition [..] `<Class:MR>`#no_instance().
   mattr_reader :bar, :no_instance_reader, instance_reader: false
#               ^^^^ definition [..] `<Class:MR>`#bar().
#                     ^^^^^^^^^^^^^^^^^^^ definition [..] `<Class:MR>`#no_instance_reader().
 
   sig {void}
   def usages
#      ^^^^^^ definition [..] MR#usages().
     both
#    ^^^^ reference [..] MR#both().
   end
 
   both
#  ^^^^ reference [..] `<Class:MR>`#both().
   no_instance
#  ^^^^^^^^^^^ reference [..] `<Class:MR>`#no_instance().
   no_instance_reader
#  ^^^^^^^^^^^^^^^^^^ reference [..] `<Class:MR>`#no_instance_reader().
 end
 
 class MW
#      ^^ definition [..] MW#
   extend T::Sig
#  ^^^^^^ reference [..] Kernel#extend().
   mattr_writer :both, :foo
#               ^^^^^ definition [..] MW#`both=`().
#               ^^^^^ definition [..] `<Class:MW>`#`both=`().
#                      ^^^^ definition [..] MW#`foo=`().
#                      ^^^^ definition [..] `<Class:MW>`#`foo=`().
   mattr_writer :no_instance, instance_accessor: false
#               ^^^^^^^^^^^^ definition [..] `<Class:MW>`#`no_instance=`().
   mattr_writer :bar, :no_instance_writer, instance_writer: false
#               ^^^^ definition [..] `<Class:MW>`#`bar=`().
#                     ^^^^^^^^^^^^^^^^^^^ definition [..] `<Class:MW>`#`no_instance_writer=`().
 
   sig {void}
   def usages
#      ^^^^^^ definition [..] MW#usages().
     self.both = 1
#         ^^^^^^ reference [..] MW#`both=`().
   end
 
   self.both = 1
#       ^^^^^^ reference [..] `<Class:MW>`#`both=`().
   self.no_instance = 1
#       ^^^^^^^^^^^^^ reference [..] `<Class:MW>`#`no_instance=`().
   self.no_instance_writer = 1
#       ^^^^^^^^^^^^^^^^^^^^ reference [..] `<Class:MW>`#`no_instance_writer=`().
 end
 
 class MA
#      ^^ definition [..] MA#
   extend T::Sig
#  ^^^^^^ reference [..] Kernel#extend().
   mattr_accessor :both, :foo
#                 ^^^^^ definition [..] MA#both().
#                 ^^^^^ definition [..] MA#`both=`().
#                 ^^^^^ definition [..] `<Class:MA>`#`both=`().
#                 ^^^^^ definition [..] `<Class:MA>`#both().
#                        ^^^^ definition [..] MA#`foo=`().
#                        ^^^^ definition [..] MA#foo().
#                        ^^^^ definition [..] `<Class:MA>`#`foo=`().
#                        ^^^^ definition [..] `<Class:MA>`#foo().
   mattr_accessor :no_instance, instance_accessor: false
#                 ^^^^^^^^^^^^ definition [..] `<Class:MA>`#`no_instance=`().
#                 ^^^^^^^^^^^^ definition [..] `<Class:MA>`#no_instance().
   mattr_accessor :no_instance_reader, instance_reader: false
#                 ^^^^^^^^^^^^^^^^^^^ definition [..] MA#`no_instance_reader=`().
#                 ^^^^^^^^^^^^^^^^^^^ definition [..] `<Class:MA>`#`no_instance_reader=`().
#                 ^^^^^^^^^^^^^^^^^^^ definition [..] `<Class:MA>`#no_instance_reader().
   mattr_accessor :bar, :no_instance_writer, instance_writer: false
#                 ^^^^ definition [..] MA#bar().
#                 ^^^^ definition [..] `<Class:MA>`#`bar=`().
#                 ^^^^ definition [..] `<Class:MA>`#bar().
#                       ^^^^^^^^^^^^^^^^^^^ definition [..] MA#no_instance_writer().
#                       ^^^^^^^^^^^^^^^^^^^ definition [..] `<Class:MA>`#`no_instance_writer=`().
#                       ^^^^^^^^^^^^^^^^^^^ definition [..] `<Class:MA>`#no_instance_writer().
 
   sig {void}
   def usages
#      ^^^^^^ definition [..] MA#usages().
     both
#    ^^^^ reference [..] MA#both().
     self.both = 1
#         ^^^^^^ reference [..] MA#`both=`().
 
     self.no_instance_reader= 1
#         ^^^^^^^^^^^^^^^^^^^ reference [..] MA#`no_instance_reader=`().
 
     no_instance_writer
#    ^^^^^^^^^^^^^^^^^^ reference [..] MA#no_instance_writer().
   end
 
   both
#  ^^^^ reference [..] `<Class:MA>`#both().
   self.both = 1
#       ^^^^^^ reference [..] `<Class:MA>`#`both=`().
 
   no_instance
#  ^^^^^^^^^^^ reference [..] `<Class:MA>`#no_instance().
   self.no_instance = 1
#       ^^^^^^^^^^^^^ reference [..] `<Class:MA>`#`no_instance=`().
 
   no_instance_reader
#  ^^^^^^^^^^^^^^^^^^ reference [..] `<Class:MA>`#no_instance_reader().
   self.no_instance_reader = 1
#       ^^^^^^^^^^^^^^^^^^^^ reference [..] `<Class:MA>`#`no_instance_reader=`().
 
   no_instance_writer
#  ^^^^^^^^^^^^^^^^^^ reference [..] `<Class:MA>`#no_instance_writer().
   self.no_instance_writer = 1
#       ^^^^^^^^^^^^^^^^^^^^ reference [..] `<Class:MA>`#`no_instance_writer=`().
 end
