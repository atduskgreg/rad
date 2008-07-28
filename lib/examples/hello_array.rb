class HelloArray < ArduinoSketch

 # still working this out...
 # for example, new instance style array declaration naming
 # is at odds with original style array naming  
 
 # for simple integer, string, float, and boolean arrays  
 @toppings = [1,2,3]
 @names = ["ciero", "bianca", "antica"]
 
 # when we just need to declare an array, or need more control, such as specific type requirements
 array "int ingredients[10]"
 array "int pizzas[] = {1,2,3,4}"
 
 output_pin 5, :as => :my_lcd, :device => :pa_lcd, :rate => 19200, :clear_screen => :true
 
 
 def loop
   
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
   
   
 end

end