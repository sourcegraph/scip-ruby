 # typed: true
 
#⌄ enclosing_range_start [..] MyError#
 class MyError < StandardError
#      ^^^^^^^ definition [..] MyError#
#                ^^^^^^^^^^^^^ reference [..] StandardError#
 end
#  ⌃ enclosing_range_end [..] MyError#
 
#⌄ enclosing_range_start [..] Object#handle().
 def handle(e)
#    ^^^^^^ definition [..] Object#handle().
#           ^ definition local 1$2155487517
   puts e.inspect.to_s 
#  ^^^^ reference [..] Kernel#puts().
#       ^ reference local 1$2155487517
#         ^^^^^^^ reference [..] Kernel#inspect().
#                 ^^^^ reference [..] Kernel#to_s().
 end
#  ⌃ enclosing_range_end [..] Object#handle().
 
#⌄ enclosing_range_start [..] Object#f().
 def f
#    ^ definition [..] Object#f().
   begin
     raise 'This exception will be rescued!'
#    ^^^^^ reference [..] Kernel#raise().
   rescue MyError => e1
#         ^^^^^^^ reference [..] MyError#
#                    ^^ definition local 2$2046155767
     handle(e1)
#    ^^^^^^ reference [..] Object#handle().
#           ^^ reference local 2$2046155767
   rescue StandardError => e2
#         ^^^^^^^^^^^^^ reference [..] StandardError#
#                          ^^ definition local 4$2046155767
     handle(e2)
#    ^^^^^^ reference [..] Object#handle().
#           ^^ reference local 4$2046155767
   end
 end
#  ⌃ enclosing_range_end [..] Object#f().
