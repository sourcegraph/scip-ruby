 # typed: true
 # check-errors: true
 
 customer = "Ada"
#^^^^^^^^ definition local 1$119448696
 receiver = CrossFileKeywords.new
#^^^^^^^^ definition local 2$119448696
#           ^^^^^^^^^^^^^^^^^ reference [..] CrossFileKeywords#
#                             ^^^ reference [..] Class#new().
 receiver.deliver(customer: customer)
#^^^^^^^^ reference local 2$119448696
#         ^^^^^^^ reference [..] KeywordMixin#deliver().
#                 ^^^^^^^^ reference [..] KeywordMixin#deliver().(customer)
#                           ^^^^^^^^ reference local 1$119448696
 receiver.deliver(customer:)
#^^^^^^^^ reference local 2$119448696
#         ^^^^^^^ reference [..] KeywordMixin#deliver().
#                 ^^^^^^^^ reference local 1$119448696
#                 ^^^^^^^^ reference [..] KeywordMixin#deliver().(customer)
 receiver.unused(customer:)
#^^^^^^^^ reference local 2$119448696
#         ^^^^^^ reference [..] CrossFileKeywords#unused().
#                ^^^^^^^^ reference local 1$119448696
#                ^^^^^^^^ reference [..] CrossFileKeywords#unused().(customer)
