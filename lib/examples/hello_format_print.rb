class HelloFormatPrint < ArduinoSketch

  # ----------------------------------------------------------------------
  #    Demonstrattion of Crude Adaptaion of C Function sprintf()
  #    to do formatted printing. For now there are some absolutes:
  #    The write_line method atkes as arguemnst the formatting string
  #    and the appropriate arguments. It format them to an internal
  #    buffer sepcified and created when you invoke formatted printing
  #       formatted_print :as => :line_buf, :buffer_size => 80
  #    now, to actual do it you use write_line
  #       write_line "Pies $%02d.%02d", pie_cents/100, pie_cents%100
  #    then print the string pointed at by string_line
  #       my_lcd.setxy 3, 2, line_buf 
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
  @pie_price = "7.08"

  
  input_pin 8,  :as => :button_one, :device => :button
  input_pin 9,  :as => :button_two, :device => :button
  input_pin 10, :as => :button_three, :device => :button
  
  formatted_print :as => :string_line, :buffer_size => 65   # generally this statement should precede any serial_begin or
                                                            # LCD display directive

  output_pin 14, :as => :my_lcd, :device => :pa_lcd, :rate => 19200, :clear_screen => :true

  
  def setup
    my_lcd.clearscr " --<Press Button>--?nOne, Two, or Three"
  end
  
  def loop 
    if millis % 500 == 0
      write_line "millis()= %ld", millis
      my_lcd.setxy 1, 2, string_line
    end 
    say_hello     if button_one.read_input 
    say_more      if button_two.read_input 
    say_it_large  if button_three.read_input 
  end
  
  def say_hello
    @toggle = true
    my_lcd.clearscr "This sketch has?nbeen running for?n "
    write_line "%ld mins and %d secs?n", millis/60000, (millis/1000)%60
    my_lcd.print string_line
    delay 3000
    my_lcd.clearscr " --<Press Button>--?nOne, Two, or Three"
  end
  
  def say_more # passing print strings to home and setxy (also works on clearscr)
    @toggle = false
    my_lcd.clearscr "Food Store Prices"
    write_line "Pies $%2d.%02d", @pie_cents/100, @pie_cents%100
#    write_line "Pies $%6.2f", @pie_price # float doessn't seem to work .....
    my_lcd.setxy 2, 1, string_line
#    write_line "toggle state is [%s]", @toggle ? "ON" : "OFF"  # RubyToC screws this construct up and RAD mistajekl put 1 ad 0
                                                                # in place of "ON" and "OFF"
    write_line "toggle state is [%d]", @toggle
    my_lcd.setxy 2, 3, string_line
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