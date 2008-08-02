class ServoSetup < ArduinoPlugin
  
  # RAD plugins are c methods, directives, external variables and assignments and calls 
  # that may be added to the main setup method
  # function prototypes not needed since we generate them automatically
  
  # directives, external variables and setup assignments and calls can be added rails style (not c style)

  # add to directives
  #plugin_directives "#define EXAMPLE 10"

  # add to external variables
  # external_variables "int foo, bar"

  # add the following to the setup method
  # add_to_setup "foo = 1";, "bar = 1;" "sub_setup();"
  
  # one or more methods may be added and prototypes are generated automatically with rake make:upload
  
  
  # one line servo control 
  #
  # move_servo my_servo, amount
  #
  # example:
  # 
  #   class MoveServo < ArduinoSketch
  #
  #     external_vars :sensor_position => "int, 0", :servo_amount => "int, 0"
  #
  #     output_pin 4, :as => :my_servo, :min => 700, :max => 2200
  #     input_pin 1, :as => :sensor
  #     def loop
  #       sensor_position = analogRead(sensor)
  #       servo_amount = (sensor_position*2 + 500)
  #       move_servo my_servo, servo_amount
  #     end
  #   end
  #
  #
  #  supports multiple servos by storing variables in the serv struc array that is constructed when
  #  the :min and :max options are added to the output_pin method
  

add_servo_struct

void move_servo(int servo_num, int pulse_width)
{
  struct servo servo_name = serv[servo_num];

  int pw = pulse_width;
  /* apply the servo limits */
  if (pw > servo_name.max)
    pw = servo_name.max;
  if (pw < servo_name.min)
    pw = servo_name.min;

  if (millis() - servo_name.lastPulse >= servo_name.refreshTime)
    {
      pulse_servo(servo_name.pin, pw);
      servo_name.lastPulse = millis();
      // if (find_total_loop_time() < 10)
      // for debug:
      // digitalWrite( 5, HIGH );
      // 18 seems optimal, but we should let the users adjust with a servo option
      delay(18);
    }

}

void pulse_servo(int pin, int us) {
  digitalWrite( pin, HIGH );
  // pulseWidth
  delayMicroseconds( us );
  digitalWrite( pin, LOW );
  serv[pin].pulseWidth = us;
}






    

end