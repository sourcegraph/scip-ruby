 # typed: true
 # gem-metadata: leet@1.3.3.7
 
 class C
#      ^ definition leet 1.3.3.7 C#
   def m
#  ^^^^^ definition leet 1.3.3.7 C#m().
     n
#    ^ reference leet 1.3.3.7 C#n().
   end
   def n
#  ^^^^^ definition leet 1.3.3.7 C#n().
     m
#    ^ reference leet 1.3.3.7 C#m().
   end
 end
