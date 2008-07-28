class Hysteresis < ArduinoPlugin
  
# jdbarnhart
# 20080728
#
#
# purpose
#
# add hysteresis to analog readings, typically sensors or potentiometers
#
# use
# two steps
#
#  one
#    declare :device => :sensor 
#    example:
#      input_pin 1, :as => :sensor_one, :device => :sensor
#
#  two
#    instead of:
#      my_lcd.print analogRead sensor_two
#      use add_hyst
#      my_lcd.print sensor_one.with_hyst 4
#      
#      # note, 4 is the amount of hysteresis
#
#
void with_hysteresis(int pin, int amt)
{
  with_hyst(pin, amt);
}

int with_hyst(int pin, int amt)
{
  int read;
  unsigned int i;
  read = analogRead(pin);
  for (i = 0; i < (int) (sizeof(hyst) / sizeof(hyst[0])); i++) {   
    if (pin == hyst[i].pin) {
      if (((read - hyst[i].state) > amt ) || ((hyst[i].state - read) > amt )) {
        hyst[i].state = read;
        return hyst[i].state;
      } 
      else
        return hyst[i].state;      
    }
  }
}



end