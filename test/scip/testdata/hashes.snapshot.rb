 # typed: true
 
#⌄ enclosing_range_start [..] Object#hashes().
 def hashes(h, k)
#    ^^^^^^ definition [..] Object#hashes().
#           ^ definition local 1$1230347771
#              ^ definition local 2$1230347771
   h["hello"] = "world"
#  ^ reference local 1$1230347771
   old = h["world"]
#  ^^^ definition local 3$1230347771
#        ^ reference local 1$1230347771
   h[k] = h[old]
#  ^ reference local 1$1230347771
#    ^ reference local 2$1230347771
#         ^ reference local 1$1230347771
#           ^^^ reference local 3$1230347771
 end
#  ⌃ enclosing_range_end [..] Object#hashes().
