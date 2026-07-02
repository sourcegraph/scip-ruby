 # typed: true
 
#⌄ enclosing_range_start currentgem 77 CurrentGem#
 module CurrentGem
#       ^^^^^^^^^^ definition currentgem 77 CurrentGem#
#  ⌄ enclosing_range_start currentgem 77 CurrentGem#gem_fun().
   def gem_fun
#      ^^^^^^^ definition currentgem 77 CurrentGem#gem_fun().
     puts 'Hello World'
   end
#    ⌃ enclosing_range_end currentgem 77 CurrentGem#gem_fun().
 end
#  ⌃ enclosing_range_end currentgem 77 CurrentGem#
