class ConfigurePaLcdBoot < ArduinoSketch
  
## important!  
## most pa_lcd rates are set to 9200, but there are some newer at 19200
## if you have a 19200, uncomment the end of line 38
  
## purpose:  
## change cursor to none
## and add custom boot screen
## 
## jd's preferred setup for pa_lcd
## 
## assumes 4 x 20 pa_lcd
## 
## no blinking cursor press button 1
## configure custom start up screen - press button 2
## configure lcd to use custom startup screen - press button 3
## 
## press buttons one, two and three 
## or season to taste
##
## refernce
## K107 LCD Controller Board Manual
## page 11 for cursors
## page 13 for custom boot
## http://wulfden.org/downloads/manuals/K107manual.pdf
##
##

## set pins to your setup


   input_pin 8,  :as => :button_one, :device => :button
   input_pin 9,  :as => :button_two, :device => :button
   input_pin 10, :as => :button_three, :device => :button
   
   ## note, most of these controllers are set to 9200
   output_pin 14, :as => :my_lcd, :device => :pa_lcd #, :rate => 19200

   
   def loop
     set_cursor     if button_one.read_input 
     set_custom_screen      if button_two.read_input 
     change_boot_to_custom  if button_three.read_input 
   end
   
   ## assumes 4 x 20 screen
   ## maintain 20 characters after ?Cn
   ## wny delays?  the controller needs them to give it 
   ## enough time to write 20 bytes to internl EEPROM
   def set_custom_screen
     my_lcd.clearscr
     my_lcd.print "?C0   RAD & Arduino    "
     delay 400
     my_lcd.print "?C1    Development     "
     delay 400
     my_lcd.print "?C2                    "
     delay 400
     my_lcd.print "?C3      v0.3.0        "
   end
   
   
   ## ?c0 for no cursor
   ## ?c2 for non blinking cursor
   ## ?c3 for blinking cursor
   def set_cursor
     my_lcd.clearscr
     my_lcd.print "Changing to "
     my_lcd.setxy 0,1
     my_lcd.print "no cursor. "
     my_lcd.setxy 0,3
     my_lcd.print "Reboot to view... "
     
     my_lcd.print("?c0")
   end
   
   ## "?S0 for blank screen 
   ## ?S1 for configuration settings 
   ## ?S2 for custom text screen
   def change_boot_to_custom
     my_lcd.clearscr
     my_lcd.print "Changing to "
     my_lcd.setxy 0,1
     my_lcd.print "custom boot screen. "
     my_lcd.setxy 0,3
     my_lcd.print "Reboot to view... "
     my_lcd.print("?S2")
   end

  
end