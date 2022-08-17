 # typed: true
 
 def f
#^^^^^ definition [..] Object#f().
   begin
     raise 'This exception will be rescued!'
   rescue StandardError => e
#  ^^^^ definition local 2~#3809224601
#         ^^^^^^^^^^^^^ reference local 1~#3809224601
#         ^^^^^^^^^^^^^ reference [..] StandardError#
#                          ^ definition local 1~#3809224601
     puts "Rescued: #{e.inspect}"
#                     ^ reference local 1~#3809224601
   rescue AnotherError => e
#  ^^^^^^ definition local 3~#3809224601
#         ^^^^^^^^^^^^ reference local 1~#3809224601
#         ^^^^^^^^^^^^ reference [..] T.untyped#
#                         ^ reference (write) local 1~#3809224601
     puts "Rescued, but with a different block: #{e.inspect}"
#                                                 ^ reference local 1~#3809224601
   end
   f
#  ^ reference [..] Object#f().
 end
