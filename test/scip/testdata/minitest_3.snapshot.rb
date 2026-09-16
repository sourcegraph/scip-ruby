 # typed: true
 extend T::Sig
#^^^^^^ reference [..] Kernel#extend().
#       ^ reference [..] T#
#          ^^^ reference [..] T#Sig#
 
#⌄ enclosing_range_start [..] Test#
 class Test
#      ^^^^ definition [..] Test#
   extend T::Sig
#  ^^^^^^ reference [..] Kernel#extend().
 
#  ⌄ enclosing_range_start [..] `<Class:Test>`#test_each().
   def self.test_each(iter, &blk); end
#           ^^^^^^^^^ definition [..] `<Class:Test>`#test_each().
#                                    ⌃ enclosing_range_end [..] `<Class:Test>`#test_each().
#  ⌄ enclosing_range_start [..] `<Class:Test>`#it().
   def self.it(name, &blk); end
#           ^^ definition [..] `<Class:Test>`#it().
#                             ⌃ enclosing_range_end [..] `<Class:Test>`#it().
#  ⌄ enclosing_range_start [..] `<Class:Test>`#describe().
   def self.describe(name, &blk); end
#           ^^^^^^^^ definition [..] `<Class:Test>`#describe().
#                                   ⌃ enclosing_range_end [..] `<Class:Test>`#describe().
 
   test_each([[1,2], [3,4]]) do |(a,b)|
#  ^^^^^^^^^ reference [..] `<Class:Test>`#test_each().
#                                 ^ definition local 1$4260082600
#                                 ^ definition local 1$960236125
#                                   ^ definition local 2$4260082600
#                                   ^ definition local 2$960236125
 
     describe "d" do
#      ⌄ enclosing_range_start [..] Test#`<before>`().
       before do
#      ^^^^^^ definition [..] Test#`<before>`().
       end
#        ⌃ enclosing_range_end [..] Test#`<before>`().
#      ⌄ enclosing_range_start [..] Test#`<after>`().
       after do
#      ^^^^^ definition [..] Test#`<after>`().
       end
#        ⌃ enclosing_range_end [..] Test#`<after>`().
#      ⌄ enclosing_range_start [..] Test#`<it 'b'>`().
       it "b" do
#         ^^^ definition [..] Test#`<it 'b'>`().
         T.reveal_type(a) # error: Revealed type: `Integer`
#        ^ reference [..] T#
#          ^^^^^^^^^^^ reference [..] `<Class:T>`#reveal_type().
#                      ^ reference local 1$960236125
       end
#        ⌃ enclosing_range_end [..] Test#`<it 'b'>`().
     end
 
#    ⌄ enclosing_range_start [..] Test#`<it 'a'>`().
     it "a" do
#       ^^^ definition [..] Test#`<it 'a'>`().
       T.reveal_type(a) # error: Revealed type: `Integer`
#      ^ reference [..] T#
#        ^^^^^^^^^^^ reference [..] `<Class:T>`#reveal_type().
#                    ^ reference local 1$4260082600
     end
#      ⌃ enclosing_range_end [..] Test#`<it 'a'>`().
 
   end
 end
#  ⌃ enclosing_range_end [..] Test#
