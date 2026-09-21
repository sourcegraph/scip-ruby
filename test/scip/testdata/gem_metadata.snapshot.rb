 # typed: true
 # gem-metadata: leet@1.3.3.7
 
#⌄ enclosing_range_start leet 1.3.3.7 C#
 class C
#      ^ definition leet 1.3.3.7 C#
#  ⌄ enclosing_range_start leet 1.3.3.7 C#m().
   def m
#      ^ definition leet 1.3.3.7 C#m().
     n
#    ^ reference leet 1.3.3.7 C#n().
   end
#    ⌃ enclosing_range_end leet 1.3.3.7 C#m().
#  ⌄ enclosing_range_start leet 1.3.3.7 C#n().
   def n
#      ^ definition leet 1.3.3.7 C#n().
     m
#    ^ reference leet 1.3.3.7 C#m().
   end
#    ⌃ enclosing_range_end leet 1.3.3.7 C#n().
 end
#  ⌃ enclosing_range_end leet 1.3.3.7 C#
