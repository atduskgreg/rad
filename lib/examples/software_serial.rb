class SoftwareSerial < ArduinoSketch
  output_pin 13, :as => :led
  software_serial 6, 7, :as => :gps
  serial_begin

  def loop
    digitalWrite(led, true)
    serial_print(gps.read)
  end
end