class HelloLcdCharset < ArduinoSketch

  # -------------------------------------------------------------------------
  #    Program to Display the entire lower half (under 0x80) character set
  #
  #    The class variable @a defined as byte is needed to make RubyToC put
  #    the value to be 'printed' as a byte and thus give us the character
  #    that value represents.
  #
  #      Brian Riley - Underhill Center, VT, USA  July 2008
  #                     <brianbr@wulfden.org>
  #
  # ----------------------------------------------------------------------
  
   
      @a  = byte
      
      output_pin 14, :as => :myLCD, :device => :pa_lcd, :rate => 19200
      output_pin 13, :as => :led

  def loop
    
    myLCD.clearscr  "Alphabet Chars?n"
    0x41.upto(0x5a) do |i|    # A to Z
      @a = i                  # forces 'byte' typing to variable
      myLCD.print @a          # so print rouien prints character represented 
      delay 50                # by the index value
    end
    0x61.upto(0x7a) do |i|    # a to z
      @a = i
      myLCD.print @a
      delay 50
    end
    
    delay 3000
    myLCD.clearscr  "Numeric Chars?n"
    0x30.upto(0x39) do |i|    # 0 to 9
      @a = i
      myLCD.print @a
      delay 50
    end
    
    delay 3000

    myLCD.clearscr  "Other Chars?n"
    0x21.upto(0x2f) do |i|    # punctuation et al
      @a = i
      myLCD.print @a
      delay 50
    end
    0x3a.upto(0x40) do |i|
      @a = i
      myLCD.print @a
      delay 50
    end
    0x5b.upto(0x60) do |i|
      @a = i
      myLCD.print @a
      delay 50
    end
    0x7b.upto(0x7f) do |i|
      @a = i
      myLCD.print @a
      delay 50
    end
    
    delay 3000
      


  end
  
  
  
end