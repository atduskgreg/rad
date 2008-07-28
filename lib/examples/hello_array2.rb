class HelloArray2 < ArduinoSketch

   # ----------------------------------------------------------------------
   #    Checking out various array operations
   #
   #      JD Barnhart - Seattle, WA July 2008
   #      Brian Riley - Underhill Center, VT, USA  July 2008
   #                     <brianbr@wulfden.org>
   #
   # ----------------------------------------------------------------------

 # still working this out...
 # for example, new instance style array declaration naming
 # is at odds with original style array naming  

 define "THROWAWAY 0"
 
 # for simple integer, string, float, and boolean arrays  
 @toppings = [1,2,3]
 @names = ["ciero", "bianca", "zeus", "athena", "apollo"]
 
 # when we just need to declare an array, or need more control, such as specific type requirements
 array "int ingredients[10]"
 array "int pizzas[] = {1,2,3,4}"
 array "byte buffer[20] = {'A', 'B', 'Z', 'C', 'Y', 'D', 'W', 'E', '%', 'H', '*', '!', ')', '=', 'P', '-', '+', 'R', 'I', 'K'}"
 
 output_pin 14, :as => :my_lcd, :device => :pa_lcd, :rate => 19200, :clear_screen => :true
 
 
 def setup
   
   my_lcd.clearscr "toppings: "
   delay 500
   
   @toppings.each do |a|
     my_lcd.print a
     my_lcd.print " "
     delay 500
   end
   
   my_lcd.setxy 0,1, "pizzas: "
   
   pizzas.each do |p|
     my_lcd.print p
     my_lcd.print " "
     delay 500
   end
   
   my_lcd.setxy 0,2, "names: "
   
   @names.each do |p|
     my_lcd.print p
     my_lcd.print " "
     delay 500
   end
   
   delay 3000
   
   my_lcd.clearline 1, @names[2]
   my_lcd.print " [ "
   my_lcd.print pizzas[1]
   my_lcd.print " ]"
   
   delay 2000
   
   my_lcd.clearscr "Array Load?n"
   1.upto(20) do |x|
#     buffer[x] = 64 + x  # we cannot set array elements yet except to initialize in declaration
     my_lcd.print buffer[x-1]
     my_lcd.print " "
   end
   
 end
 
 def loop
    x = THROWAWAY
 end

end