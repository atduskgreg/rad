class ServoThrottle < ArduinoSketch

     # updated 20080731 
     # replaced external variables with instance style variables
     
     # potentiometer to control servo
     # with a bit of hysteresis
     # use analog pin for sensor
     # need to format the output of sensor_position and sensor_amount

     @sensor_position = 0
     @servo_amount = 0

     output_pin 5, :as => :my_lcd, :device => :sf_lcd
     input_pin 1, :as => :sensor
     output_pin 2, :as => :my_servo, :device => :servo


       def loop
         servo_refresh
         #delay 9 # comment out if using servo status, since it will add enough delay
         @sensor_position = analogRead(sensor)
         @servo_amount = (add_hysteresis(@sensor_position, 10)*0.36)
         my_servo.position @servo_amount
         servo_status
         
       end
       
       def servo_status
         
        my_lcd.setxy 0,0			# line 0, col 0
     		my_lcd.print "Read  Send"
     		my_lcd.setxy 0,1		# line 1, col 0
     		my_lcd.print @sensor_position # need method of blanking out previous reading
     		my_lcd.setxy 6,1 
     		my_lcd.print @servo_amount
       end

  
end