 # typed: strict
 
 class ActiveSupport::TestCase
#      ^^^^^^^^^^^^^ reference [..] ActiveSupport#
#                     ^^^^^^^^ definition [..] ActiveSupport#TestCase#
 end
 
 class MyTest < ActiveSupport::TestCase
#      ^^^^^^ definition [..] MyTest#
#               ^^^^^^^^^^^^^ reference [..] ActiveSupport#
#                              ^^^^^^^^ definition [..] ActiveSupport#TestCase#
   extend T::Sig
   # Helper instance method
   sig { params(test: T.untyped).returns(T::Boolean) }
#                                           ^^^^^^^ reference [..] T#Boolean.
   def assert(test)
#      ^^^^^^ definition [..] MyTest#assert().
#             ^^^^ definition local 1~#2774883451
     test ? true : false
   end
 
   # Helper method to direct calls to `test` instead of Kernel#test
   sig { params(args: T.untyped, block: T.nilable(T.proc.void)).void }
#                                                        ^^^^ reference [..] `<Class:<DeclBuilderForProcs>>`#void().
   def self.test(*args, &block)
#           ^^^^ definition [..] `<Class:MyTest>`#test().
   end
 
   setup do
#  ^^^^^ definition [..] MyTest#initialize().
     @a = T.let(1, Integer)
   end
 
   test "valid method call" do
#       ^^^^^^^^^^^^^^^^^^^ definition [..] MyTest#test_valid_method_call().
   end
 
   test "block is evaluated in the context of an instance" do
#       ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ definition [..] MyTest#test_block_is_evaluated_in_the_context_of_an_instance().
     assert true
   end
 end
 
 class NoMatchTest < ActiveSupport::TestCase
#      ^^^^^^^^^^^ definition [..] NoMatchTest#
#                    ^^^^^^^^^^^^^ reference [..] ActiveSupport#
#                                   ^^^^^^^^ definition [..] ActiveSupport#TestCase#
   extend T::Sig
 
   sig { params(block: T.proc.void).void }
#                             ^^^^ reference [..] `<Class:<DeclBuilderForProcs>>`#void().
   def self.setup(&block); end
#           ^^^^^ definition [..] `<Class:NoMatchTest>`#setup().
 
   sig { params(block: T.proc.void).void }
#                             ^^^^ reference [..] `<Class:<DeclBuilderForProcs>>`#void().
   def self.teardown(&block); end
#           ^^^^^^^^ definition [..] `<Class:NoMatchTest>`#teardown().
 end
 
 class NoParentClass
#      ^^^^^^^^^^^^^ definition [..] NoParentClass#
   extend T::Sig
 
   sig { params(block: T.proc.void).void }
#                             ^^^^ reference [..] `<Class:<DeclBuilderForProcs>>`#void().
   def self.setup(&block); end
#           ^^^^^ definition [..] `<Class:NoParentClass>`#setup().
 
   sig { params(block: T.proc.void).void }
#                             ^^^^ reference [..] `<Class:<DeclBuilderForProcs>>`#void().
   def self.teardown(&block); end
#           ^^^^^^^^ definition [..] `<Class:NoParentClass>`#teardown().
 
   sig { params(a: T.untyped, b: T.untyped).void }
   def assert_equal(a, b); end
#      ^^^^^^^^^^^^ definition [..] NoParentClass#assert_equal().
 
   setup do
#  ^^^^^ definition [..] NoParentClass#initialize().
     @a = T.let(1, Integer)
   end
 
   test "it works" do
#       ^^^^^^^^^^ definition [..] NoParentClass#test_it_works().
     assert_equal 1, @a
   end
 
   teardown do
#  ^^^^^^^^ definition [..] NoParentClass#teardown().
     @a = 5
   end
 end
