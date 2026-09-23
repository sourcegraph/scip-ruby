 # typed: true
 
#⌄ enclosing_range_start [..] `<describe 'example'>`#
 describe "example" do
#         ^^^^^^^^^ definition [..] `<describe 'example'>`#
#  ⌄ enclosing_range_start [..] `<describe 'example'>`#`<before>`().
   before { @value = 1 }
#  ^^^^^^ definition [..] `<describe 'example'>`#`<before>`().
#           ^^^^^^ definition [..] `<describe 'example'>`#`@value`.
#           ^^^^^^^^^^ reference [..] `<describe 'example'>`#`@value`.
#                      ⌃ enclosing_range_end [..] `<describe 'example'>`#`<before>`().
 end
#  ⌃ enclosing_range_end [..] `<describe 'example'>`#
 
 @value
