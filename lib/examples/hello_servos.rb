class HelloServos < ArduinoSketch
  
  output_pin 2, :as => :servo_1, :max => 2400, :min => 800
  output_pin 3, :as => :servo_2, :max => 2400, :min => 800
  output_pin 4, :as => :servo_3, :max => 2400, :min => 800


     # time to go old school
     def loop
       song_sheet_two
     end
     
     def song_sheet_two
       e
       d
       e
       d 
       c
       d
       d
       c
       b
       c
       b
       a
       e
       a
       e
       a
       e
       a
       b
       c
       b
       c
       d
       d
       c
       d
       e
       d
       e
     end
     
     def a
       pulse_servo servo_1, 1450
       delay 100
       home servo_1
       delay 20
     end

     def b
       pulse_servo servo_1, 1350
       delay 100
       home servo_1
       delay 20
     end

     def c
       pulse_servo servo_2, 1450
       delay 100
       home servo_2
       delay 20
     end

     def d
       pulse_servo servo_2, 1350
       delay 100
       home servo_2
       delay 20
     end

     def e
       pulse_servo servo_3, 1500
       delay 100
       home servo_3
       delay 20
     end


     # center servos

     def home(s)
       pulse_servo s, 1400
       f = s + 0
     end

end