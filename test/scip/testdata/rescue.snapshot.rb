 # typed: true
 
 class MyError < StandardError
#      ^^^^^^^ definition [..] MyError#
#                ^^^^^^^^^^^^^ definition [..] StandardError#
 end
 
 def handle(e)
#    ^^^^^^ definition [..] Object#handle().
#           ^ definition local 1~#780127187
   puts e.inspect.to_s 
#  ^^^^ reference [..] Kernel#puts().
#       ^ reference local 1~#780127187
#         ^^^^^^^ reference [..] Kernel#inspect().
#                 ^^^^ reference [..] Kernel#to_s().
 end
 
 def f
#    ^ definition [..] Object#f().
   begin
     raise 'This exception will be rescued!'
#    ^^^^^ reference [..] Kernel#raise().
   rescue MyError => e1
#         ^^^^^^^ reference [..] MyError#
#                    ^^ definition local 1~#3809224601
     handle(e1)
#    ^^^^^^ reference [..] Object#handle().
#           ^^ reference local 1~#3809224601
   rescue StandardError => e2
#         ^^^^^^^^^^^^^ reference [..] StandardError#
#                          ^^ definition local 3~#3809224601
     handle(e2)
#    ^^^^^^ reference [..] Object#handle().
#           ^^ reference local 3~#3809224601
   end
 end
