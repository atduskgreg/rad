class SpectraSoftPot < ArduinoSketch

  # demonstrate capibility to treat soft pot as traditional pot
  # the pot reading remains "locked" to the last touch point
  # same behavior as ipod
  #
  # this assumes a pa_lcd operating at 19200 and one 
  # spectrasymbol softpot connected to analog pin 3
  # which can be done with blink m address assignment

  output_pin 5, :as => :my_lcd, :device => :pa_lcd, :rate => 19200, :clear_screen => :true
  input_pin 3, :as => :sensor_one, :device => :spectra


   def setup
     delay 1000
     my_lcd.setxy 0,0, "spectrasymbol"
     delay 5000
     my_lcd.clearscr
   end

   def loop
     my_lcd.setxy 0,1
     # since lcd's have issues with clearing tens and hundreds digits when reading ones, 
     # we use pad_int_to_str, which is a hack to display these cleanly
     # pad_int_to_str takes two arguments: an integer and the final string length
     # 
     my_lcd.print pad_int_to_str sensor_one.soft_lock, 3
     delay 100
   end
    

end