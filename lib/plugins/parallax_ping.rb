class ParallaxPing < ArduinoPlugin

  # RAD plugins are c methods, directives, external variables and assignments and calls 
  # that may be added to the main setup method
  # function prototypes not needed since we generate them automatically
  
  # directives, external variables and setup assignments and calls can be added rails style (not c style)

  # add to directives
  # plugin_directives "#define EXAMPLE 10"

  # add to external variables
  # external_variables "int foo, bar"

  # add the following to the setup method
  # add_to_setup "foo = 1";, "bar = 1;" "sub_setup();"
  
  # one or more methods may be added and prototypes are
  
  # Methods for the Parallax Ping)) UltraSonic Distance Sensor.
  # 
  # Example:
  #
  # class RangeFinder < ArduinoSketch
  #   serial_begin
  #   
  #   external_vars :sig_pin => 'int, 7'
  #   
  #   def loop
  #     serial_println(ping(sig_pin)) 
  #     delay(200) 
  #   end
  # end

  # Triggers a pulse and returns the delay in microseconds for the echo.
  int ping(int pin) {
    pinMode(pin, OUTPUT);

    digitalWrite(pin, LOW);
    delayMicroseconds(2);
    digitalWrite(pin, HIGH);
    delayMicroseconds(5);
    digitalWrite(pin, LOW);

    pinMode(pin, INPUT);

    return pulseIn(pin, HIGH);
  }

end