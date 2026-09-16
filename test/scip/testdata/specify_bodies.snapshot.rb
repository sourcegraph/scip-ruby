 # typed: true
 
#⌄ enclosing_range_start [..] SpecifyBodies#
 class SpecifyBodies
#      ^^^^^^^^^^^^^ definition [..] SpecifyBodies#
#  ⌄ enclosing_range_start [..] `<Class:SpecifyBodies>`#specify().
   def self.specify(title, &block); end
#           ^^^^^^^ definition [..] `<Class:SpecifyBodies>`#specify().
#                                     ⌃ enclosing_range_end [..] `<Class:SpecifyBodies>`#specify().
#  ⌄ enclosing_range_start [..] `<Class:SpecifyBodies>`#it().
   def self.it(title, &block); end
#           ^^ definition [..] `<Class:SpecifyBodies>`#it().
#                                ⌃ enclosing_range_end [..] `<Class:SpecifyBodies>`#it().
#  ⌄ enclosing_range_start [..] `<Class:SpecifyBodies>`#example().
   def self.example(title, &block); end
#           ^^^^^^^ definition [..] `<Class:SpecifyBodies>`#example().
#                                     ⌃ enclosing_range_end [..] `<Class:SpecifyBodies>`#example().
#  ⌄ enclosing_range_start [..] `<Class:SpecifyBodies>`#xspecify().
   def self.xspecify(title, &block); end
#           ^^^^^^^^ definition [..] `<Class:SpecifyBodies>`#xspecify().
#                                      ⌃ enclosing_range_end [..] `<Class:SpecifyBodies>`#xspecify().
#  ⌄ enclosing_range_start [..] `<Class:SpecifyBodies>`#test_each().
   def self.test_each(values, &block); end
#           ^^^^^^^^^ definition [..] `<Class:SpecifyBodies>`#test_each().
#                                        ⌃ enclosing_range_end [..] `<Class:SpecifyBodies>`#test_each().
 
#  ⌄ enclosing_range_start [..] SpecifyBodies#`<specify 'restores local definitions and reads'>`().
   specify 'restores local definitions and reads' do
#          ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ definition [..] SpecifyBodies#`<specify 'restores local definitions and reads'>`().
     text = 'hello'
#    ^^^^ definition local 1$1073401100
     text.upcase
#    ^^^^ reference local 1$1073401100
#         ^^^^^^ reference [..] String#upcase().
   end
#    ⌃ enclosing_range_end [..] SpecifyBodies#`<specify 'restores local definitions and reads'>`().
 
#  ⌄ enclosing_range_start [..] SpecifyBodies#`<it 'preserves the existing control'>`().
   it 'preserves the existing control' do
#     ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ definition [..] SpecifyBodies#`<it 'preserves the existing control'>`().
     text = 'control'
#    ^^^^ definition local 1$364819824
     text.upcase
#    ^^^^ reference local 1$364819824
#         ^^^^^^ reference [..] String#upcase().
   end
#    ⌃ enclosing_range_end [..] SpecifyBodies#`<it 'preserves the existing control'>`().
 
   example 'indexes example aliases' do
#  ^^^^^^^ reference [..] `<Class:SpecifyBodies>`#example().
     text = 'example'
#    ^^^^ definition local 1$119448696
     text.upcase
#    ^^^^ reference local 1$119448696
#         ^^^^^^ reference [..] String#upcase().
   end
 
#  ⌄ enclosing_range_start [..] SpecifyBodies#`<xspecify 'indexes skipped example bodies'>`().
   xspecify 'indexes skipped example bodies' do
#           ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ definition [..] SpecifyBodies#`<xspecify 'indexes skipped example bodies'>`().
     text = 'skipped'
#    ^^^^ definition local 1$1601078526
     text.upcase
#    ^^^^ reference local 1$1601078526
#         ^^^^^^ reference [..] String#upcase().
   end
#    ⌃ enclosing_range_end [..] SpecifyBodies#`<xspecify 'indexes skipped example bodies'>`().
 
   test_each(['parameterized']) do |value|
#  ^^^^^^^^^ reference [..] `<Class:SpecifyBodies>`#test_each().
#                                   ^^^^^ definition local 1$1354289346
#                                   ^^^^^ definition local 2$119448696
#    ⌄ enclosing_range_start [..] SpecifyBodies#`<specify 'indexes parameterized examples'>`().
     specify 'indexes parameterized examples' do
#            ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ definition [..] SpecifyBodies#`<specify 'indexes parameterized examples'>`().
       text = value
#      ^^^^ definition local 2$1354289346
#             ^^^^^ reference local 1$1354289346
       text.upcase
#      ^^^^ reference local 2$1354289346
#           ^^^^^^ reference [..] String#upcase().
     end
#      ⌃ enclosing_range_end [..] SpecifyBodies#`<specify 'indexes parameterized examples'>`().
   end
 end
#  ⌃ enclosing_range_end [..] SpecifyBodies#
