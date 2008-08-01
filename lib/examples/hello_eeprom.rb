class HelloEeprom < ArduinoSketch
  
  output_pin 19, :as => :rtc, :device => :i2c_ds1307, :enable => :true
  output_pin 19, :as => :mem0, :device => :i2c_eeprom

  output_pin 14, :as => :myLCD, :device => :pa_lcd, :rate => 19200
    
  def loop
	    myLCD.setxy 0,0					# set to 0,0
	    myLCD.print rtc.get(5, 1)	# refresh registers (=1) get month
     	myLCD.print "/"
	    myLCD.print rtc.get(4, 0)	# no need to refresh (=0) get day 
     	myLCD.print "/"
	    myLCD.print rtc.get(6, 0)	# get year
     	myLCD.setxy(0,1)			# set in 1 byte line 1 (second line)
     	printlz 2					# print hours with lead zero
     	myLCD.print ":"
	    printlz 1					# print minutes with lead zero
     	myLCD.print ":"
	    printlz 0					# print seconds with lead zero
	    

		myLCD.setxy 10,0
		myLCD.print "write test"
		myLCD.setxy 0,2
		32.upto(109) do				# write address of byte to that b yte
			|x| mem0.write_byte  x, x
			myLCD.print(".") if x%2
			delay 10
		end

		delay 2000
		
		myLCD.clearline 2 	# clears bottom two lines           
		myLCD.clearline 3

		myLCD.setxy 10,0, "read test "
		myLCD.setxy 0,2
									# read and print 39 addresses with printable numbers
		75.upto(113) { |x| myLCD.print(mem0.read_byte(x)) }
		delay 10000
		myLCD.clearscr
  end
  
  def	printlz(w)
  			i = 0 + rtc.get(w,0)         # the '0 +' is YARH (Yet Another RubyToc Hack)
  			myLCD.print "0" if i < 10
  			myLCD.print i
  end

end
