class ExternalVariableFu < ArduinoSketch
  
  @one = int
  @two = long
  @three = unsigned
  @four = short
  @five = byte
  @six = 1
  @seven = 1.2
  @eight = "0x00"
  @nine = "arduino"
  @ten = true
  @eleven = false
  @twelve = "1, long"
  @thirteen = "1, unsigned"
  @fourteen = "1, byte"
  @fifteen = HIGH
  @sixteen = LOW
  @seventeen = ON 
  @eighteen = OFF

  def loop
   delay @six
  end
     
end