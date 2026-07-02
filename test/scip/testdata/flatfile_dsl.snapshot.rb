 # typed: true
 
#⌄ enclosing_range_start [..] Record#
 class Record
#      ^^^^^^ definition [..] Record#
#  ⌄ enclosing_range_start [..] `<Class:Record>`#flatfile().
   def self.flatfile; end
#           ^^^^^^^^ definition [..] `<Class:Record>`#flatfile().
#                       ⌃ enclosing_range_end [..] `<Class:Record>`#flatfile().
#  ⌄ enclosing_range_start [..] `<Class:Record>`#from().
   def self.from(*_); end
#           ^^^^ definition [..] `<Class:Record>`#from().
#                       ⌃ enclosing_range_end [..] `<Class:Record>`#from().
#  ⌄ enclosing_range_start [..] `<Class:Record>`#pattern().
   def self.pattern(*_); end
#           ^^^^^^^ definition [..] `<Class:Record>`#pattern().
#                          ⌃ enclosing_range_end [..] `<Class:Record>`#pattern().
#  ⌄ enclosing_range_start [..] `<Class:Record>`#field().
   def self.field(*_); end
#           ^^^^^ definition [..] `<Class:Record>`#field().
#                        ⌃ enclosing_range_end [..] `<Class:Record>`#field().
 end
#  ⌃ enclosing_range_end [..] Record#
 
#⌄ enclosing_range_start [..] Flatfile#
 class Flatfile < Record
#      ^^^^^^^^ definition [..] Flatfile#
#                 ^^^^^^ reference [..] Record#
   flatfile do
#  ^^^^^^^^ reference [..] `<Class:Record>`#flatfile().
#    ⌄ enclosing_range_start [..] Flatfile#`foo=`().
#    ⌄ enclosing_range_start [..] Flatfile#foo().
     from   1..2, :foo
#    ^^^^ reference [..] `<Class:Record>`#from().
#                 ^^^^ definition [..] Flatfile#`foo=`().
#                 ^^^^ definition [..] Flatfile#foo().
#                    ⌃ enclosing_range_end [..] Flatfile#`foo=`().
#                    ⌃ enclosing_range_end [..] Flatfile#foo().
#    ⌄ enclosing_range_start [..] Flatfile#`bar=`().
#    ⌄ enclosing_range_start [..] Flatfile#bar().
     pattern(/A-Za-z/, :bar)
#    ^^^^^^^ reference [..] `<Class:Record>`#pattern().
#            ^^^^^^^^ reference [..] Regexp#
#                      ^^^^ definition [..] Flatfile#`bar=`().
#                      ^^^^ definition [..] Flatfile#bar().
#                          ⌃ enclosing_range_end [..] Flatfile#`bar=`().
#                          ⌃ enclosing_range_end [..] Flatfile#bar().
#    ⌄ enclosing_range_start [..] Flatfile#`baz=`().
#    ⌄ enclosing_range_start [..] Flatfile#baz().
     field :baz
#    ^^^^^ reference [..] `<Class:Record>`#field().
#          ^^^^ definition [..] Flatfile#`baz=`().
#          ^^^^ definition [..] Flatfile#baz().
#             ⌃ enclosing_range_end [..] Flatfile#`baz=`().
#             ⌃ enclosing_range_end [..] Flatfile#baz().
   end
 end
#  ⌃ enclosing_range_end [..] Flatfile#
 
 t = Flatfile.new
#^ definition local 1$119448696
#    ^^^^^^^^ reference [..] Flatfile#
#             ^^^ reference [..] Class#new().
 t.foo = t.foo + 1
#^ reference local 1$119448696
#  ^^^^^ reference [..] Flatfile#`foo=`().
#        ^ reference local 1$119448696
#          ^^^ reference [..] Flatfile#foo().
 t.bar = t.bar + 1
#^ reference local 1$119448696
#  ^^^^^ reference [..] Flatfile#`bar=`().
#        ^ reference local 1$119448696
#          ^^^ reference [..] Flatfile#bar().
 t.baz = t.baz + 1
#^ reference local 1$119448696
#  ^^^^^ reference [..] Flatfile#`baz=`().
#        ^ reference local 1$119448696
#          ^^^ reference [..] Flatfile#baz().
