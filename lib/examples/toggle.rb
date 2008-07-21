class Toggle < ArduinoSketch

    output_pin 13, :as => :led

       def loop
         led.toggle
         delay 300
       end

  end