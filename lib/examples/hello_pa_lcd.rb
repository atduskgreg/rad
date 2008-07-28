class HelloPaLcd < ArduinoSketch


# demonstrate 4 x 20 pa_lcd toggle between normal and Bignum mode
# with @toggle external variable thrown in for fun

# change your pins to suit your setup
  
  @toggle = false
  
  input_pin 6,  :as => :button_one, :device => :button
  input_pin 7,  :as => :button_two, :device => :button
  input_pin 8, :as => :button_three, :device => :button
  
  output_pin 5, :as => :my_lcd, :device => :pa_lcd, :rate => 19200, :clear_screen => :true

  def setup
    delay 3000
    my_lcd.setxy 0,0
    my_lcd.print "Press button"
    my_lcd.setxy 0,1
    my_lcd.print "One, two or three...."
  end
  
  def loop  
    say_hello     if button_one.read_input 
    say_more      if button_two.read_input 
    say_it_large  if button_three.read_input 
  end
  
  def say_hello
    @toggle = true
    my_lcd.clearscr "Any sufficiently    advanced technology"
    my_lcd.setxy 0,2
    my_lcd.setxy 0,3, "toggle state: "
    my_lcd.print @toggle
  end
  
  def say_more # passing print strings to home and setxy (also works on clearscr)
    @toggle = false
    my_lcd.clearscr "is indistinguishablefrom magic"
    my_lcd.setxy 0,3, "toggle state: "
    my_lcd.print @toggle
  end
  
  
  def say_it_large

    my_lcd.intoBignum
    my_lcd.clearscr            # line 0, col 0
    1.upto(32) do |i|
      my_lcd.setxy 0,1
      my_lcd.print i * i
      delay 200
    end
    my_lcd.outofBignum
  end
 
end