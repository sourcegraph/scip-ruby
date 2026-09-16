 # typed: true
 # check-errors: true
 # Adapted from test/testdata/desugar/shadow_args.rb.
 
#⌄ enclosing_range_start [..] BlockLocalScopes#
 class BlockLocalScopes
#      ^^^^^^^^^^^^^^^^ definition [..] BlockLocalScopes#
#  ⌄ enclosing_range_start [..] BlockLocalScopes#ordinary_block().
   def ordinary_block
#      ^^^^^^^^^^^^^^ definition [..] BlockLocalScopes#ordinary_block().
     value = "outer"
#    ^^^^^ definition local 1$4220414333
     [1, 2].each do |; value|
#           ^^^^ reference [..] Array#each().
#                      ^^^^^ definition local 2$4220414333
       value = 1
#      ^^^^^ reference (write) local 2$4220414333
       value.times { value.to_s }
#      ^^^^^ reference local 2$4220414333
#            ^^^^^ reference [..] Integer#times().
#                    ^^^^^ reference local 2$4220414333
#                          ^^^^ reference [..] Integer#to_s().
     end
     value.upcase
#    ^^^^^ reference local 1$4220414333
#          ^^^^^^ reference [..] String#upcase().
   end
#    ⌃ enclosing_range_end [..] BlockLocalScopes#ordinary_block().
 
#  ⌄ enclosing_range_start [..] BlockLocalScopes#proc_block().
   def proc_block
#      ^^^^^^^^^^ definition [..] BlockLocalScopes#proc_block().
     value = "outer"
#    ^^^^^ definition local 1$4123307135
     proc { |; value|
#    ^^^^ reference [..] Kernel#proc().
#              ^^^^^ definition local 2$4123307135
       value = 2
#      ^^^^^ reference (write) local 2$4123307135
       value.to_s
#      ^^^^^ reference local 2$4123307135
#            ^^^^ reference [..] Integer#to_s().
     }
     value.downcase
#    ^^^^^ reference local 1$4123307135
#          ^^^^^^^^ reference [..] String#downcase().
   end
#    ⌃ enclosing_range_end [..] BlockLocalScopes#proc_block().
 
#  ⌄ enclosing_range_start [..] BlockLocalScopes#lambda_block().
   def lambda_block
#      ^^^^^^^^^^^^ definition [..] BlockLocalScopes#lambda_block().
     value = "outer"
#    ^^^^^ definition local 1$3585120896
     lambda do |; value|
#    ^^^^^^ reference [..] Kernel#lambda().
#                 ^^^^^ definition local 2$3585120896
       value = 3
#      ^^^^^ reference (write) local 2$3585120896
       value.to_s
#      ^^^^^ reference local 2$3585120896
#            ^^^^ reference [..] Integer#to_s().
     end
     value.downcase
#    ^^^^^ reference local 1$3585120896
#          ^^^^^^^^ reference [..] String#downcase().
   end
#    ⌃ enclosing_range_end [..] BlockLocalScopes#lambda_block().
 
#  ⌄ enclosing_range_start [..] BlockLocalScopes#arrow_lambda().
   def arrow_lambda
#      ^^^^^^^^^^^^ definition [..] BlockLocalScopes#arrow_lambda().
     value = "outer"
#    ^^^^^ definition local 1$2821688604
     ->(; value) do
#    ^^ reference [..] Kernel#
#    ^^ reference [..] Kernel#lambda().
#         ^^^^^ definition local 3$2821688604
       value = 4
#      ^^^^^ reference (write) local 3$2821688604
       value.to_s
#      ^^^^^ reference local 3$2821688604
#            ^^^^ reference [..] Integer#to_s().
     end
     value.downcase
#    ^^^^^ reference local 1$2821688604
#          ^^^^^^^^ reference [..] String#downcase().
   end
#    ⌃ enclosing_range_end [..] BlockLocalScopes#arrow_lambda().
 end
#  ⌃ enclosing_range_end [..] BlockLocalScopes#
