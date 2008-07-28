class SparkfunLcd < ArduinoSketch


  input_pin 6, :as => :button_one, :latch => :off
  input_pin 7, :as => :button_two, :latch => :off
  input_pin 8, :as => :button_three, :latch => :off
  output_pin 13, :as => :led
  
  swser_LCDsf 5, :as => :my_lcd
  



#serial_begin # not necessary when using :device => :sf_lcd or :pa_lcd

  def loop
   check_buttons
  end
  

# need a bit

  def say_hello
    my_lcd.setxy 0,0			# line 0, col 0
		my_lcd.print "All your base   "
		my_lcd.setxy 0,1		# line 1, col 0
		my_lcd.print "are belong to us"
  
  end 
  
  def	say_ruby
		my_lcd.setxy 0,0			# line 0, col 0
		my_lcd.print " Ruby + Arduino "
		my_lcd.setxy 0,1		# line 1, col 0
		my_lcd.print " RAD 0.2.4+     "
		# un comment to change display startup
		#myLCD.setcmd 0x7C, 10
	end

  def check_buttons
  	read_and_toggle button_one, led
  	say_hello if read_input button_two
  	say_ruby if read_input button_three
  	
  	
  end
  
end