class DebugOutputToLcd < ArduinoPlugin
  
  # RAD plugins are c methods, directives, external variables and assignments and calls 
  # that may be added to the main setup method
  # function prototypes not needed since we generate them automatically
  
  # directives, external variables and setup assignments and calls can be added rails style (not c style)

# add to directives
#plugin_directives "#define ARY_SIZE 10"
  
# add to external variables
#external_variables "unsigned long start_loop_time = 0;", "unsigned long total_loop_time = 0;"

# add the following to the setup method
#add_to_setup "scan = &sm_ary[0];", "cur = &sm_ary[0];", "start = &sm_ary[0];", "end = &sm_ary[ARY_SIZE-1];"

# add an element to the array and return the average

# need a nice home for these





void send_servo_debug_to_lcd(int servo)
{
  lcd_first_line();
  Serial.print("pw ");
  Serial.print( find_servo_pulse_width(servo));
  Serial.print(" lp ");
  Serial.print( find_servo_last_pulse(servo));
  Serial.print("s");
  Serial.print( find_servo_start_pulse(servo));
//  Serial.print(" t");
//  Serial.print( find_debounce_time(servo));

  lcd_second_line();
  Serial.print("d");
//  Serial.print( millis() - find_debounce_time(servo));
  Serial.print(" m");
  Serial.print(millis());
  
}


void send_button_debug_to_lcd(int button)
{
  
  lcd_first_line();
  Serial.print("r");
  Serial.print( find_debounce_read(button));
  Serial.print("p");
  Serial.print( find_debounce_prev(button));
  Serial.print("s");
  Serial.print( find_debounce_state(button));
  Serial.print(" t");
  Serial.print( find_debounce_time(button));

  lcd_second_line();
  Serial.print("d");
  Serial.print( millis() - find_debounce_time(button));
  Serial.print(" m");
  Serial.print(millis());
  
}




end