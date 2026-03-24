 # typed: strict
 
#⌄ enclosing_range_start [..] ActiveSupport#TestCase#
 class ActiveSupport::TestCase
#      ^^^^^^^^^^^^^ reference [..] ActiveSupport#
#                     ^^^^^^^^ definition [..] ActiveSupport#TestCase#
 end
#  ⌃ enclosing_range_end [..] ActiveSupport#TestCase#
 
#⌄ enclosing_range_start [..] MyTest#
 class MyTest < ActiveSupport::TestCase
#      ^^^^^^ definition [..] MyTest#
#               ^^^^^^^^^^^^^ reference [..] ActiveSupport#
#                              ^^^^^^^^ reference [..] ActiveSupport#TestCase#
   extend T::Sig
#  ^^^^^^ reference [..] Kernel#extend().
   # Helper instance method
   sig { params(test: T.untyped).returns(T::Boolean) }
#                                           ^^^^^^^ reference [..] T#Boolean.
#  ⌄ enclosing_range_start [..] MyTest#assert().
   def assert(test)
#      ^^^^^^ definition [..] MyTest#assert().
#             ^^^^ definition local 1$2774883451
     test ? true : false
   end
#    ⌃ enclosing_range_end [..] MyTest#assert().
 
   # Helper method to direct calls to `test` instead of Kernel#test
   sig { params(args: T.untyped, block: T.nilable(T.proc.void)).void }
#  ⌄ enclosing_range_start [..] `<Class:MyTest>`#test().
   def self.test(*args, &block)
#           ^^^^ definition [..] `<Class:MyTest>`#test().
   end
#    ⌃ enclosing_range_end [..] `<Class:MyTest>`#test().
 
#  ⌄ enclosing_range_start [..] MyTest#`<before>`().
   setup do
#  ^^^^^ definition [..] MyTest#`<before>`().
     @a = T.let(1, Integer)
#    ^^ definition [..] MyTest#`@a`.
#    ^^^^^^^^^^^^^^^^^^^^^^ reference [..] MyTest#`@a`.
#                  ^^^^^^^ definition local 1$2938098190
#                  ^^^^^^^ reference [..] Integer#
   end
#    ⌃ enclosing_range_end [..] MyTest#`<before>`().
 
#  ⌄ enclosing_range_start [..] MyTest#test_valid_method_call().
   test "valid method call" do
#       ^^^^^^^^^^^^^^^^^^^ definition [..] MyTest#test_valid_method_call().
   end
#    ⌃ enclosing_range_end [..] MyTest#test_valid_method_call().
 
#  ⌄ enclosing_range_start [..] MyTest#test_block_is_evaluated_in_the_context_of_an_instance().
   test "block is evaluated in the context of an instance" do
#       ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ definition [..] MyTest#test_block_is_evaluated_in_the_context_of_an_instance().
     assert true
   end
#    ⌃ enclosing_range_end [..] MyTest#test_block_is_evaluated_in_the_context_of_an_instance().
 end
#  ⌃ enclosing_range_end [..] MyTest#
 
#⌄ enclosing_range_start [..] NoMatchTest#
 class NoMatchTest < ActiveSupport::TestCase
#      ^^^^^^^^^^^ definition [..] NoMatchTest#
#                    ^^^^^^^^^^^^^ reference [..] ActiveSupport#
#                                   ^^^^^^^^ reference [..] ActiveSupport#TestCase#
   extend T::Sig
#  ^^^^^^ reference [..] Kernel#extend().
 
   sig { params(block: T.proc.void).void }
#  ⌄ enclosing_range_start [..] `<Class:NoMatchTest>`#setup().
   def self.setup(&block); end
#           ^^^^^ definition [..] `<Class:NoMatchTest>`#setup().
#                            ⌃ enclosing_range_end [..] `<Class:NoMatchTest>`#setup().
 
   sig { params(block: T.proc.void).void }
#  ⌄ enclosing_range_start [..] `<Class:NoMatchTest>`#teardown().
   def self.teardown(&block); end
#           ^^^^^^^^ definition [..] `<Class:NoMatchTest>`#teardown().
#                               ⌃ enclosing_range_end [..] `<Class:NoMatchTest>`#teardown().
 end
#  ⌃ enclosing_range_end [..] NoMatchTest#
 
#⌄ enclosing_range_start [..] NoParentClass#
 class NoParentClass
#      ^^^^^^^^^^^^^ definition [..] NoParentClass#
   extend T::Sig
#  ^^^^^^ reference [..] Kernel#extend().
 
   sig { params(block: T.proc.void).void }
#  ⌄ enclosing_range_start [..] `<Class:NoParentClass>`#setup().
   def self.setup(&block); end
#           ^^^^^ definition [..] `<Class:NoParentClass>`#setup().
#                            ⌃ enclosing_range_end [..] `<Class:NoParentClass>`#setup().
 
   sig { params(block: T.proc.void).void }
#  ⌄ enclosing_range_start [..] `<Class:NoParentClass>`#teardown().
   def self.teardown(&block); end
#           ^^^^^^^^ definition [..] `<Class:NoParentClass>`#teardown().
#                               ⌃ enclosing_range_end [..] `<Class:NoParentClass>`#teardown().
 
   sig { params(a: T.untyped, b: T.untyped).void }
#  ⌄ enclosing_range_start [..] NoParentClass#assert_equal().
   def assert_equal(a, b); end
#      ^^^^^^^^^^^^ definition [..] NoParentClass#assert_equal().
#                            ⌃ enclosing_range_end [..] NoParentClass#assert_equal().
 
#  ⌄ enclosing_range_start [..] NoParentClass#`<before>`().
   setup do
#  ^^^^^ definition [..] NoParentClass#`<before>`().
     @a = T.let(1, Integer)
#    ^^ definition [..] NoParentClass#`@a`.
#    ^^^^^^^^^^^^^^^^^^^^^^ reference [..] NoParentClass#`@a`.
#                  ^^^^^^^ definition local 1$2938098190
#                  ^^^^^^^ reference [..] Integer#
   end
#    ⌃ enclosing_range_end [..] NoParentClass#`<before>`().
 
#  ⌄ enclosing_range_start [..] NoParentClass#test_it_works().
   test "it works" do
#       ^^^^^^^^^^ definition [..] NoParentClass#test_it_works().
     assert_equal 1, @a
   end
#    ⌃ enclosing_range_end [..] NoParentClass#test_it_works().
 
#  ⌄ enclosing_range_start [..] NoParentClass#teardown().
   teardown do
#  ^^^^^^^^ definition [..] NoParentClass#teardown().
     @a = 5
#    ^^ definition [..] NoParentClass#`@a`.
#    ^^^^^^ reference [..] NoParentClass#`@a`.
   end
#    ⌃ enclosing_range_end [..] NoParentClass#teardown().
 end
#  ⌃ enclosing_range_end [..] NoParentClass#
