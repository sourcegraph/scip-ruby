 # typed: true
 class MyTest
#      ^^^^^^ definition [..] MyTest#
     def outside_method
#        ^^^^^^^^^^^^^^ definition [..] MyTest#outside_method().
     end
 
     it "works outside" do
#    ^^^ definition [..] MyTest#`<it 'works outside'>`().
         outside_method
     end
 
     it "allows constants inside of IT" do
#    ^^^^^^^ definition [..] MyTest#`<it 'allows constants inside of IT'>`().
       CONST = 10
#      ^^^^^ definition [..] MyTest#CONST.
#      ^^^^^^^^^^ reference [..] Kernel#
     end
 
     it "allows let-ed constants inside of IT" do
#    ^^^^^^^^^^^ definition [..] MyTest#`<it 'allows let-ed constants inside of IT'>`().
       C2 = T.let(10, Integer)
#      ^^ definition [..] MyTest#C2.
#      ^^^^^^^^^^^^^^^^^^^^^^^ reference [..] Kernel#
#                     ^^^^^^^ reference [..] Integer#
     end
 
     it "allows path constants inside of IT" do
       C3 = Mod::C
#      ^^ definition [..] MyTest#C3.
#           ^^^ reference [..] Mod#
#                ^ reference [..] Mod#C#
#                ^^^^ definition [..] MyTest#`<it 'allows path constants inside of IT'>`().
       C3.new
     end
 
     describe "some inner tests" do
#             ^^^^^^^^^^^^^^^^^^ definition [..] MyTest#`<describe 'some inner tests'>`#
         def inside_method
#            ^^^^^^^^^^^^^ definition [..] MyTest#`<describe 'some inner tests'>`#inside_method().
         end
 
         it "works inside" do
#        ^^^^^^^^^^^^^^^^^^^^^ definition [..] MyTest#`<describe 'some inner tests'>`#`<it 'works inside'>`().
             outside_method
             inside_method
         end
     end
 
     def instance_helper; end
#        ^^^^^^^^^^^^^^^ definition [..] MyTest#instance_helper().
 
     before do
#    ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ definition [..] MyTest#initialize().
         @foo = T.let(3, Integer)
         instance_helper
     end
 
     it 'can read foo' do
#    ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ definition [..] MyTest#`<it 'can read foo'>`().
         T.assert_type!(@foo, Integer)
         instance_helper
     end
 
     def self.random_method
#             ^^^^^^^^^^^^^ definition [..] `<Class:MyTest>`#random_method().
     end
 
     describe Object do
#             ^^^^^^ definition [..] MyTest#`<describe 'Object'>`#
         it Object do
#        ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ definition [..] MyTest#`<describe 'Object'>`#`<it 'Object'>`().
#        ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ definition [..] MyTest#`<describe 'Object'>`#`<it 'Object'>`().
#           ^^^^^^ reference [..] Object#
         end
         it Object do
#           ^^^^^^ reference [..] Object#
         end
     end
 
     def self.it(*args)
#             ^^ definition [..] `<Class:MyTest>`#it().
     end
     it "ignores methods without a block"
#    ^^ reference [..] `<Class:MyTest>`#it().
 
     junk.it "ignores non-self calls" do
         junk
     end
 
     describe "a non-ideal situation" do
#             ^^^^^^^^^^^^^^^^^^^^^^^ definition [..] MyTest#`<describe 'a non-ideal situation'>`#
       it "contains nested describes" do
#      ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ definition [..] MyTest#`<describe 'a non-ideal situation'>`#`<it 'contains nested describes'>`().
         describe "nobody should write this but we should still parse it" do
#                 ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ definition [..] MyTest#`<describe 'a non-ideal situation'>`#`<describe 'nobody should write this but we should still parse it'>`#
         end
       end
     end
 end
 
 def junk
#    ^^^^ definition [..] Object#junk().
 end
 
 
 module Mod
#       ^^^ definition [..] Mod#
   class C
#        ^ definition [..] Mod#C#
   end
 end
