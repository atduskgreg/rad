# Hardware: LED connected on pin 7

class HelloWorld < ArduinoSketch
  output_pin 7, :as => :led
  def loop
    digitalWrite led, ON
    delay 500
    digitalWrite led, OFF
    delay 500
  end
end
