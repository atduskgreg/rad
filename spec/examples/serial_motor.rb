# Hardware: motor control circuit (i.e. TIP-120 control pin)
#           connected at pin 7.
#     Demo: http://www.youtube.com/watch?v=7OguEBfdTe0

class SerialMotor < ArduinoSketch
  output_pin 7, :as => :motor
  serial_begin
  
  def loop
    digitalWrite(motor, serial_read) if serial_available
  end
end
