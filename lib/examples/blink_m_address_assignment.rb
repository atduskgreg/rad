class BlinkMAddressAssignment < ArduinoSketch

  # want to use more than one blink m?
  # since each blink m arrives with the same address, 
  # we can't address each one individually
  # 
  # so the first thing we need to do is give each one a new address
  # that's the purpose of this sketch
  # 
  # install one blinkm at a time
  # a pa_lcd screen makes this easier
  # the screen will start at address ten and increment approximately every
  # four seconds.  Pressing during the first four seconds sets the blnikm 
  # address to 10, during the next four seconds to 11 and so on
  # difficult without a screen.
  # if you need to, program an led to help with the timing
   

  @blink_m_start_address = 10
  @flag = false
  @addr1 = "10, byte"
  @addr2 = "11, byte"
  @addr3 = "12, byte"
  
  output_pin 19, :as => :wire, :device => :i2c, :enable => :true # reminder, true issues wire.begin
  input_pin 7,  :as => :button_one, :device => :button
  input_pin 8,  :as => :button_two, :device => :button
  input_pin 9,  :as => :button_three, :device => :button
  
  output_pin 5, :as => :my_lcd, :device => :pa_lcd, :rate => 19200, :clear_screen => :true
  
  def setup
    delay 1000
    my_lcd.setxy 0,0, "bienvenue"
        delay 5000
  end
  
  def loop  
 
    if @flag == false
      staging
    else
      test_address 
    end
    delay 100
  end
  
  def staging
    my_lcd.setxy 0,0, "press button one to"
    my_lcd.setxy 0,1, "set address to "
    my_lcd.print @blink_m_start_address
    my_lcd.setxy 0,2, "or two for status"
    delay 60
    my_lcd.setxy 0,3, "                "
    my_lcd.setxy 0,3
    800.times do |i|
      return 0 if @flag == true
      my_lcd.print "." if i % 50 == 0 
      delay 5
      if button_one.read_input
        assign_address 
      elsif button_two.read_input
        test_address
      end 
    end
    @blink_m_start_address += 1 
  end
  
  def assign_address
    @flag = true
    my_lcd.clearscr "setting to "
    my_lcd.print @blink_m_start_address
    delay 100
    BlinkM_setAddress @blink_m_start_address
    my_lcd.clearscr "done"
    control_it
  end
  
  def control_it
    delay 500
    my_lcd.clearscr "stopping script"
    BlinkM_stopScript @blink_m_start_address
    my_lcd.clearscr "stopping script.."
    delay 500
    my_lcd.clearscr "fade to purple.."
    BlinkM_fadeToRGB(@blink_m_start_address, 0xff,0x00,0xff)
    my_lcd.clearscr "fade to purple"
    delay 500
    BlinkM_fadeToRGB(@blink_m_start_address, 0xff,0x00,0xff)
  end
  
  
  def test_address
    my_lcd.clearscr
    my_lcd.setxy 0,0, "testing address"
    my_lcd.setxy 0,1
    my_lcd.print blink_m_check_address_message @blink_m_start_address
    delay 5000
  end

  
    

end