 # typed: true
 
#⌄ enclosing_range_start [..] Object#globalFn1().
 def globalFn1()
#    ^^^^^^^^^ definition [..] Object#globalFn1().
   x = 10
#  ^ definition local 1$3846536873
   x
#  ^ reference local 1$3846536873
 end
#  ⌃ enclosing_range_end [..] Object#globalFn1().
 
#⌄ enclosing_range_start [..] Object#globalFn2().
 def globalFn2()
#    ^^^^^^^^^ definition [..] Object#globalFn2().
   x = globalFn1()
#  ^ definition local 1$3796204016
#  ^^^^^^^^^^^^^^^ reference local 1$3796204016
#      ^^^^^^^^^ reference [..] Object#globalFn1().
 end
#  ⌃ enclosing_range_end [..] Object#globalFn2().
 
 # https://stackoverflow.com/questions/64322636/whats-the-3-dots-method-argument-in-ruby
#⌄ enclosing_range_start [..] Object#loopyDoopy().
 def loopyDoopy(...)
#    ^^^^^^^^^^ definition [..] Object#loopyDoopy().
#               ^^^ definition local 1$1182647655
#               ^^^ definition local 2$1182647655
#               ^^^ definition local 3$1182647655
   loopyDoopy(...)
#  ^^^^^^^^^^^^^^^ reference local 1$1182647655
   return
 end
#  ⌃ enclosing_range_end [..] Object#loopyDoopy().
