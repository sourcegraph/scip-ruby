 # typed: true
 
 class K
#      ^ definition scip-ruby gem TODO TODO K#
   def m1
#  ^^^^^^ definition scip-ruby gem TODO TODO K#m1().
     @f = 0
#    ^^ definition scip-ruby gem TODO TODO K#@f.
     @g = @f
#    ^^ definition scip-ruby gem TODO TODO K#@g.
#         ^^ reference scip-ruby gem TODO TODO K#@f.
     return
   end
   def m2
#  ^^^^^^ definition scip-ruby gem TODO TODO K#m2().
     @f = @g
#    ^^ definition scip-ruby gem TODO TODO K#@f.
#         ^^ reference scip-ruby gem TODO TODO K#@g.
     return
   end
 end
