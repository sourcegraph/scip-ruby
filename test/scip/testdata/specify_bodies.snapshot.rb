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
#  ^^^^^^^ reference [..] `<Class:SpecifyBodies>`#specify().
#          ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ definition [..] SpecifyBodies#`<specify 'restores local definitions and reads'>`().
     text = 'hello'
#    ^^^^ definition local 1$2594902456
     text.upcase
#    ^^^^ reference local 1$2594902456
#         ^^^^^^ reference [..] String#upcase().
   end
#    ⌃ enclosing_range_end [..] SpecifyBodies#`<specify 'restores local definitions and reads'>`().
 
#  ⌄ enclosing_range_start [..] SpecifyBodies#`<it 'preserves the existing control'>`().
   it 'preserves the existing control' do
#  ^^ reference [..] `<Class:SpecifyBodies>`#it().
#     ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ definition [..] SpecifyBodies#`<it 'preserves the existing control'>`().
     text = 'control'
#    ^^^^ definition local 1$30081924
     text.upcase
#    ^^^^ reference local 1$30081924
#         ^^^^^^ reference [..] String#upcase().
   end
#    ⌃ enclosing_range_end [..] SpecifyBodies#`<it 'preserves the existing control'>`().
 
   example 'indexes example aliases' do
#  ^^^^^^^ reference [..] `<Class:SpecifyBodies>`#example().
     text = 'example'
#    ^^^^ definition local 1$202568282
     text.upcase
#    ^^^^ reference local 1$202568282
#         ^^^^^^ reference [..] String#upcase().
   end
 
#  ⌄ enclosing_range_start [..] SpecifyBodies#`<xspecify 'indexes skipped example bodies'>`().
   xspecify 'indexes skipped example bodies' do
#  ^^^^^^^^ reference [..] `<Class:SpecifyBodies>`#xspecify().
#           ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ definition [..] SpecifyBodies#`<xspecify 'indexes skipped example bodies'>`().
     text = 'skipped'
#    ^^^^ definition local 1$3232339690
     text.upcase
#    ^^^^ reference local 1$3232339690
#         ^^^^^^ reference [..] String#upcase().
   end
#    ⌃ enclosing_range_end [..] SpecifyBodies#`<xspecify 'indexes skipped example bodies'>`().
 
   test_each(['parameterized']) do |value|
#  ^^^^^^^^^ reference [..] `<Class:SpecifyBodies>`#test_each().
#                                   ^^^^^ definition local 1$3442174910
#                                   ^^^^^ definition local 2$202568282
#    ⌄ enclosing_range_start [..] SpecifyBodies#`<specify 'indexes parameterized examples'>`().
     specify 'indexes parameterized examples' do
#            ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ definition [..] SpecifyBodies#`<specify 'indexes parameterized examples'>`().
       text = value
#      ^^^^ definition local 2$3442174910
#             ^^^^^ reference local 1$3442174910
       text.upcase
#      ^^^^ reference local 2$3442174910
#           ^^^^^^ reference [..] String#upcase().
     end
#      ⌃ enclosing_range_end [..] SpecifyBodies#`<specify 'indexes parameterized examples'>`().
   end
 end
#  ⌃ enclosing_range_end [..] SpecifyBodies#
