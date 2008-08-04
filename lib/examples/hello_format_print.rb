class HelloFormatPrint < ArduinoSketch

  # ----------------------------------------------------------------------
  #    Demonstrattion of Crude Adaptaion of C Function sprintf()
  #    to do formatted printing. For now there are some absolutes:
  #    The write_line method atkes as arguemnst the formatting string
  #    and the appropriate arguments. It format them to an internal
  #    buffer called _str which is by default 64 bytes but can be 
  #    adjusted (see below) and that buffer is pointed to, currently
  #    (08/03/2008) a string pointer array with one element "xx[0]" 
  #    must be declared with that exact name. So to set up to use 
  #    formatted printing, you must declare the string pointer
  #           array "char *xx[1]"
  #    then invoke formatted printing
  #           formatted_print :buffer_size => 80
  #    now, to actual do it you use write_line
  #           write_line "Pies $%02d.%02d", pie_cents/100, pie_cents%100
  #    then print the string pointed at by xx[0]
  #           my_lcd.setxy 3, 2, xx[0] 
  #
  #      Brian Riley - Underhill Center, VT, USA  Aug 2008
  #                     <brianbr@wulfden.org>
  #
  # ----------------------------------------------------------------------

# demonstrate 4 x 20 pa_lcd toggle between normal and Bignum mode
# with @toggle external variable thrown in for fun

# change your pins to suit your setup
  
  @toggle = "0, int"
  @pie_cents = "403, int"
  array "char *xx[1]"
  
  input_pin 8,  :as => :button_one, :device => :button
  input_pin 9,  :as => :button_two, :device => :button
  input_pin 10, :as => :button_three, :device => :button
  
  output_pin 14, :as => :my_lcd, :device => :pa_lcd, :rate => 19200, :clear_screen => :true

  formatted_print :buffer_size => 80      # defaults to 64 bytes
  
  def setup
    my_lcd.clearscr " --<Press Button>--?nOne, Two, or Three"
  end
  
  def loop 
    if millis % 500 == 0
      write_line "millis()= %ld", millis
      my_lcd.setxy 1, 2, xx[0]
    end 
    say_hello     if button_one.read_input 
    say_more      if button_two.read_input 
    say_it_large  if button_three.read_input 
  end
  
  def say_hello
    @toggle = true
    write_line "This sketch has?nbeen running for?n %ld mins and %d secs", millis/60000, (millis/1000)%60
    my_lcd.clearscr xx[0]
    delay 3000
    my_lcd.clearscr " --<Press Button>--?nOne, Two, or Three"
  end
  
  def say_more # passing print strings to home and setxy (also works on clearscr)
    @toggle = false
    my_lcd.clearscr "is indistinguishablefrom magic"
    write_line "Pies $%2d.%02d", @pie_cents/100, @pie_cents%100
    my_lcd.setxy 4, 2, xx[0]
    my_lcd.setxy 0,3, "toggle state: "
    my_lcd.print @toggle
    delay 3000
    my_lcd.clearscr " --<Press Button>--?nOne, Two, or Three"
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
    delay 3000
    my_lcd.clearscr " --<Press Button>--?nOne, Two, or Three"      
  end
  

 
end