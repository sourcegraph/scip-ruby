 # typed: true
 
 $aa = 0
#^^^ definition [global] `<Class:<root>>`#$aa.
 
 def f
#    ^ definition [..] Object#f().
   $aa = 10
#  ^^^ definition [global] `<Class:<root>>`#$aa.
   $bb = $aa
#  ^^^ definition [global] `<Class:<root>>`#$bb.
#        ^^^ reference [global] `<Class:<root>>`#$aa.
   $aa = $bb
#  ^^^ reference (write) [global] `<Class:<root>>`#$aa.
#        ^^^ reference [global] `<Class:<root>>`#$bb.
   return
 end
 
 class C
#      ^ definition [..] C#
   def g
#      ^ definition [..] C#g().
     $c = $bb
#    ^^ definition [global] `<Class:<root>>`#$c.
#    ^^^^^^^^ reference [global] `<Class:<root>>`#$c.
#         ^^^ reference [global] `<Class:<root>>`#$bb.
   end
 end
 
 puts $c
#^^^^ reference [..] Kernel#puts().
#     ^^ reference [global] `<Class:<root>>`#$c.
 
 $d = T.let(0, Integer)
#^^ definition [global] `<Class:<root>>`#$d.
#              ^^^^^^^ definition local 3~#119448696
#              ^^^^^^^ reference [..] Integer#
 
 def g
#    ^ definition [..] Object#g().
   $d
#  ^^ reference [global] `<Class:<root>>`#$d.
 end
