 # typed: true
 
 class MyError < StandardError
#      ^^^^^^^ definition [..] MyError#
#                ^^^^^^^^^^^^^ definition [..] StandardError#
 end
 
 def handle(e)
#^^^^^^^^^^^^^ definition [..] Object#handle().
#           ^ definition local 1~#780127187
   puts e.inspect.to_s 
#       ^ reference local 1~#780127187
 end
 
 def f
#^^^^^ definition [..] Object#f().
   begin
     raise 'This exception will be rescued!'
   rescue MyError => e1
#         ^^^^^^^ reference local 1~#3809224601
#         ^^^^^^^ reference [..] MyError#
#                    ^^ definition local 1~#3809224601
     handle(e1)
#    ^^^^^^ reference [..] Object#handle().
#           ^^ reference local 1~#3809224601
   rescue StandardError => e2
#         ^^^^^^^^^^^^^ reference local 2~#3809224601
#         ^^^^^^^^^^^^^ reference [..] StandardError#
#                          ^^ definition local 2~#3809224601
     handle(e2)
#    ^^^^^^ reference [..] Object#handle().
#           ^^ reference local 2~#3809224601
   end
 end
