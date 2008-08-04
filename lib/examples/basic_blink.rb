class BasicBlink < ArduinoSketch
  # hello world (uncomment to run)
  
  output_pin 13, :as => :led
  
  def loop
    blink led, 100 
    x = 4
  end
end
