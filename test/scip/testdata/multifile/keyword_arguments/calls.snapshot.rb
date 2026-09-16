 # typed: true
 # check-errors: true
 
 customer = "Ada"
#^^^^^^^^ definition local 1$217974539
 receiver = CrossFileKeywords.new
#^^^^^^^^ definition local 2$217974539
#           ^^^^^^^^^^^^^^^^^ reference [..] CrossFileKeywords#
#                             ^^^ reference [..] Class#new().
 receiver.deliver(customer: customer)
#^^^^^^^^ reference local 2$217974539
#         ^^^^^^^ reference [..] KeywordMixin#deliver().
#                 ^^^^^^^^ reference [..] KeywordMixin#deliver().(customer)
#                           ^^^^^^^^ reference local 1$217974539
 receiver.deliver(customer:)
#^^^^^^^^ reference local 2$217974539
#         ^^^^^^^ reference [..] KeywordMixin#deliver().
#                 ^^^^^^^^ reference local 1$217974539
#                 ^^^^^^^^ reference [..] KeywordMixin#deliver().(customer)
 receiver.unused(customer:)
#^^^^^^^^ reference local 2$217974539
#         ^^^^^^ reference [..] CrossFileKeywords#unused().
#                ^^^^^^^^ reference local 1$217974539
#                ^^^^^^^^ reference [..] CrossFileKeywords#unused().(customer)
