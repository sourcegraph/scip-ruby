 # typed: true
 
 # Invalid has_attached_class! declarations and mixins can leave an attached-class
 # type member behind after namer/resolver errors. Signatures must still index.
#⌄ enclosing_range_start [..] DeclaresAttachedClass#
 class DeclaresAttachedClass
#      ^^^^^^^^^^^^^^^^^^^^^ definition [..] DeclaresAttachedClass#
   extend T::Sig
#  ^^^^^^ reference [..] Kernel#extend().
   extend T::Generic
#  ^^^^^^ reference [..] Kernel#extend().
   has_attached_class!
 
   sig { returns(T.attached_class) }
#  ⌄ enclosing_range_start [..] DeclaresAttachedClass#copy().
   def copy
#      ^^^^ definition [..] DeclaresAttachedClass#copy().
     self
   end
#    ⌃ enclosing_range_end [..] DeclaresAttachedClass#copy().
 end
#  ⌃ enclosing_range_end [..] DeclaresAttachedClass#
 
 # Module subclasses support has_attached_class! in current Sorbet.
#⌄ enclosing_range_start [..] ModuleSubclass#
 class ModuleSubclass < Module
#      ^^^^^^^^^^^^^^ definition [..] ModuleSubclass#
#                       ^^^^^^ reference [..] Module#
   extend T::Sig
#  ^^^^^^ reference [..] Kernel#extend().
   extend T::Generic
#  ^^^^^^ reference [..] Kernel#extend().
   has_attached_class!
 
   sig { returns(T.attached_class) }
#  ⌄ enclosing_range_start [..] ModuleSubclass#copy().
   def copy
#      ^^^^ definition [..] ModuleSubclass#copy().
     self
   end
#    ⌃ enclosing_range_end [..] ModuleSubclass#copy().
 end
#  ⌃ enclosing_range_end [..] ModuleSubclass#
 
#⌄ enclosing_range_start [..] AttachedClassFactory#
 module AttachedClassFactory
#       ^^^^^^^^^^^^^^^^^^^^ definition [..] AttachedClassFactory#
   extend T::Sig
#  ^^^^^^ reference [..] Kernel#extend().
   extend T::Generic
#  ^^^^^^ reference [..] Kernel#extend().
   has_attached_class!
 
   sig { returns(T.attached_class) }
#  ⌄ enclosing_range_start [..] AttachedClassFactory#build().
   def build
#      ^^^^^ definition [..] AttachedClassFactory#build().
     T.unsafe(self).new
#    ^ reference [..] T#
#      ^^^^^^ reference [..] `<Class:T>`#unsafe().
   end
#    ⌃ enclosing_range_end [..] AttachedClassFactory#build().
 end
#  ⌃ enclosing_range_end [..] AttachedClassFactory#
 
#⌄ enclosing_range_start [..] IncludesAttachedClass#
 class IncludesAttachedClass
#      ^^^^^^^^^^^^^^^^^^^^^ definition [..] IncludesAttachedClass#
   extend T::Sig
#  ^^^^^^ reference [..] Kernel#extend().
   include AttachedClassFactory
#  ^^^^^^^ reference [..] Module#include().
#          ^^^^^^^^^^^^^^^^^^^^ reference [..] AttachedClassFactory#
#          ^^^^^^^^^^^^^^^^^^^^ reference [..] AttachedClassFactory#
 
   sig { returns(T.attached_class) }
#  ⌄ enclosing_range_start [..] IncludesAttachedClass#copy().
   def copy
#      ^^^^ definition [..] IncludesAttachedClass#copy().
     self
   end
#    ⌃ enclosing_range_end [..] IncludesAttachedClass#copy().
 end
#  ⌃ enclosing_range_end [..] IncludesAttachedClass#
 
 # An invalid extension can also introduce the member on a module singleton.
#⌄ enclosing_range_start [..] ExtendsAttachedClass#
 module ExtendsAttachedClass
#       ^^^^^^^^^^^^^^^^^^^^ definition [..] ExtendsAttachedClass#
   extend T::Sig
#  ^^^^^^ reference [..] Kernel#extend().
   extend AttachedClassFactory
#  ^^^^^^ reference [..] Kernel#extend().
#         ^^^^^^^^^^^^^^^^^^^^ reference [..] AttachedClassFactory#
 
   sig { returns(T.attached_class) }
#  ⌄ enclosing_range_start [..] `<Class:ExtendsAttachedClass>`#copy().
   def self.copy
#           ^^^^ definition [..] `<Class:ExtendsAttachedClass>`#copy().
     self
   end
#    ⌃ enclosing_range_end [..] `<Class:ExtendsAttachedClass>`#copy().
 end
#  ⌃ enclosing_range_end [..] ExtendsAttachedClass#
 
 # Valid module instance methods and class singleton methods keep their types.
#⌄ enclosing_range_start [..] ValidFactory#
 class ValidFactory
#      ^^^^^^^^^^^^ definition [..] ValidFactory#
   extend T::Sig
#  ^^^^^^ reference [..] Kernel#extend().
   extend AttachedClassFactory
#  ^^^^^^ reference [..] Kernel#extend().
#         ^^^^^^^^^^^^^^^^^^^^ reference [..] AttachedClassFactory#
 
   sig { returns(T.attached_class) }
#  ⌄ enclosing_range_start [..] `<Class:ValidFactory>`#copy().
   def self.copy
#           ^^^^ definition [..] `<Class:ValidFactory>`#copy().
     new
#    ^^^ reference [..] Class#new().
   end
#    ⌃ enclosing_range_end [..] `<Class:ValidFactory>`#copy().
 
#  ⌄ enclosing_range_start [..] ValidFactory#instance_method().
   def instance_method
#      ^^^^^^^^^^^^^^^ definition [..] ValidFactory#instance_method().
   end
#    ⌃ enclosing_range_end [..] ValidFactory#instance_method().
 end
#  ⌃ enclosing_range_end [..] ValidFactory#
 
 DeclaresAttachedClass.new.copy
#^^^^^^^^^^^^^^^^^^^^^ reference [..] DeclaresAttachedClass#
#                      ^^^ reference [..] Class#new().
#                          ^^^^ reference [..] DeclaresAttachedClass#copy().
 ModuleSubclass.new.copy
#^^^^^^^^^^^^^^ reference [..] ModuleSubclass#
#               ^^^ reference [..] Module#initialize().
#                   ^^^^ reference [..] ModuleSubclass#copy().
 IncludesAttachedClass.new.copy
#^^^^^^^^^^^^^^^^^^^^^ reference [..] IncludesAttachedClass#
#                      ^^^ reference [..] Class#new().
#                          ^^^^ reference [..] IncludesAttachedClass#copy().
 ExtendsAttachedClass.copy
#^^^^^^^^^^^^^^^^^^^^ reference [..] ExtendsAttachedClass#
#                     ^^^^ reference [..] `<Class:ExtendsAttachedClass>`#copy().
 ValidFactory.build.instance_method
#^^^^^^^^^^^^ reference [..] ValidFactory#
#             ^^^^^ reference [..] AttachedClassFactory#build().
#                   ^^^^^^^^^^^^^^^ reference [..] ValidFactory#instance_method().
 ValidFactory.copy.instance_method
#^^^^^^^^^^^^ reference [..] ValidFactory#
#             ^^^^ reference [..] `<Class:ValidFactory>`#copy().
#                  ^^^^^^^^^^^^^^^ reference [..] ValidFactory#instance_method().
