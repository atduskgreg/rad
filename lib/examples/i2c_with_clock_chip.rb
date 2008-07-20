class I2cWithClockChip < ArduinoSketch
  
# ----------------------------------------------------------------------------------
#   <b>Time and Temp  (20 July 2008)</b>
#   Example #1 - Brian Riley, Underhill Center, VT USA <brianbr@wulden.org>
#   
#   Connections
#     I2C bus - DS1307 Real Time Clock chip
#     Analog 0 (a.k.a Digital 14) - Wulfden K107 seria LCD Controller
#                                   Peter Anderson chip
#     Digital 8 - Dallas SemiConductor DS18B20 One-Wire temperature Sensor (12 bit)
#
#   Comment
#     - This is a straight forward, program with minimal error checking and brute force
#     delay() calls waiting for temperature conversion readings
#
#     - for the external data busses make sure you have 4.7K pullup resistors on the 
#     data line (OnewWire) and the SDA/SCL (I2C)

# ----------------------------------------------------------------------------------
 
    @hi_byte    = int
    @lo_byte    = int
    @t_reading  = int
    @device_crc = int
    @sign_bit   = int
    @tc_100     = int
                              # implicit in :device => Z:ds1307 is that this i i2c
                              # :enable => true issues the Wire.begin to ick over i2c
    output_pin 19, :as => :rtc, :device => :i2c_ds1307, :enable => :true
                              # software serial tx drives LCD display, screen cleared at startup
                              # defines the softare protocol for controller as Peter Anderson
    output_pin 14, :as => :myLCD, :device => :pa_lcd, :rate => 19200, :clear_screen => :true
                              # defines  this pin as being connected to a DalSemi 1-Wire device
                              # no specific device drivers yet, the specific device code is on you
    output_pin 8, :as => :myTemp, :device => :onewire


    def loop
  		  until myTemp.reset do   # reset bus, verify its clear and high
  		    clear_bottom_line
  		    myLCD.print " <1Wire Buss Error>"
  		    delay 2000
  		  end
   		
    		myTemp.skip                 # "listen up - everybody!"
    		myTemp.write 0x44, 1        # temperature sensors, strta conversion

    		myLCD.setxy 6,0             # while they do that, lets print date/time
  	    myLCD.print rtc.get(5, 1)
       	myLCD.print "/"
  	    myLCD.print rtc.get(4, 0)
       	myLCD.print "/"
  	    myLCD.print rtc.get(6, 0)
       	myLCD.setxy 6,1
       	printlz rtc.get(2, 0)
       	myLCD.print ":"
  	    printlz rtc.get(1, 0)
       	myLCD.print ":"
  	    printlz rtc.get(0, 0)

    		delay 800                   # conversion takes about 750 msecs

    		until myTemp.reset do       # reset bus, verify its clear and high
    		  clear_bottom_line
    		  myLCD.print " <1Wire Buss Error>"
    		  delay 2000
    		end
     		myTemp.skip                 # listen up!
    		myTemp.write 0xBE, 1        # send me your data conversions

        @lo_byte = myTemp.read      # get irst byte
        @hi_byte = myTemp.read      # get second byte
        
        # -------------------------------------------------------------
        clear_bottom_line       # this code is debug - not necessary
        myLCD.setxy 4,3         # raw hex display of temp value
        myLCD.print "raw = 0x"
        print_hexbyte @hi_byte  # prints 2 digit hex w/lead 0
        print_hexbyte @lo_byte
        # -------------------------------------------------------------

        7.times { @device_crc = myTemp.read } # get next 6 bytes, drop them on floor
                                              # next byte the ninth byte is the CRC
        
                                # DS18B20 brings data temperature back as 12 bits
                                # in degrees centigrade with 4 bits fractional, that is 
                                # each bit s 1/16 of a degreeC
                                
        @t_reading  =   build_int @hi_byte, @lo_byte
        @sign_bit   =   bit_and @t_reading, 0x8000
        @t_reading  =   twos_comp @t_reading   if @sign_bit  # negative

        @tc_100 = (6 * @t_reading) + (@t_reading / 4)   #multiply by (100 * 0.0625) or 6.25

        myLCD.setxy 2,2
        if @sign_bit
            myLCD.print "-"
        else
            myLCD.print " "
        end
        myLCD.print(@tc_100 / 100)             # separate off the whole 
        myLCD.print "."
        printlz(@tc_100 % 100)                  # and fractional portions
        myLCD.print " degrees C"

    end

    def	printlz(w)
    			myLCD.print "0" if w < 10
    			myLCD.print w
    end

    def	print_hexbyte(w)
    			myLCD.print "0" if w < 0x10
    			myLCD.print w, 0x10
    end

    def clear_bottom_line
		      myLCD.setxy 0,3
		      myLCD.print "?l"
    end
    
end
