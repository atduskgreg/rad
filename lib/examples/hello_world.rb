class HelloWorld < ArduinoSketch
  
  output_pin 13, :as => :led

  def loop
    blink led, 100
  end

end


