 # typed: true
 # check-errors: true
 # options: showDocs
 
#⌄ enclosing_range_start [..] KeywordMixin#
 module KeywordMixin
#       ^^^^^^^^^^^^ definition [..] KeywordMixin#
#       documentation
#       | ```ruby
#       | module KeywordMixin
#       | ```
   extend T::Sig
#  ^^^^^^ reference [..] Kernel#extend().
   sig { params(customer: String).returns(String) }
#                         ^^^^^^ reference [..] String#
#                                         ^^^^^^ reference [..] String#
#  ⌄ enclosing_range_start [..] KeywordMixin#deliver().
   def deliver(customer:)
#      ^^^^^^^ definition [..] KeywordMixin#deliver().
#      documentation
#      | ```ruby
#      | sig { params(customer: String).returns(String) }
#      | def deliver(customer:)
#      | ```
#              ^^^^^^^^ definition [..] KeywordMixin#deliver().(customer)
#              documentation
#              | ```ruby
#              | customer (String)
#              | ```
     customer.upcase
#    ^^^^^^^^ reference [..] KeywordMixin#deliver().(customer)
#             ^^^^^^ reference [..] String#upcase().
   end
#    ⌃ enclosing_range_end [..] KeywordMixin#deliver().
 end
#  ⌃ enclosing_range_end [..] KeywordMixin#
 
#⌄ enclosing_range_start [..] CrossFileKeywords#
 class CrossFileKeywords
#      ^^^^^^^^^^^^^^^^^ definition [..] CrossFileKeywords#
#      documentation
#      | ```ruby
#      | class CrossFileKeywords
#      | ```
   include KeywordMixin
#  ^^^^^^^ reference [..] Module#include().
#          ^^^^^^^^^^^^ reference [..] KeywordMixin#
#          ^^^^^^^^^^^^ reference [..] KeywordMixin#
   extend T::Sig
#  ^^^^^^ reference [..] Kernel#extend().
 
   sig { params(customer: String).void }
#                         ^^^^^^ reference [..] String#
#  ⌄ enclosing_range_start [..] CrossFileKeywords#unused().
   def unused(customer: "default")
#      ^^^^^^ definition [..] CrossFileKeywords#unused().
#      documentation
#      | ```ruby
#      | sig { params(customer: String).void }
#      | def unused(customer: …)
#      | ```
#             ^^^^^^^^ definition [..] CrossFileKeywords#unused().(customer)
#             documentation
#             | ```ruby
#             | customer (String)
#             | ```
   end
#    ⌃ enclosing_range_end [..] CrossFileKeywords#unused().
 end
#  ⌃ enclosing_range_end [..] CrossFileKeywords#
