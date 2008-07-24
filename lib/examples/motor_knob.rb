class MotorKnob < ArduinoSketch

# ----------------------------------------------------------
#    MotorKnob adapted from Tom Igoe's Arduino Sketch
#
#      Brian Riley - Underhill Center, VT, USA  July 2008
#                     <brianbr@wulfden.org>
#
#    A stepper motor follows the turns of a potentiometer
#    (or other sensor) on analog input 0.
#
#     http://www.arduino.cc/en/Reference/Stepper
# ----------------------------------------------------------

  fourwire_stepper  8, 9, 10, 11, :as => :mystepper, :speed => 31, :steps => 200
  input_pin  0, :as => :sensor
  
  
  @previous = "0, int"
  @value    = "0, int"
  
  def loop
    
    @value = analogRead(sensor)
    mystepper.set_steps @value - @previous
    @previous = @value 
    
  end

end