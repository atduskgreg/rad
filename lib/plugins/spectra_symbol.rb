class SpectraSymbol < ArduinoPlugin
  
# jdbarnhart
# 20080729
#
# crazy experiment in progress
# purpose
#
# retain last reading after finger is removed from spectrasymbol
# soft pot
#
# use
# two steps
#
#  one
#    declare :device => :sensor 
#    example:
#      input_pin 1, :as => :sensor_one, :device => :spectra
#
#  two
#    instead of:
#      my_lcd.print analogRead sensor_two
#      use soft_lock
#      my_lcd.print sensor_one.spectra_lock
#      
#
# notes:
# experimental settings for 100mm spectrasymbol
# 
# hysteresis is set at 5 
# amount of sensor drop is set to 3
# delay time (dtime) is 4
# cutoff set to 10
#
int soft_lock(int pin)

{
  int hyst = 5;
  int drop = 3;
  int dtime = 4;
  int cutoff = 10;
  int read;
  int r1;
  int r2;
  int r3;
  unsigned int i;
  read = analogRead(pin)/4;
  delay(dtime);
  r1 = analogRead(pin)/4;
  delay(dtime);
  r2 = analogRead(pin)/4;
  delay(dtime);
  r3 = analogRead(pin)/4;
  delay(dtime);
  for (i = 0; i < (int) (sizeof(spec) / sizeof(spec[0])); i++) {   
    if (pin == spec[i].pin) {
      if (((r3 - r2) > drop) && ((r2 - r1) > drop) && ((r1 - read) > drop)) 
        return spec[i].state - 10;
      else
      {
      if (read < cutoff) 
        return spec[i].state - 10;
      else
      {
          if (((read - spec[i].state) > hyst ) || ((spec[i].state - read) > hyst )) {
            spec[i].state = read;
            return spec[i].state - 10;
          } 
          else
            return spec[i].state - 10;   
        } 
      }   
    } 
  } 
}



end