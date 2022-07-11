 # typed: true
 
 _ = 0
#^ definition local 1~#119448696
#^^^^^^^^^ definition scip-ruby gem TODO TODO <static-init>().
 
 class C1
#^^^^^^^^^ definition scip-ruby gem TODO TODO <static-init>().
#      ^^ reference scip-ruby gem TODO TODO C1#
   def f()
#  ^^^^^^^ definition scip-ruby gem TODO TODO f().
     _ = C1.new
#    ^ definition local 2~#3809224601
#        ^^ reference scip-ruby gem TODO TODO C1#
     return
   end
 end
