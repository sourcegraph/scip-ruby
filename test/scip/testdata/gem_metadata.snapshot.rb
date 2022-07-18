 # typed: true
 # gem-metadata: leet@1.3.3.7
 
 class C
#      ^ definition scip-ruby gem leet 1.3.3.7 C#
   def m
#  ^^^^^ definition scip-ruby gem leet 1.3.3.7 C#m().
     n
#    ^ reference scip-ruby gem leet 1.3.3.7 C#n().
   end
   def n
#  ^^^^^ definition scip-ruby gem leet 1.3.3.7 C#n().
     m
#    ^ reference scip-ruby gem leet 1.3.3.7 C#m().
   end
 end
