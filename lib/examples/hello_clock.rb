class HelloClock < ArduinoSketch
  
# ----------------------------------------------------------------------------------
#   <b>Time and Temp  (20 July 2008)</b>
#   Example #1 - Brian Riley, Underhill Center, VT USA <brianbr@wulden.org>
#   
#   Connections
#     I2C bus - DS1307 Real Time Clock chip
#     Analog 0 (a.k.a Digital 14) - Wulfden K107 seria LCD Controller
#                                   Peter Anderson chip
#
#   Comment
#     - This is a straight forward program to read the Real Time Clock and Display
#     delay() calls waiting for temperature conversion readings
#
#     - for the external data busses make sure you have 4.7K pullup resistors on the 
#      the SDA/SCL (I2C)
#
# ----------------------------------------------------------------------------------
 
    @flag    = int

    array "byte clock[8]"
    
    @days   = ["Sun","Mon","Tue","Wed","Thu","Fri","Sat"]
    @months = ["Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec"]

                              # implicit in :device => :ds1307 is that this i i2c
                              # :enable => true issues the Wire.begin to ick over i2c
    output_pin 19, :as => :rtc, :device => :i2c_ds1307, :enable => :true
                              # software serial tx drives LCD display, screen cleared at startup
                              # defines the softare protocol for controller as Peter Anderson
    output_pin 14, :as => :myLCD, :device => :pa_lcd, :rate => 19200, :clear_screen => :true
    loop_timer :as => :mainloop
    

    def setup
      myLCD.clearscr "   --<Date/Time>--"
      myLCD.setxy 1,3, "looptime = "
      rtc.get clock, 1
      print_main
      @flag = 1
    end
    
    def loop
        mainloop.track
        myLCD.setxy 12,3,  mainloop.get_total
        rtc.get clock, 1
        if clock[0] == 0
          if @flag == 0
            print_main
            @flag = 1
          end
        else
          @flag = 0
        end
       	myLCD.setxy 6,2
       	printlz clock[2]
       	myLCD.print ":"
  	    printlz clock[1]
       	myLCD.print ":"
  	    printlz clock[0]

       delay 50
        
    end

    def	printlz(w)
    			myLCD.print "0" if w < 10
    			myLCD.print w
    end

    def	print_main
 	    myLCD.setxy 1,1, @days[clock[3]-1]
		  myLCD.print ", "
      myLCD.print @months[clock[5]-1]
   	  myLCD.print " "
      printlz clock[4]
   	  myLCD.print ", "
      printlz clock[6] + 2000
      
    end
    
end
