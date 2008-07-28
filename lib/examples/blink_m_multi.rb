class BlinkMMulti < ArduinoSketch

  # demonstrate control of individual blinkms
  # this assumes the leds have been assigned addresses 10, 11, 12
  # which can be done with blink m address assignment

  # two ways to address the blinkms, array and individual variables
  @blink_addresses = [10,11,12]
  @addr_all = "0, byte" 
  @addr1 = "10, byte"
  @addr2 = "11, byte"
  @addr3 = "12, byte"
  
  output_pin 19, :as => :wire, :device => :i2c, :enable => :true # reminder, true issues wire.begin
  input_pin 7,  :as => :button_one, :device => :button
  input_pin 8,  :as => :button_two, :device => :button
  input_pin 9,  :as => :button_three, :device => :button
  input_pin 10,  :as => :button_four, :device => :button
  
  # display the action on a 4x20 pa_lcd, yours may be 9200 instead of 19,200

  output_pin 5, :as => :my_lcd, :device => :pa_lcd, :rate => 19200, :clear_screen => :true
  
  
  def loop  
    stop_and_fade(@addr1) if button_one.read_input
    stop_and_fade(@addr2) if button_two.read_input 
    stop_and_fade(@addr3) if button_three.read_input 
    dance if button_four.read_input 
  end
  
  def stop_and_fade(addr)
    f = 1 + addr # hack to coerce addr to int
    my_lcd.clearscr
    my_lcd.setxy 0,0, "blinkm # "
    my_lcd.print addr
    delay 700
    BlinkM_stopScript addr
    my_lcd.setxy 0,1, "stopping script.."
    delay 700
    my_lcd.setxy 0,2, "fade to purple.."
    BlinkM_fadeToRGB(addr, 0xff,0x00,0xff)
  end
  
  def dance
    BlinkM_setFadeSpeed(@addr_all, 20) # 1-255, with 1 producing the slowest fade
    my_lcd.clearscr
    my_lcd.setxy 0,0, "Do the shimmy.."
    my_lcd.setxy 0,1
    @blink_addresses.each do |a|
      BlinkM_fadeToRGB(a, 1,166,138)
      delay 100
    end
    @blink_addresses.each do |a|
      BlinkM_fadeToRGB(a, 35,0,112)
      delay 100
    end
  end
    

end