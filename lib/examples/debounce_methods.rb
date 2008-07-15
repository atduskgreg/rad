class DebounceMethods < ArduinoSketch
  
  output_pin 13, :as => :led 
  input_pin 6, :as => :button_one, :device => :button # can also :adjust => 300
  input_pin 7, :as => :button_two, :device => :button
  input_pin 8, :as => :button_three, :device => :button
  input_pin 9, :as => :button_four, :device => :button  
  input_pin 10, :as => :button_five, :device => :button  
  
  # depressing and releasing button_one, button_two or button_four do the same thing
  # with a slightly different syntax and number of blinks
  # button_three simply toggles the led with the read_and_toggle method
  # button_five does it with a twist

     def loop
       blink_twice if read_input button_one
       blink_three_times if read_input button_two
       button_three.read_and_toggle led #  
       blink_three_times_basic if read_input button_four
       blink_with_a_twist if read_input button_five
     end
     
     def blink_twice
        2.times do |i|
          led.blink 200 + i
        end
      end
     
     def blink_three_times
       3.times { led.blink 200 }
     end

     # no blink helper
     def blink_three_times_basic
       4.times do 
         led.digitalWrite HIGH
         delay 200
         led.digitalWrite LOW
         delay 200
       end
     end
     
     def blink_with_a_twist
       20.times do |i|
         led.blink i * 10
       end
     end     
     
end