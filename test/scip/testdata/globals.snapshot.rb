 # typed: true
 
 $aa = 0
#^^^ definition [global] `<Class:<root>>`#$aa.
 
#⌄ enclosing_range_start [..] Object#f().
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
#  ⌃ enclosing_range_end [..] Object#f().
 
#⌄ enclosing_range_start [..] C#
 class C
#      ^ definition [..] C#
#  ⌄ enclosing_range_start [..] C#g().
   def g
#      ^ definition [..] C#g().
     $c = $bb
#    ^^ definition [global] `<Class:<root>>`#$c.
#    ^^^^^^^^ reference [global] `<Class:<root>>`#$c.
#         ^^^ reference [global] `<Class:<root>>`#$bb.
   end
#    ⌃ enclosing_range_end [..] C#g().
 end
#  ⌃ enclosing_range_end [..] C#
 
 puts $c
#^^^^ reference [..] Kernel#puts().
#     ^^ reference [global] `<Class:<root>>`#$c.
 
 $d = T.let(0, Integer)
#^^ definition [global] `<Class:<root>>`#$d.
#              ^^^^^^^ definition local 3$119448696
#              ^^^^^^^ reference [..] Integer#
 
#⌄ enclosing_range_start [..] Object#g().
 def g
#    ^ definition [..] Object#g().
   $d
#  ^^ reference [global] `<Class:<root>>`#$d.
 end
#  ⌃ enclosing_range_end [..] Object#g().
