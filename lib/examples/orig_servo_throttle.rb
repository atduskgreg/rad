class OrigServoThrottle < ArduinoSketch
  
     # old school servo control
     # uses pulsewidth for positioning
     # potentiometer to control servo
     # with a bit of hysteresis
     # use analog pin for sensor
     # need to format the output of sensor_position and sensor_amount
     # probably going away soon

     
     external_vars :sensor_position => "int, 0", :servo_amount => "int, 0", :pw => "int, 0", :time_check => "unsigned long, 0"

     output_pin 5, :as => :my_lcd, :device => :sf_lcd
     input_pin 1, :as => :sensor
     output_pin 2, :as => :my_servo, :min => 700, :max => 2200 #, :refresh => 60


       def loop
         #delay 9 # comment out if using servo status, since it will add enough delay
         sensor_position = analogRead(sensor)
         servo_amount = (add_hysteresis(sensor_position, 10)*2 + 500)
         move_servo my_servo, servo_amount
         servo_status
         
       end
       
       def servo_status
         
        my_lcd.setxy 0,0			# line 0, col 0
     		my_lcd.print "Read  Send"
     		my_lcd.setxy 0,1		# line 1, col 0
     		my_lcd.print sensor_position # need method of blanking out previous reading
     		my_lcd.setxy 6,1 
     		my_lcd.print servo_amount
       end

  
end