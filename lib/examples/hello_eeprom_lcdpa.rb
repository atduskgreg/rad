class HelloEepromLcdpa < ArduinoSketch
  # -----------------------------------------------------------------------
  #    Simple Byte Write and Byte Read-back of I2C EEPROM
  #
  #      Brian Riley - Underhill Center, VT, USA  July 2008
  #                     <brianbr@wulfden.org>
  #
  #    I2C Routines are in a plugin not a library
  #    No block reads and write yet
  #    Displays to PH Anderson based serial LCD Display
  #
  #    <b>I2C Serial EEPROM - Byte Read and Byte Write</b>
  #      
  #     i2c_eeprom_write_byte  dev_addr, chip_addr, value
  #
  #     dev_addr (byte) - range 0x50 to 0x57 determined by hardware wiring 
  #     chip_addr (unsigned) - 0 to as much as 64K, depends on chip
  #     value (byte) - 0 to 255 (0x00 to 0xFF)
  #
  #     returns - nothing
  #
  #     i2c_eeprom_read_byte  dev_addr, chip_addr
  #
  #     dev_addr (byte) - range 0x50 to 0x57 determined by hardware wiring 
  #     chip_addr (unsigned) - 0 to as much as 64K, depends on chip
  #
  #     returns - byte value
  #
  #
  #     http://www.arduino.cc/playground/Code/I2CEEPROM
  # ----------------------------------------------------------------------
  
  output_pin 19, :as => :mem0, :device => :i2c_eeprom, :enable => :true
  output_pin 14, :as => :myLCD, :device => :pa_lcd, :rate => 19200


    
  def setup
      delay 1500        # give startup screen time to finish and clear
	    myLCD.clearscr    "  I2C EEPROM Demo"
      myLCD.setxy 0, 1, "byte write then read"
      myLCD.setxy 0, 2, "  back and display"
      myLCD.setxy 0, 3, "    to the LCD"
      
      clear_off_test
      myLCD.clearline 1, "  byte write test"
      
      myLCD.setxy 0, 2
      32.upto(109) do				# write address of byte to that b yte
			  |x| mem0.write_byte  x, x+7
        myLCD.print(".") if x%2
        delay 10      # EEPROM write _requires_ 3-10 ms pause
      end

      clear_off_test
      myLCD.clearline 1, "  byte read test "

      myLCD.setxy 0, 2
									# read and print 39 addresses with printable numbers
      70.upto(105) { |x| myLCD.print(mem0.read_byte(x)) }

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
