 # typed: true
#⌄ enclosing_range_start [..] MyTest#
 class MyTest
#      ^^^^^^ definition [..] MyTest#
#    ⌄ enclosing_range_start [..] MyTest#outside_method().
     def outside_method
#        ^^^^^^^^^^^^^^ definition [..] MyTest#outside_method().
     end
#      ⌃ enclosing_range_end [..] MyTest#outside_method().
 
#    ⌄ enclosing_range_start [..] MyTest#`<it 'works outside'>`().
     it "works outside" do
#       ^^^^^^^^^^^^^^^ definition [..] MyTest#`<it 'works outside'>`().
         x = outside_method
#        ^ definition local 1$1914741329
#            ^^^^^^^^^^^^^^ reference [..] MyTest#outside_method().
         x = x + 1
#        ^ reference (write) local 1$1914741329
#            ^ reference local 1$1914741329
         return
     end
#      ⌃ enclosing_range_end [..] MyTest#`<it 'works outside'>`().
 
#    ⌄ enclosing_range_start [..] MyTest#`<it 'allows constants inside of IT'>`().
     it "allows constants inside of IT" do
#       ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ definition [..] MyTest#`<it 'allows constants inside of IT'>`().
       CONST = 10
#      ^^^^^ definition [..] MyTest#CONST.
#      ^^^^^^^^^^ reference [..] Kernel#
#      ^^^^^^^^^^ reference [..] Kernel#raise().
#      ^^^^^^^^^^ reference [..] Module#
     end
#      ⌃ enclosing_range_end [..] MyTest#`<it 'allows constants inside of IT'>`().
 
#    ⌄ enclosing_range_start [..] MyTest#`<it 'allows let-ed constants inside of IT'>`().
     it "allows let-ed constants inside of IT" do
#       ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ definition [..] MyTest#`<it 'allows let-ed constants inside of IT'>`().
       C2 = T.let(10, Integer)
#      ^^ definition [..] MyTest#C2.
#      ^^^^^^^^^^^^^^^^^^^^^^^ reference [..] Kernel#
#      ^^^^^^^^^^^^^^^^^^^^^^^ reference [..] Kernel#raise().
#      ^^^^^^^^^^^^^^^^^^^^^^^ reference [..] Module#
#                     ^^^^^^^ definition local 1$95163902
#                     ^^^^^^^ definition local 3$119448696
#                     ^^^^^^^ reference [..] Integer#
     end
#      ⌃ enclosing_range_end [..] MyTest#`<it 'allows let-ed constants inside of IT'>`().
 
#    ⌄ enclosing_range_start [..] MyTest#`<it 'allows path constants inside of IT'>`().
     it "allows path constants inside of IT" do
#       ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ definition [..] MyTest#`<it 'allows path constants inside of IT'>`().
       C3 = Mod::C
#      ^^ definition [..] MyTest#C3.
#      relation reference=[..] Mod#C#
#           ^^^ reference [..] Mod#
#                ^ reference [..] Mod#C#
       C3.new
#      ^^ reference [..] MyTest#C3.
#         ^^^ reference [..] Class#new().
     end
#      ⌃ enclosing_range_end [..] MyTest#`<it 'allows path constants inside of IT'>`().
 
#    ⌄ enclosing_range_start [..] MyTest#`<describe 'some inner tests'>`#
     describe "some inner tests" do
#             ^^^^^^^^^^^^^^^^^^ reference [..] MyTest#
#             ^^^^^^^^^^^^^^^^^^ definition [..] MyTest#`<describe 'some inner tests'>`#
#        ⌄ enclosing_range_start [..] MyTest#`<describe 'some inner tests'>`#inside_method().
         def inside_method
#            ^^^^^^^^^^^^^ definition [..] MyTest#`<describe 'some inner tests'>`#inside_method().
         end
#          ⌃ enclosing_range_end [..] MyTest#`<describe 'some inner tests'>`#inside_method().
 
#        ⌄ enclosing_range_start [..] MyTest#`<describe 'some inner tests'>`#`<it 'works inside'>`().
         it "works inside" do
#           ^^^^^^^^^^^^^^ definition [..] MyTest#`<describe 'some inner tests'>`#`<it 'works inside'>`().
             outside_method
#            ^^^^^^^^^^^^^^ reference [..] MyTest#outside_method().
             inside_method
#            ^^^^^^^^^^^^^ reference [..] MyTest#`<describe 'some inner tests'>`#inside_method().
         end
#          ⌃ enclosing_range_end [..] MyTest#`<describe 'some inner tests'>`#`<it 'works inside'>`().
     end
#      ⌃ enclosing_range_end [..] MyTest#`<describe 'some inner tests'>`#
 
#    ⌄ enclosing_range_start [..] MyTest#instance_helper().
     def instance_helper; end
#        ^^^^^^^^^^^^^^^ definition [..] MyTest#instance_helper().
#                           ⌃ enclosing_range_end [..] MyTest#instance_helper().
 
#    ⌄ enclosing_range_start [..] MyTest#`<before>`().
     before do
#    ^^^^^^ definition [..] MyTest#`<before>`().
         @foo = T.let(3, Integer)
#        ^^^^ definition [..] MyTest#`@foo`.
#                        ^^^^^^^ definition local 1$2938098190
#                        ^^^^^^^ reference [..] Integer#
         instance_helper
#        ^^^^^^^^^^^^^^^ reference [..] MyTest#instance_helper().
     end
#      ⌃ enclosing_range_end [..] MyTest#`<before>`().
 
#    ⌄ enclosing_range_start [..] MyTest#`<it 'can read foo'>`().
     it 'can read foo' do
#       ^^^^^^^^^^^^^^ definition [..] MyTest#`<it 'can read foo'>`().
         T.assert_type!(@foo, Integer)
#                       ^^^^ reference [..] MyTest#`@foo`.
#                             ^^^^^^^ definition local 1$3909275672
#                             ^^^^^^^ reference [..] Integer#
         instance_helper
#        ^^^^^^^^^^^^^^^ reference [..] MyTest#instance_helper().
     end
#      ⌃ enclosing_range_end [..] MyTest#`<it 'can read foo'>`().
 
#    ⌄ enclosing_range_start [..] `<Class:MyTest>`#random_method().
     def self.random_method
#             ^^^^^^^^^^^^^ definition [..] `<Class:MyTest>`#random_method().
     end
#      ⌃ enclosing_range_end [..] `<Class:MyTest>`#random_method().
 
#    ⌄ enclosing_range_start [..] MyTest#`<describe 'Object'>`#
     describe Object do
#             ^^^^^^ reference [..] MyTest#
#             ^^^^^^ definition [..] MyTest#`<describe 'Object'>`#
#        ⌄ enclosing_range_start [..] MyTest#`<describe 'Object'>`#`<it 'Object'>`().
         it Object do
#           ^^^^^^ definition [..] MyTest#`<describe 'Object'>`#`<it 'Object'>`().
#           ^^^^^^ definition [..] MyTest#`<describe 'Object'>`#`<it 'Object'>`().
#           ^^^^^^ reference [..] Object#
         end
#          ⌃ enclosing_range_end [..] MyTest#`<describe 'Object'>`#`<it 'Object'>`().
#        ⌄ enclosing_range_start [..] MyTest#`<describe 'Object'>`#`<it 'Object'>`().
         it Object do
#           ^^^^^^ reference [..] Object#
         end
#          ⌃ enclosing_range_end [..] MyTest#`<describe 'Object'>`#`<it 'Object'>`().
     end
#      ⌃ enclosing_range_end [..] MyTest#`<describe 'Object'>`#
 
#    ⌄ enclosing_range_start [..] `<Class:MyTest>`#it().
     def self.it(*args)
#             ^^ definition [..] `<Class:MyTest>`#it().
     end
#      ⌃ enclosing_range_end [..] `<Class:MyTest>`#it().
     it "ignores methods without a block"
#    ^^ reference [..] `<Class:MyTest>`#it().
 
     junk.it "ignores non-self calls" do
#    ^^^^ reference [..] Object#junk().
         junk
#        ^^^^ reference [..] Object#junk().
     end
 
#    ⌄ enclosing_range_start [..] MyTest#`<describe 'a non-ideal situation'>`#
     describe "a non-ideal situation" do
#             ^^^^^^^^^^^^^^^^^^^^^^^ reference [..] MyTest#
#             ^^^^^^^^^^^^^^^^^^^^^^^ definition [..] MyTest#`<describe 'a non-ideal situation'>`#
#      ⌄ enclosing_range_start [..] MyTest#`<describe 'a non-ideal situation'>`#`<it 'contains nested describes'>`().
       it "contains nested describes" do
#         ^^^^^^^^^^^^^^^^^^^^^^^^^^^ definition [..] MyTest#`<describe 'a non-ideal situation'>`#`<it 'contains nested describes'>`().
#        ⌄ enclosing_range_start [..] MyTest#`<describe 'a non-ideal situation'>`#`<describe 'nobody should write this but we should still parse it'>`#
         describe "nobody should write this but we should still parse it" do
#                 ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ reference [..] MyTest#`<describe 'a non-ideal situation'>`#
#                 ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ definition [..] MyTest#`<describe 'a non-ideal situation'>`#`<describe 'nobody should write this but we should still parse it'>`#
         end
#          ⌃ enclosing_range_end [..] MyTest#`<describe 'a non-ideal situation'>`#`<describe 'nobody should write this but we should still parse it'>`#
       end
#        ⌃ enclosing_range_end [..] MyTest#`<describe 'a non-ideal situation'>`#`<it 'contains nested describes'>`().
     end
#      ⌃ enclosing_range_end [..] MyTest#`<describe 'a non-ideal situation'>`#
 end
#  ⌃ enclosing_range_end [..] MyTest#
 
#⌄ enclosing_range_start [..] Object#junk().
 def junk
#    ^^^^ definition [..] Object#junk().
 end
#  ⌃ enclosing_range_end [..] Object#junk().
 
 
#⌄ enclosing_range_start [..] Mod#
 module Mod
#       ^^^ definition [..] Mod#
#  ⌄ enclosing_range_start [..] Mod#C#
   class C
#        ^ definition [..] Mod#C#
   end
#    ⌃ enclosing_range_end [..] Mod#C#
 end
#  ⌃ enclosing_range_end [..] Mod#
