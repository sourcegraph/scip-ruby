 # typed: true
 
 class X
#      ^ definition [..] X#
   alias_method :am_aaa, :aaa
#  ^^^^^^^^^^^^ reference [..] Module#alias_method().
   alias :a_aaa :aaa
 
   def aaa
#      ^^^ definition [..] X#aaa().
     puts "AAA"
#    ^^^^ reference [..] Kernel#puts().
   end
 
   def check_alias
#      ^^^^^^^^^^^ definition [..] X#check_alias().
     return [am_aaa, a_aaa]
#            ^^^^^^ reference [..] X#aaa().
#                    ^^^^^ reference [..] X#aaa().
   end
 end
