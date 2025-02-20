 # typed: true
 extend T::Sig
#^^^^^^ reference [..] Kernel#extend().
#       ^ reference [..] T#
#          ^^^ reference [..] T#Sig#
 
 class Test
#      ^^^^ definition [..] Test#
   extend T::Sig
#  ^^^^^^ reference [..] Kernel#extend().
 
   def self.test_each(iter, &blk); end
#           ^^^^^^^^^ definition [..] `<Class:Test>`#test_each().
   def self.it(name, &blk); end
#           ^^ definition [..] `<Class:Test>`#it().
   def self.describe(name, &blk); end
#           ^^^^^^^^ definition [..] `<Class:Test>`#describe().
 
   test_each([[1,2], [3,4]]) do |(a,b)|
#  ^^^^^^^^^ reference [..] `<Class:Test>`#test_each().
#                                 ^ definition local 1~#2288740619
#                                 ^ definition local 1~#416088458
#                                   ^ definition local 2~#2288740619
#                                   ^ definition local 2~#416088458
 
     describe "d" do
       it "b" do
#         ^^^ definition [..] Test#`<it 'b'>`().
         T.reveal_type(a) # error: Revealed type: `Integer`
#        ^ reference [..] T#
#          ^^^^^^^^^^^ reference [..] `<Class:T>`#reveal_type().
#                      ^ reference local 1~#416088458
       end
     end
 
     it "a" do
#       ^^^ definition [..] Test#`<it 'a'>`().
       T.reveal_type(a) # error: Revealed type: `Integer`
#      ^ reference [..] T#
#        ^^^^^^^^^^^ reference [..] `<Class:T>`#reveal_type().
#                    ^ reference local 1~#2288740619
     end
 
   end
 end
