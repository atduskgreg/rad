class ServoCalibrateContinuous < ArduinoSketch

  # ----------------------------------------------------------------------
  #    Program to calibrate a 'continuous' or 'modified' hobby servo
  #
  #    Basically uses teh servo 'spped' command to send a speed
  #    of zero (0) to the servo continuously. You then use a small
  #    screwdriver to adjust the potentiometer on the sero until there
  #    is no motion whatsoever.
  #
  #    The program strats off by commanding max speed clockwise and then
  #    counter clockwise. First the LED blinks rapidly for 2 seconds as
  #    a warning that motion is coming. Then the LED is turned on solid
  #    Then 2 seconds max rev clockwise, then two seconds max rev counter-
  #    clockwise. Then the LED is turned off and this followed by twenty
  #    second of the servo commanded to zero (0) speed. During this time
  #    you may adjust the servo for no motion. If you stilll have more
  #    adjustmenst to make you will be warned by the flashing LED to
  #    back off while it moves back and forth. This full speed motion
  #    is to let you knwo you have it right,
  #
  #    The 20 second timer uses the Arduino millis() counter which
  #    rolls over after a couple million milliseconds. I made no attempt
  #    to allow for ths. If your servo isn't calibrated after a couple
  #    million milliseconds and the prgram jams up then (a) hit the reset
  #    button, or (b) give up!
  #
  #      Brian Riley - Underhill Center, VT, USA  July 2008
  #                     <brianbr@wulfden.org>
  #
  # ----------------------------------------------------------------------
  
   
  @test_state = "2, int"
  @cycle_time = "0, long"
  
  
      # This sets up to do four units at once
      # You can comment the extra lines out or leave them in, if there's nothing
      # connected, no harm, no foul!
      output_pin 12, :as => :servo4, :device => :servo, :minp => 400, :maxp => 2600
      output_pin 11, :as => :servo3, :device => :servo, :minp => 400, :maxp => 2600
      output_pin 10, :as => :servo2, :device => :servo, :minp => 400, :maxp => 2600
      output_pin  9, :as => :servo1, :device => :servo, :minp => 400, :maxp => 2600
 
      output_pin 13, :as => :led



  def loop
    if @test_state == 2

      40.times { blink led, 50 }    # 40 x 50 ms is a 2 second blinking light
                                    #  ** Warning! **  "... danger Will Robinson!"
      toggle led                    # turn it on keep it on -- keep hands away
      servo1.speed -90
      servo2.speed -90
      servo3.speed -90
      servo4.speed -90
      delay_servo 2000              # two full seconds max clockwise
      servo1.speed 90
      servo2.speed 90
      servo3.speed 90
      servo4.speed 90
      delay_servo 2000              # two full seconds max counter clockwise
      
      @test_state = 1               # setup for zero speed test/adjust
      @cycle_time = millis + 20000
      servo1.speed 0
      servo2.speed 0
      servo3.speed 0
      servo4.speed 0
      toggle led                    # lights off, OK  you have 20 seconds to adjust
    end

    if @cycle_time - millis <= 0
        @test_state = 2
    else
        servo_refresh
    end
        
  end
  
  
  def delay_servo(t)
    t.times do
      delay 1
      servo_refresh
    end
  end
  
end