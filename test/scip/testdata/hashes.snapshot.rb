 # typed: true
 
 def hashes(h, k)
#    ^^^^^^ definition [..] Object#hashes().
#           ^ definition local 1~#1685166589
#              ^ definition local 2~#1685166589
   h["hello"] = "world"
#  ^ reference local 1~#1685166589
   old = h["world"]
#  ^^^ definition local 3~#1685166589
#        ^ reference local 1~#1685166589
   h[k] = h[old]
#  ^ reference local 1~#1685166589
#    ^ reference local 2~#1685166589
#         ^ reference local 1~#1685166589
#           ^^^ reference local 3~#1685166589
 end
