 # typed: true
 # Adapted from test/testdata/lsp/rename/locals.rb.
 
#⌄ enclosing_range_start [..] DifferentScopeLevels#
 class DifferentScopeLevels
#      ^^^^^^^^^^^^^^^^^^^^ definition [..] DifferentScopeLevels#
#  ⌄ enclosing_range_start [..] DifferentScopeLevels#shadowing().
   def shadowing
#      ^^^^^^^^^ definition [..] DifferentScopeLevels#shadowing().
     variable = "outer"
#    ^^^^^^^^ definition local 1$1102583359
     [1, 2, 3].map do |variable|
#              ^^^ reference [..] Array#map().
#                      ^^^^^^^^ definition local 2$1102583359
       variable.to_s
#      ^^^^^^^^ reference local 2$1102583359
#               ^^^^ reference [..] Integer#to_s().
     end
     variable
#    ^^^^^^^^ reference local 1$1102583359
   end
#    ⌃ enclosing_range_end [..] DifferentScopeLevels#shadowing().
 
#  ⌄ enclosing_range_start [..] DifferentScopeLevels#block_local().
   def block_local
#      ^^^^^^^^^^^ definition [..] DifferentScopeLevels#block_local().
     5.times do
#      ^^^^^ reference [..] Integer#times().
       local = 123
#      ^^^^^ definition local 1$1930831942
       local * 5
#      ^^^^^ reference local 1$1930831942
#            ^ reference [..] Integer#`*`().
     end
     local = "different"
#    ^^^^^ definition local 2$1930831942
     local
#    ^^^^^ reference local 2$1930831942
   end
#    ⌃ enclosing_range_end [..] DifferentScopeLevels#block_local().
 
#  ⌄ enclosing_range_start [..] DifferentScopeLevels#captured().
   def captured
#      ^^^^^^^^ definition [..] DifferentScopeLevels#captured().
     higher = 123
#    ^^^^^^ definition local 1$1215323839
     5.times do
#      ^^^^^ reference [..] Integer#times().
       higher = 321
#      ^^^^^^ reference (write) local 1$1215323839
#      ^^^^^^^^^^^^ reference local 1$1215323839
     end
     higher
#    ^^^^^^ reference local 1$1215323839
   end
#    ⌃ enclosing_range_end [..] DifferentScopeLevels#captured().
 
#  ⌄ enclosing_range_start [..] DifferentScopeLevels#branches().
   def branches(condition)
#      ^^^^^^^^ definition [..] DifferentScopeLevels#branches().
#               ^^^^^^^^^ definition local 1$871314665
     if condition
       value = 0
#      ^^^^^ definition local 2$871314665
     else
       value = ""
#      ^^^^^ definition local 2$871314665
     end
     value
#    ^^^^^ reference local 2$871314665
   end
#    ⌃ enclosing_range_end [..] DifferentScopeLevels#branches().
 end
#  ⌃ enclosing_range_end [..] DifferentScopeLevels#
