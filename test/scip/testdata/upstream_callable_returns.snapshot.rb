 # typed: true
 # check-errors: true
 # Adapted from test/testdata/infer/infer_lambda.rb and infer_proc.rb.
 
#⌄ enclosing_range_start [..] InferredProduct#
 class InferredProduct
#      ^^^^^^^^^^^^^^^ definition [..] InferredProduct#
   extend T::Sig
#  ^^^^^^ reference [..] Kernel#extend().
 
   sig { returns(String) }
#                ^^^^^^ reference [..] String#
#  ⌄ enclosing_range_start [..] InferredProduct#name().
   def name
#      ^^^^ definition [..] InferredProduct#name().
     "product"
   end
#    ⌃ enclosing_range_end [..] InferredProduct#name().
 end
#  ⌃ enclosing_range_end [..] InferredProduct#
 
 arrow_factory = -> { InferredProduct.new }
#^^^^^^^^^^^^^ definition local 3$119448696
#                ^^ reference [..] Kernel#
#                ^^ reference [..] Kernel#lambda().
#                     ^^^^^^^^^^^^^^^ reference [..] InferredProduct#
#                                     ^^^ reference [..] Class#new().
 arrow_factory.call.name.upcase
#^^^^^^^^^^^^^ reference local 3$119448696
#              ^^^^ reference [..] Proc0#call().
#                   ^^^^ reference [..] InferredProduct#name().
#                        ^^^^^^ reference [..] String#upcase().
 
 lambda_factory = lambda { InferredProduct.new }
#^^^^^^^^^^^^^^ definition local 5$119448696
#                 ^^^^^^ reference [..] Kernel#lambda().
#                          ^^^^^^^^^^^^^^^ reference [..] InferredProduct#
#                                          ^^^ reference [..] Class#new().
 lambda_factory.call.name.upcase
#^^^^^^^^^^^^^^ reference local 5$119448696
#               ^^^^ reference [..] Proc0#call().
#                    ^^^^ reference [..] InferredProduct#name().
#                         ^^^^^^ reference [..] String#upcase().
 
 proc_factory = proc { InferredProduct.new }
#^^^^^^^^^^^^ definition local 7$119448696
#               ^^^^ reference [..] Kernel#proc().
#                      ^^^^^^^^^^^^^^^ reference [..] InferredProduct#
#                                      ^^^ reference [..] Class#new().
 proc_factory.call.name.upcase
#^^^^^^^^^^^^ reference local 7$119448696
#             ^^^^ reference [..] Proc0#call().
#                  ^^^^ reference [..] InferredProduct#name().
#                       ^^^^^^ reference [..] String#upcase().
 
 return_factory = ->(early) do
#^^^^^^^^^^^^^^ definition local 12$119448696
#                 ^^ reference [..] Kernel#
#                 ^^ reference [..] Kernel#lambda().
#                    ^^^^^ definition local 9$119448696
   return InferredProduct.new if early
#         ^^^^^^^^^^^^^^^ reference [..] InferredProduct#
#                         ^^^ reference [..] Class#new().
   InferredProduct.new
#  ^^^^^^^^^^^^^^^ reference [..] InferredProduct#
#                  ^^^ reference [..] Class#new().
 end
 return_factory.call(true).name.upcase
#^^^^^^^^^^^^^^ reference local 12$119448696
#               ^^^^ reference [..] Proc1#call().
#                          ^^^^ reference [..] InferredProduct#name().
#                               ^^^^^^ reference [..] String#upcase().
 
 next_factory = proc do |early|
#^^^^^^^^^^^^ definition local 16$119448696
#               ^^^^ reference [..] Kernel#proc().
#                        ^^^^^ definition local 13$119448696
   next InferredProduct.new if early
#       ^^^^^^^^^^^^^^^ reference [..] InferredProduct#
#                       ^^^ reference [..] Class#new().
   InferredProduct.new
#  ^^^^^^^^^^^^^^^ reference [..] InferredProduct#
#                  ^^^ reference [..] Class#new().
 end
 next_factory.call(false).name.upcase
#^^^^^^^^^^^^ reference local 16$119448696
#             ^^^^ reference [..] Proc1#call().
#                         ^^^^ reference [..] InferredProduct#name().
#                              ^^^^^^ reference [..] String#upcase().
