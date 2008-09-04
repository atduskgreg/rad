class HelloXbee < ArduinoSketch
  
  output_pin 13, :as => :led
  
  serial_begin
  def loop
    led.blink 200
    serial_print "...testing..."
    delay 1000
  end
  
end