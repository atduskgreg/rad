class HysteresisDuel < ArduinoSketch
  
  # purpose 
  # side by side demo of affect of hysteresis on two different sensor readings
  # 
  #

  # requires one pa_lcd
  # two sensors or potentiometers



    output_pin 5, :as => :my_lcd, :device => :pa_lcd, :rate => 19200, :clear_screen => :true
    input_pin 1, :as => :sensor_one, :device => :sensor
    input_pin 2, :as => :sensor_two, :device => :sensor

    def setup
      delay 1000
      my_lcd.setxy 0,0, "hysteresis duel"
      delay 5000
      my_lcd.clearscr
    end

    def loop
      my_lcd.setxy 0,0, "direct"
      my_lcd.setxy 0,1, "one: "
      my_lcd.print analogRead sensor_one
      my_lcd.print " two: "
      my_lcd.print analogRead sensor_two
      my_lcd.setxy 0,2, "with hysteresis"
      my_lcd.setxy 0,3, "one: "
      my_lcd.print sensor_one.with_hyst 4
      my_lcd.print " two: "
      my_lcd.print sensor_two.with_hyst 4
      delay 230
    end

    
end
