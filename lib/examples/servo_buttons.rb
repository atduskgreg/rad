class ServoButtons < ArduinoSketch
  
  # original syntax
  input_pin 6, :as => :button_one, :latch => :off
  # preferred syntax
  input_pin 7, :as => :button_two, :device => :button
  input_pin 8, :as => :button_three, :device => :button
  output_pin 13, :as => :led 
  output_pin 2, :as => :my_servo, :device => :servo 
  

  def loop
   check_buttons
   servo_refresh 
  end

  def check_buttons
  	read_and_toggle button_one, led
  	my_servo.position 180 if read_input button_two
  	my_servo.position 60 if read_input button_three
  end
  
end