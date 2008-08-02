class BlinkWithSerial < ArduinoSketch
  
  # hello world (uncomment to run)
  @i  = "0, long"
  
  output_pin 13, :as => :led
  
  serial_begin
  
    def loop
      @i += 1
      serial_println @i
      blink led, 100 
    end

end
