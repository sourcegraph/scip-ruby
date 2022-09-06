 # typed: true
 
 class X
#      ^ definition [..] X#
   alias_method :am_aaa, :aaa
   alias :a_aaa :aaa
 
   def aaa
#      ^^^ definition [..] X#aaa().
     puts "AAA"
   end
 
   def check_alias
#      ^^^^^^^^^^^ definition [..] X#check_alias().
     return [am_aaa, a_aaa]
#            ^^^^^^ reference [..] X#am_aaa().
#                    ^^^^^ reference [..] X#a_aaa().
   end
 end
