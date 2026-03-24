 # typed: true
 
#⌄ enclosing_range_start [..] Test#
 class Test
#      ^^^^ definition [..] Test#
   extend T::Sig
#  ^^^^^^ reference [..] Kernel#extend().
#  ⌄ enclosing_range_start [..] `<Class:Test>`#test_each().
   def self.test_each(arg, &blk); end
#           ^^^^^^^^^ definition [..] `<Class:Test>`#test_each().
#                                   ⌃ enclosing_range_end [..] `<Class:Test>`#test_each().
#  ⌄ enclosing_range_start [..] `<Class:Test>`#it().
   def self.it(name, &blk); end
#           ^^ definition [..] `<Class:Test>`#it().
#                             ⌃ enclosing_range_end [..] `<Class:Test>`#it().
#  ⌄ enclosing_range_start [..] `<Class:Test>`#describe().
   def self.describe(name, &blk); end
#           ^^^^^^^^ definition [..] `<Class:Test>`#describe().
#                                   ⌃ enclosing_range_end [..] `<Class:Test>`#describe().
 end
#  ⌃ enclosing_range_end [..] Test#
 
#⌄ enclosing_range_start [..] Foo#
 class Foo < Test
#      ^^^ definition [..] Foo#
#            ^^^^ reference [..] Test#
   # The unclosed `do` block here should be a recoverable parse error.
   test_each([[1, 2], [3,4]]) do |(a,b)|
#  ^^^^^^^^^ reference [..] `<Class:Test>`#test_each().
                            # ^^ error: Hint: this "do" token
 
#  ⌄ enclosing_range_start [..] Foo#`<it 'it block 1'>`().
   it "it block 1" do
#     ^^^^^^^^^^^^ definition [..] Foo#`<it 'it block 1'>`().
   end
#    ⌃ enclosing_range_end [..] Foo#`<it 'it block 1'>`().
 
#  ⌄ enclosing_range_start [..] Foo#`<it 'it block 2'>`().
   it "it block 2" do
#     ^^^^^^^^^^^^ definition [..] Foo#`<it 'it block 2'>`().
   end
#    ⌃ enclosing_range_end [..] Foo#`<it 'it block 2'>`().
 end # error: unexpected token "end of file"
#  ⌃ enclosing_range_end [..] Foo#
