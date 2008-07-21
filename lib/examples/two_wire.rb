class TwoWire < ArduinoSketch

  # just a demo that two_wire loads

  output_pin 19, :as => :wire, :device => :i2c, :enable => :true
  
  def loop

	  x = 4    
  
  end
    

end