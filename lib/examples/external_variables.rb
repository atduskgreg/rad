class ExternalVariables < ArduinoSketch

  define "KOOL 10"
  define "TRUE 1"
  define "COMMENT true"
  define "DS1307_CTRL 7"
  define "DS1308_CTRL 7"
  array "char buffer[32];"
  array "char bufferz[32];"


  @foo = 1
  @bidda = "badda"
  @boom = "1, int"
  @rad = "1.00"
  
  def loop
	  delay 1
	  @foo = 2
    @foo = KOOL
  end
  
  def setup # special one time only method
    delay 100
    delay 100
    @foo = 10
    5.times { delay 200 }

  end
    

end