class HelloEepromLcdpa < ArduinoSketch
  
  output_pin 19, :as => :mem0, :device => :i2c_eeprom, :enable => :true
  output_pin 14, :as => :myLCD, :device => :pa_lcd, :rate => 19200


    
  def setup
      delay 1500        # give startup screen time to finish and clear
	    myLCD.clearscr    "  I2C EEPROM Demo"
      myLCD.setxy 0, 1, "byte write then read"
#      delay 10          #01234567890123456789
      myLCD.setxy 0, 2, "  back and display"
#      delay 10
      myLCD.setxy 0, 3, "    to the LCD"
#      delay 10
      
      clear_off_test
      myLCD.clearline 1, "  byte write test"
      
      myLCD.setxy 0, 2
      32.upto(109) do				# write address of byte to that b yte
			  |x| i2c_eeprom_write_byte  0x50, x, x
        myLCD.print(".") if x%2
        delay 10      # EEPROM write _requires_ 3-10 ms pause
      end

      clear_off_test
      myLCD.clearline 1, "  byte read test "

      myLCD.setxy 0, 2
									# read and print 39 addresses with printable numbers
      75.upto(113) { |x| myLCD.print(i2c_eeprom_read_byte(0x50, x)) }

      delay 2000
      clear_off_test
      myLCD.clearline 1, "-< tests complete >- "


  end
  
  def loop
    x = 4       # loop has to have _something_
  end


   def clear_off_test   # clears bottom two lines 
     delay 2000
     myLCD.clearline 3
     myLCD.clearline 2   # leaves you at start of a 
                              # cleared third line
   end

end
