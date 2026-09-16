 # typed: true
 extend T::Sig
#^^^^^^ reference [..] Kernel#extend().
#       ^ reference [..] T#
#          ^^^ reference [..] T#Sig#
 
 # New inference retains tuple/shape types here instead of Array/Hash.
#⌄ enclosing_range_start [..] RetainedReceiverTypes#
 module RetainedReceiverTypes
#       ^^^^^^^^^^^^^^^^^^^^^ definition [..] RetainedReceiverTypes#
   VALUES = %w[a b].freeze
#  ^^^^^^ definition [..] RetainedReceiverTypes#VALUES.
#                   ^^^^^^ reference [..] Kernel#freeze().
 
#  ⌄ enclosing_range_start [..] `<Class:RetainedReceiverTypes>`#copy().
   def self.copy
#           ^^^^ definition [..] `<Class:RetainedReceiverTypes>`#copy().
     VALUES.dup
#    ^^^^^^ reference [..] RetainedReceiverTypes#VALUES.
#           ^^^ reference [..] Kernel#dup().
     VALUES.inspect
#    ^^^^^^ reference [..] RetainedReceiverTypes#VALUES.
#           ^^^^^^^ reference [..] Array#inspect().
     VALUES.freeze
#    ^^^^^^ reference [..] RetainedReceiverTypes#VALUES.
#           ^^^^^^ reference [..] Kernel#freeze().
     options = {x: 1, y: 2}
#    ^^^^^^^ definition local 4$76085487
     options.keys
#    ^^^^^^^ reference local 4$76085487
#            ^^^^ reference [..] Hash#keys().
     options.delete(:x)
#    ^^^^^^^ reference local 4$76085487
#            ^^^^^^ reference [..] Hash#delete().
   end
#    ⌃ enclosing_range_end [..] `<Class:RetainedReceiverTypes>`#copy().
 end
#  ⌃ enclosing_range_end [..] RetainedReceiverTypes#
 
 sig { params(value: T.anything).void }
#^^^ reference [..] T#Sig#sig().
#      ^^^^^^ reference [..] T#Private#Methods#DeclBuilder#params().
#                    ^ reference [..] T#
#                      ^^^^^^^^ reference [..] `<Class:T>`#anything().
#                                ^^^^ reference [..] T#Private#Methods#DeclBuilder#void().
#⌄ enclosing_range_start [..] Object#any_value().
 def any_value(value)
#    ^^^^^^^^^ definition [..] Object#any_value().
#              ^^^^^ definition local 1$239422357
   value.instance_variable_get(:@data)
#  ^^^^^ reference local 1$239422357
#        ^^^^^^^^^^^^^^^^^^^^^ reference [..] Kernel#instance_variable_get().
   value.inspect
#  ^^^^^ reference local 1$239422357
#        ^^^^^^^ reference [..] Kernel#inspect().
   value.to_s
#  ^^^^^ reference local 1$239422357
#        ^^^^ reference [..] Kernel#to_s().
   value.no_such_method
#  ^^^^^ reference local 1$239422357
 end
#  ⌃ enclosing_range_end [..] Object#any_value().
 
 # Do not treat a known BasicObject as Object.
 sig { params(value: BasicObject).void }
#^^^ reference [..] T#Sig#sig().
#      ^^^^^^ reference [..] T#Private#Methods#DeclBuilder#params().
#                    ^^^^^^^^^^^ reference [..] BasicObject#
#                                 ^^^^ reference [..] T#Private#Methods#DeclBuilder#void().
#⌄ enclosing_range_start [..] Object#basic_value().
 def basic_value(value)
#    ^^^^^^^^^^^ definition [..] Object#basic_value().
#                ^^^^^ definition local 1$4188840037
   value.instance_variable_get(:@data)
#  ^^^^^ reference local 1$4188840037
 end
#  ⌃ enclosing_range_end [..] Object#basic_value().
 
 sig { void }
#^^^ reference [..] T#Sig#sig().
#      ^^^^ reference [..] T#Private#Methods#DeclBuilder#void().
#⌄ enclosing_range_start [..] Object#implicit_block().
 def implicit_block
#    ^^^^^^^^^^^^^^ definition [..] Object#implicit_block().
   yield if block_given?
#           ^^^^^^^^^^^^ reference [..] Kernel#`block_given?`().
 end
#  ⌃ enclosing_range_end [..] Object#implicit_block().
 
 sig { params(block: T.nilable(T.proc.void)).void }
#^^^ reference [..] T#Sig#sig().
#      ^^^^^^ reference [..] T#Private#Methods#DeclBuilder#params().
#                    ^ reference [..] T#
#                      ^^^^^^^ reference [..] `<Class:T>`#nilable().
#                              ^ reference [..] T#
#                                ^^^^ reference [..] `<Class:T>`#proc().
#                                            ^^^^ reference [..] T#Private#Methods#DeclBuilder#void().
#⌄ enclosing_range_start [..] Object#explicit_block().
 def explicit_block(&block)
#    ^^^^^^^^^^^^^^ definition [..] Object#explicit_block().
#                    ^^^^^ definition local 1$2664246013
   yield if block_given?
#  ^^^^^ reference local 1$2664246013
#           ^^^^^^^^^^^^ reference [..] Kernel#`block_given?`().
 end
#  ⌃ enclosing_range_end [..] Object#explicit_block().
