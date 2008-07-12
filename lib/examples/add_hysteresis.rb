class AddHysteresis < ArduinoSketch
  
  input_pin 3, :as => :sensor
  output_pin 13, :as => :led


  def loop
    reading = add_hysteresis sensor, 8
    blink led, 100 if reading > 100
    blink led, 1000 if reading <= 100
  end
  
end
