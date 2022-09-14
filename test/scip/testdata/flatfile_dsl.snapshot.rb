 # typed: true
 
 class Record
#      ^^^^^^ definition [..] Record#
   def self.flatfile; end
#           ^^^^^^^^ definition [..] `<Class:Record>`#flatfile().
   def self.from(*_); end
#           ^^^^ definition [..] `<Class:Record>`#from().
   def self.pattern(*_); end
#           ^^^^^^^ definition [..] `<Class:Record>`#pattern().
   def self.field(*_); end
#           ^^^^^ definition [..] `<Class:Record>`#field().
 end
 
 class Flatfile < Record
#      ^^^^^^^^ definition [..] Flatfile#
#                 ^^^^^^ definition [..] Record#
   flatfile do
#  ^^^^^^^^ reference [..] `<Class:Record>`#flatfile().
     from   1..2, :foo
#    ^^^^ reference [..] `<Class:Record>`#from().
#                 ^^^^ definition [..] Flatfile#`foo=`().
#                 ^^^^ definition [..] Flatfile#foo().
     pattern(/A-Za-z/, :bar)
#    ^^^^^^^ reference [..] `<Class:Record>`#pattern().
#            ^^^^^^^^ reference [..] Regexp#
#                      ^^^^ definition [..] Flatfile#`bar=`().
#                      ^^^^ definition [..] Flatfile#bar().
     field :baz
#    ^^^^^ reference [..] `<Class:Record>`#field().
#          ^^^^ definition [..] Flatfile#baz().
#          ^^^^ definition [..] Flatfile#`baz=`().
   end
 end
 
 t = Flatfile.new
#^ definition local 1~#119448696
#    ^^^^^^^^ reference [..] Flatfile#
#             ^^^ reference [..] Class#new().
 t.foo = t.foo + 1
#^ reference local 1~#119448696
#  ^^^^^ reference [..] Flatfile#`foo=`().
#        ^ reference local 1~#119448696
#          ^^^ reference [..] Flatfile#foo().
 t.bar = t.bar + 1
#^ reference local 1~#119448696
#  ^^^^^ reference [..] Flatfile#`bar=`().
#        ^ reference local 1~#119448696
#          ^^^ reference [..] Flatfile#bar().
 t.baz = t.baz + 1
#^ reference local 1~#119448696
#  ^^^^^ reference [..] Flatfile#`baz=`().
#        ^ reference local 1~#119448696
#          ^^^ reference [..] Flatfile#baz().
