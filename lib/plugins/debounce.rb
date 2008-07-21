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

#####################

## How this works

##  The cast:
##   a normally open push button (circuit is closed when button is depressed)
##    variables [input].
##    [input]read: or current read -- what we see from the input pin HIGH (1) untouched or LOW (1) depressed
##    [input]prev: or previous read – assigned to current reading at the end of the method
##    [input]state: the stored state HIGH (1) or LOW (0)
##    [input]time: the time when we last had a true
##    millis: number of milliseconds since the Arduino began running the current program

## So….

##    If HIGH and the [input]read was LOW (button was depressed since the last time we looped) AND If millis() - [input]time  > 200
##    Flip the state
##    And assign [input]time millis()
##    Else Set the pin to [input]state 
##    Assign [input]prev to [input]read

## abstract summary:

##    So 99%+ of the time, we always see a HIGH (unless the button is pushed)
##    If the button is pushed, we record this LOW to [input]prev, so the next time we enter the loop and the button is not being pushed we see true as long as millis() minus the [input]time of the last toggle is greater the 200 (adjust, which can be set with an adjust option)


######################


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



int toggle(int output)
{
  return toggle_output(output);
}

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
  int state = LOW;
  dbce[input].read = digitalRead(input);

  if (dbce[input].read == HIGH && dbce[input].prev == LOW && millis() - dbce[input].time > dbce[input].adjust)
     {
      dbce[input].time = millis();
      state = HIGH;
    }
  else 
    state = LOW;
    
      dbce[input].prev = dbce[input].read;
      return state;
}


int toggle(int input, int output)
{
  return read_and_toggle(input, output);
}

int read_and_toggle(int input, int output)
{
  dbce[input].read = digitalRead(input);
  // did we just release a button which was depressed the last time we checked and over 200 millseconds has passed since this statement was last true?
  if (dbce[input].read == HIGH && dbce[input].prev == LOW && millis() - dbce[input].time > dbce[input].adjust) {
    // ... flip the output
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