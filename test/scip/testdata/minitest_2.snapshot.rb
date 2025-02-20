 # typed: true
 
 class Test
#      ^^^^ definition [..] Test#
   extend T::Sig
#  ^^^^^^ reference [..] Kernel#extend().
   def self.test_each(arg, &blk); end
#           ^^^^^^^^^ definition [..] `<Class:Test>`#test_each().
   def self.it(name, &blk); end
#           ^^ definition [..] `<Class:Test>`#it().
   def self.describe(name, &blk); end
#           ^^^^^^^^ definition [..] `<Class:Test>`#describe().
 end
 
 class Foo < Test
#      ^^^ definition [..] Foo#
#            ^^^^ reference [..] Test#
   # The unclosed `do` block here should be a recoverable parse error.
   test_each([[1, 2], [3,4]]) do |(a,b)|
#  ^^^^^^^^^ reference [..] `<Class:Test>`#test_each().
                            # ^^ error: Hint: this "do" token
 
   it "it block 1" do
#     ^^^^^^^^^^^^ definition [..] Foo#`<it 'it block 1'>`().
   end
 
   it "it block 2" do
#     ^^^^^^^^^^^^ definition [..] Foo#`<it 'it block 2'>`().
   end
 end # error: unexpected token "end of file"
