class Debounce < ArduinoPlugin
  

  # RAD plugins are c methods, directives, external variables and assignments and calls 
  # that may be added to the main setup method
  # function prototypes not needed since we generate them automatically
  
  # directives, external variables and setup assignments and calls can be added rails style (not c style)
  # hack from http://www.arduino.cc/cgi-bin/yabb2/YaBB.pl?num=1209050315

  # plugin_directives "#undef int", "#include <stdio.h>", "char _str[32];", "#define writeln(...) sprintf(_str, __VA_ARGS__); Serial.println(_str)"
  # add to directives
  #plugin_directives "#define EXAMPLE 10"

  # add to external variables
  # ok, we need to deal with 
  # what about variables 
  # need to loose the colon...
  # external_variables "char status_message[40] = \"very cool\"", "char* msg[40]"

  # add the following to the setup method
  # add_to_setup "foo = 1";, "bar = 1;" "sub_setup();"
  
  # one or more methods may be added and prototypes are generated automatically with rake make:upload
  
# call pulse(us) to pulse a servo 


add_debounce_struct

# increase the debounce_setting, increase if the output flickers 
# need docs..
# and testing
#
# remember these are being called from the loop (typically)
# 
# NOTE: if two buttons are controlling one output, today, strange
#       things will happen since each button tries to assert its own state
#       suggestion: we can fix this with an array of structs for shared outputs
#       ie: output_pin 5, :as => :yellow_led, :shared => :yes # default no
#       this would put the state at the output which could be compared to 
#       the inputs_state and override and set it if different

## Todo: reduce to two methods named read_input and read_and_toggle

# consider adding "toggle" method that points to toggle_output

int toggle_output(int output)
{
  if (dbce[output].state == HIGH)
    dbce[output].state = LOW;
  else
    dbce[output].state = HIGH;
    digitalWrite(output, dbce[output].state);

    return dbce[output].state;
}

int read_input(int input)
{
  return debounce_read(input);
}


int debounce_read(int input)
{
  struct debounce btn = dbce[input];
  /* input is HIGH (1) for open and LOW (0) for closed circuit */
  dbce[input].read = digitalRead(input);
  if (btn.read == LOW && millis() - btn.time > btn.adjust) {
      dbce[input].time = millis();
      return HIGH;
  }
  else {      
      return LOW;
  }
  dbce[input].prev = btn.read;
}


int read_and_toggle(int input, int output)
{
  return debounce_toggle(input, output);
}

int debounce_toggle(int input, int output)
{
  dbce[input].read = digitalRead(input);

  /* if we just pressed the button  */
  /* and we've waited long enough since the last press to ignore any noise...  */
  if (dbce[input].read == HIGH && dbce[input].prev == LOW && millis() - dbce[input].time > dbce[input].adjust) {
    // ... invert the output
    if (dbce[input].state == HIGH)
      dbce[input].state = LOW;
    else
      dbce[input].state = HIGH;

    /* save time of last press */
    dbce[input].time = millis();    
  }

  digitalWrite(output, dbce[input].state);

  dbce[input].prev = dbce[input].read;
  
  return dbce[input].state; 
}

    
end