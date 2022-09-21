 # typed: true
 
 $aa = 0
#^^^ definition [..] `<Class:<root>>`#$aa.
 
 def f
#    ^ definition [..] Object#f().
   $aa = 10
#  ^^^ definition [..] `<Class:<root>>`#$aa.
   $bb = $aa
#  ^^^ definition [..] `<Class:<root>>`#$bb.
#        ^^^ reference [..] `<Class:<root>>`#$aa.
   $aa = $bb
#  ^^^ reference (write) [..] `<Class:<root>>`#$aa.
#        ^^^ reference [..] `<Class:<root>>`#$bb.
   return
 end
 
 class C
#      ^ definition [..] C#
   def g
#      ^ definition [..] C#g().
     $c = $bb
#    ^^ definition [..] `<Class:<root>>`#$c.
#    ^^^^^^^^ reference [..] `<Class:<root>>`#$c.
#         ^^^ reference [..] `<Class:<root>>`#$bb.
   end
 end
 
 puts $c
#^^^^ reference [..] Kernel#puts().
#     ^^ reference [..] `<Class:<root>>`#$c.
