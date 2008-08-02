class Blink < ArduinoPlugin
  
  # RAD plugins are c methods, directives, external variables and assignments and calls 
  # that may be added to the main setup method
  # function prototypes not needed since we generate them automatically
  
  # directives, external variables and setup assignments and calls can be added rails style (not c style)


  # add to directives
 
  # add to external variables
 
  # add the following to the setup method
  # add_to_setup 


  void blink(int pin, int ms) {
  	digitalWrite( pin, HIGH );
  	delay( ms );
  	digitalWrite( pin, LOW );
  	delay( ms );
  }

end