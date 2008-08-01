class HelloArrayEeprom < ArduinoSketch

   # ----------------------------------------------------------------------
   #    Checking out various array operations  with I2C serial EEPROM
   #      doing block writes and bloack readbacks with byte arrays
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

 # when we just need to declare an array, or need more control, such as specific type requirements
 array "byte page_data[20] = {'R', 'A', 'D', ' ', 'i', 's', ' ', 'B', 'A', 'D', '*', '!', ')', '=', 'P', '-', '+', 'R', 'I', 'K'}"
 array "byte in_buffer[20]"
 
 output_pin 19, :as => :mem0, :device => :i2c_eeprom, :address => 1     # w/o :address defaults to  :address => 0  which is  0x50
 output_pin 14, :as => :my_lcd, :device => :pa_lcd, :rate => 19200
 
 
 def setup
   
   my_lcd.clearscr    "  I2C EEPROM Demo"
   my_lcd.setxy 0, 1, "block write and read"
   my_lcd.setxy 0, 2, "  back and display"
   my_lcd.setxy 0, 3, "    to the LCD"
   
   delay 2000
   
   my_lcd.clearscr    "  I2C EEPROM Demo?n    block write"

   mem0.write_page 0x0100, page_data, 20 

   delay 1000
   
   my_lcd.clearline 1, "  block readback"
   
   mem0.read_buffer 0x0100, in_buffer, 20 
   
   my_lcd.setxy 0, 2
   
   1.upto(20) do |x|
     my_lcd.print in_buffer[x-1]
     my_lcd.print " "
   end
   
 end
 
 def loop
    x = THROWAWAY
 end

end