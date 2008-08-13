class HelloSpectraSound < ArduinoSketch

  # demonstrate capability to use soft pot as traditional pot
  # the last pot reading remains "locked" to the last touch point
  # similar same behavior as ipod
  #
  # this sketch assumes a pa_lcd operating at 19200 and one 
  # spectra symbol softpot connected to analog pin 3
  # 
  @reading  = int
  output_pin 14, :as => :my_lcd, :device => :pa_lcd, :rate => 9600, :clear_screen => :true
  output_pin 11, :as => :sound, :device => :freq_out, :frequency => 100, :enable => :true
  input_pin 3, :as => :sensor_one, :device => :spectra


   def setup
     delay 1000
     my_lcd.setxy 0,0, "spectra symbol"
     my_lcd.setxy 0,1, "soft pot sound"
     delay 3000
     my_lcd.clearscr
   end

   def loop
     my_lcd.setxy 0,1
     # since lcd's have issues clearing tens and hundreds digits when reading ones, 
     # we use pad_int_to_str, which is a hack to display these cleanly
     # pad_int_to_str takes two arguments: an integer and the final string length
     # 
#     my_lcd.print pad_int_to_str analogRead(sensor_one), 5
     @reading = sensor_one.soft_lock
     sound.set_frequency @reading * 10
     my_lcd.print pad_int_to_str @reading, 3
     delay 30
   end
    

end