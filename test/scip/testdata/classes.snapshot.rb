 # typed: true
 
 _ = 0
#^ definition local 1~#119448696
#^^^^^^^^^^^^^^^^^^ definition scip-ruby gem TODO TODO <static-init>().
 
 class C1
#^^^^^^^^^^ definition scip-ruby gem TODO TODO <static-init>().
#      ^^ definition scip-ruby gem TODO TODO C1#
   def f()
#  ^^^^^^^ definition scip-ruby gem TODO TODO f().
     _a = C1.new
#    ^^ definition local 2~#3809224601
#         ^^ reference scip-ruby gem TODO TODO C1#
     _b = M2::C2.new
#    ^^ definition local 5~#3809224601
#         ^^ reference scip-ruby gem TODO TODO M2#
#             ^^ reference scip-ruby gem TODO TODO C2#
     return
   end
 end
 
 module M2
#^^^^^^^^^^^^^^^ definition scip-ruby gem TODO TODO <static-init>().
#       ^^ definition scip-ruby gem TODO TODO M2#
   class C2
#  ^^^^^^^^^^^^ definition scip-ruby gem TODO TODO <static-init>().
#        ^^ definition scip-ruby gem TODO TODO C2#
   end
 end
 
 class M3::C3
#^^^^^^^^^^^^^^^^^^ definition scip-ruby gem TODO TODO <static-init>().
#      ^^ definition scip-ruby gem TODO TODO M3#
#          ^^ definition scip-ruby gem TODO TODO C3#
 end
