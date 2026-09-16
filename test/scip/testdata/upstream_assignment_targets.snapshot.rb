 # typed: true
 # check-errors: true
 # Adapted from test/prism_regression/target_nodes.rb.
 
#⌄ enclosing_range_start [..] AssignmentTargets#
 class AssignmentTargets
#      ^^^^^^^^^^^^^^^^^ definition [..] AssignmentTargets#
   extend T::Sig
#  ^^^^^^ reference [..] Kernel#extend().
 
   sig { params(value: Integer).returns(Integer) }
#                      ^^^^^^^ reference [..] Integer#
#                                       ^^^^^^^ reference [..] Integer#
#  ⌄ enclosing_range_start [..] AssignmentTargets#`value=`().
   def value=(value)
#      ^^^^^^ definition [..] AssignmentTargets#`value=`().
#             ^^^^^ definition local 1$156058915
     value
#    ^^^^^ reference local 1$156058915
   end
#    ⌃ enclosing_range_end [..] AssignmentTargets#`value=`().
 
   sig { params(error: StandardError).returns(StandardError) }
#                      ^^^^^^^^^^^^^ reference [..] StandardError#
#                                             ^^^^^^^^^^^^^ reference [..] StandardError#
#  ⌄ enclosing_range_start [..] AssignmentTargets#`error=`().
   def error=(error)
#      ^^^^^^ definition [..] AssignmentTargets#`error=`().
#             ^^^^^ definition local 1$376527406
     error
#    ^^^^^ reference local 1$376527406
   end
#    ⌃ enclosing_range_end [..] AssignmentTargets#`error=`().
 
   sig { params(key: Symbol, value: T.any(Integer, StandardError)).returns(T.any(Integer, StandardError)) }
#                    ^^^^^^ reference [..] Symbol#
#                                         ^^^^^^^ reference [..] Integer#
#                                                  ^^^^^^^^^^^^^ reference [..] StandardError#
#                                                                                ^^^^^^^ reference [..] Integer#
#                                                                                         ^^^^^^^^^^^^^ reference [..] StandardError#
#  ⌄ enclosing_range_start [..] AssignmentTargets#`[]=`().
   def []=(key, value)
#      ^^^ definition [..] AssignmentTargets#`[]=`().
#               ^^^^^ definition local 1$3952031922
     value
#    ^^^^^ reference local 1$3952031922
   end
#    ⌃ enclosing_range_end [..] AssignmentTargets#`[]=`().
 end
#  ⌃ enclosing_range_end [..] AssignmentTargets#
 
 target = AssignmentTargets.new
#^^^^^^ definition local 1$217974539
#         ^^^^^^^^^^^^^^^^^ reference [..] AssignmentTargets#
#                           ^^^ reference [..] Class#new().
 
 for target.value in [1, 2]
#    ^^^^^^ reference local 1$217974539
#           ^^^^^ reference [..] AssignmentTargets#`value=`().
   target.value = 3
#  ^^^^^^ reference local 1$217974539
#         ^^^^^ reference [..] AssignmentTargets#`value=`().
 end
 
 for target[:value] in [1, 2]
#    ^^^^^^ reference local 1$217974539
#          ^ reference [..] AssignmentTargets#`[]=`().
   target[:value] = 3
#  ^^^^^^ reference local 1$217974539
#        ^ reference [..] AssignmentTargets#`[]=`().
 end
 
 begin
   raise "property target"
#  ^^^^^ reference [..] Kernel#raise().
 rescue StandardError => target.error
#       ^^^^^^^^^^^^^ reference [..] StandardError#
#                        ^^^^^^ reference local 1$217974539
#                               ^^^^^ reference [..] AssignmentTargets#`error=`().
   target.error = StandardError.new("handled")
#  ^^^^^^ reference local 1$217974539
#         ^^^^^ reference [..] AssignmentTargets#`error=`().
#                 ^^^^^^^^^^^^^ reference [..] StandardError#
#                               ^^^ reference [..] Exception#initialize().
 end
 
 begin
   raise "indexed target"
#  ^^^^^ reference [..] Kernel#raise().
 rescue StandardError => target[:error]
#       ^^^^^^^^^^^^^ reference [..] StandardError#
#                        ^^^^^^ reference local 1$217974539
#                              ^ reference [..] AssignmentTargets#`[]=`().
   target[:error] = StandardError.new("handled")
#  ^^^^^^ reference local 1$217974539
#        ^ reference [..] AssignmentTargets#`[]=`().
#                   ^^^^^^^^^^^^^ reference [..] StandardError#
#                                 ^^^ reference [..] Exception#initialize().
 end
