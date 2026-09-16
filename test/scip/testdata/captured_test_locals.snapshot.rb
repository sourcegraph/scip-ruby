 # typed: false
 
#⌄ enclosing_range_start [..] `<describe 'outer'>`#
 describe 'outer' do
#         ^^^^^^^ definition [..] `<describe 'outer'>`#
   context 'nested' do
     value = 'hello'
#    ^^^^^ definition local 1$3964620731
     it 'reads a captured local' do
       value.upcase
#      ^^^^^ reference local 1$3964620731
#            ^^^^^^ reference [..] String#upcase().
     end
     specify 'writes the same captured local' do
       value = value.downcase
#      ^^^^^ reference (write) local 1$3964620731
#      ^^^^^^^^^^^^^^^^^^^^^^ reference local 1$3964620731
#              ^^^^^ reference local 1$3964620731
#                    ^^^^^^^^ reference [..] String#downcase().
     end
   end
 
   context 'block argument shadowing' do
     value = 'outer'
#    ^^^^^ definition local 2$3964620731
     ['inner'].each do |value|
#              ^^^^ reference [..] Array#each().
#                       ^^^^^ definition local 3$3964620731
       it 'captures the block argument' do
         value.upcase
#        ^^^^^ reference local 3$3964620731
#              ^^^^^^ reference [..] String#upcase().
       end
     end
     it 'still captures the outer variable' do
       value.downcase
#      ^^^^^ reference local 2$3964620731
#            ^^^^^^^^ reference [..] String#downcase().
     end
   end
 
#  ⌄ enclosing_range_start [..] `<describe 'outer'>`#`<context 'independent variables'>`#
   context 'independent variables' do
#          ^^^^^^^^^^^^^^^^^^^^^^^ reference [..] `<describe 'outer'>`#
#          ^^^^^^^^^^^^^^^^^^^^^^^ definition [..] `<describe 'outer'>`#`<context 'independent variables'>`#
#    ⌄ enclosing_range_start [..] `<describe 'outer'>`#`<context 'independent variables'>`#`<it 'has its own local'>`().
     it 'has its own local' do
#       ^^^^^^^^^^^^^^^^^^^ definition [..] `<describe 'outer'>`#`<context 'independent variables'>`#`<it 'has its own local'>`().
       value = 'first'
#      ^^^^^ definition local 1$3498282874
       value.upcase
#      ^^^^^ reference local 1$3498282874
#            ^^^^^^ reference [..] String#upcase().
     end
#      ⌃ enclosing_range_end [..] `<describe 'outer'>`#`<context 'independent variables'>`#`<it 'has its own local'>`().
#    ⌄ enclosing_range_start [..] `<describe 'outer'>`#`<context 'independent variables'>`#`<it 'has a different local'>`().
     it 'has a different local' do
#       ^^^^^^^^^^^^^^^^^^^^^^^ definition [..] `<describe 'outer'>`#`<context 'independent variables'>`#`<it 'has a different local'>`().
       value = 'second'
#      ^^^^^ definition local 1$3042791386
       value.downcase
#      ^^^^^ reference local 1$3042791386
#            ^^^^^^^^ reference [..] String#downcase().
     end
#      ⌃ enclosing_range_end [..] `<describe 'outer'>`#`<context 'independent variables'>`#`<it 'has a different local'>`().
   end
#    ⌃ enclosing_range_end [..] `<describe 'outer'>`#`<context 'independent variables'>`#
 
#  ⌄ enclosing_range_start [..] `<describe 'outer'>`#`<context 'rescue bindings remain local to the example'>`#
   context 'rescue bindings remain local to the example' do
#          ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ reference [..] `<describe 'outer'>`#
#          ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ definition [..] `<describe 'outer'>`#`<context 'rescue bindings remain local to the example'>`#
#    ⌄ enclosing_range_start [..] `<describe 'outer'>`#`<context 'rescue bindings remain local to the example'>`#`<it 'introduces a rescue variable'>`().
     it 'introduces a rescue variable' do
#       ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ definition [..] `<describe 'outer'>`#`<context 'rescue bindings remain local to the example'>`#`<it 'introduces a rescue variable'>`().
       begin
         raise 'example'
#        ^^^^^ reference [..] Kernel#raise().
       rescue RuntimeError => error
#             ^^^^^^^^^^^^ reference [..] RuntimeError#
#                             ^^^^^ definition local 2$2891928498
         error.message
#        ^^^^^ reference local 2$2891928498
#              ^^^^^^^ reference [..] Exception#message().
       end
     end
#      ⌃ enclosing_range_end [..] `<describe 'outer'>`#`<context 'rescue bindings remain local to the example'>`#`<it 'introduces a rescue variable'>`().
   end
#    ⌃ enclosing_range_end [..] `<describe 'outer'>`#`<context 'rescue bindings remain local to the example'>`#
 end
#  ⌃ enclosing_range_end [..] `<describe 'outer'>`#
 
 outside = 'file scope'
#^^^^^^^ definition local 1$217974539
 describe 'captures file scope' do
   it 'retains the outer definition' do
     outside.upcase
#    ^^^^^^^ reference local 1$217974539
#            ^^^^^^ reference [..] String#upcase().
   end
 end
