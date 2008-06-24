ON = true
OFF = !ON
HIGH = ON
LOW = !HIGH

class ArduinoSketch
  attr_accessor :pins  
   
  def initialize
    @pins = self.class.instance_variable_get("@pins")
  end
  
  def self.output_pin(num, opts)
    module_eval "@pins ||= []"
    module_eval do 
      @pins <<  Pin.new( num, :type => :output )
    end

    if opts[:as]
       module_eval <<-CODE
         def #{opts[:as]}
           pins.select{|p| p.num == #{num}}.first
         end
       CODE
     end
  end

  def loop    
  end
  
  def digitalWrite( pin, value )
    to_change = pins.select{|p| p.num == pin.num}.first
    to_change.value = value
  end

  def delay( millis )
  end
  
  # def serial_read
  # end

  # def serial_available
  # end

  # def blink
  # end
end

class Pin
  attr_accessor :num, :type, :value

  def initialize num, opts
    @num = num
    @type = opts[:type]
    @value = opts[:value] || false
  end
end
