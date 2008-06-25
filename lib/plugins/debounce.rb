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

int debounce_read(int input)
{
  struct debounce btn = dbce[input];
  btn.read = digitalRead(input);
  if (btn.read == LOW && millis() - btn.time > btn.adjust) {
    /* are we sure */
      return HIGH;
  }
  else {      
      return LOW;
  }
  dbce[input].prev = btn.read;
}


int debounce_toggle(int input, int output)
{
  struct debounce btn = dbce[input];
  btn.read = digitalRead(input);

  /* if we just pressed the button (i.e. the input went from LOW to HIGH), */
  /* and we've waited long enough since the last press to ignore any noise...  */
  if (btn.read == HIGH && btn.prev == LOW && millis() - btn.time > btn.adjust) {
    // ... invert the output
    if (btn.state == HIGH)
      dbce[input].state = LOW;
    else
      dbce[input].state = HIGH;

    /* save time of last press */
    dbce[input].time = millis();    
  }

  digitalWrite(output, btn.state);

  dbce[input].prev = btn.read;
  return btn.state;
}

    
end