# ArduinoSketch is the main access point for working with RAD. Sub-classes of ArduinoSketch have access to a wide array of convenient class methods (documented below) for doing the most common kinds of setup needed when programming the Arduino such as configuring input and output pins and establishing serial connections. Here is the canonical 'hello world' example of blinking a single LED in RAD:
#
#   class HelloWorld < ArduinoSketch
#     output_pin 13, :as => :led
#     
#     def loop
#       blink 13, 500
#     end
#   end
#
# As you can see from this example, your ArduinoSketch sub-class can be dividied into two-parts: class methods for doing configuration and a loop method which will be run repeatedly at the Arduino's clock rate. Documentation for the various available class methods is below. The ArduinoSketch base class is designed to work with a series of rake tasks to automatically translate your loop method into C++ for compilation by the Arduino toolchain (see link://files/lib/rad/tasks/build_and_make_rake.html for details). See http://rad.rubyforge.org/examples for lots more examples of usage.
#
# ==Arduino built-in methods
# Thanks to this translation process you can take advantage of the complete Arduino software API (full docs here: http://www.arduino.cc/en/Reference/HomePage). What follows is the core of a RAD-Arduino dictionary for translating between RAD methods and the Arduino functionality they invoke, N.B. many Arduino methods have been left out (including the libraries for Time, Math, and Random Numbers, as the translation between them and their RAD counterparts should be relatively straightforward after perusing the examples here). For further details on each method, visit their Arduino documenation.
#
# <b>Digital I/O</b>
#
# digital_write(pin, value)
#
#   Arduino method: digitalWrite(pin, value) 
#
#   Description: "Ouputs either HIGH or LOW at a specified pin."
#   
#   Documentation: http://www.arduino.cc/en/Reference/DigitalWrite
#   
# digital_read(pin)
#
#   Arduino method: digitalRead(pin) 
#
#   Description: "Reads the value from a specified pin, it will be either HIGH or LOW."
#
#   Documentation: http://www.arduino.cc/en/Reference/DigitalRead
# 
# <b>Analog I/O</b>
#
# analog_read(pin) 
#
#   Arduino method: analogRead(pin)
#
#   Description: "Reads the value from the specified analog pin. The Arduino board contains a 6 channel 
#     (8 channels on the Mini), 10-bit analog to digital converter. This means that it will map input 
#     voltages between 0 and 5 volts into integer values between 0 and 1023. This yields a resolution
#     between readings of: 5 volts / 1024 units or, .0049 volts (4.9 mV) per unit. It takes about 100
#     us (0.0001 s) to read an analog input, so the maximum reading rate is about 10,000 times a second."
#
#   Documentation: http://www.arduino.cc/en/Reference/AnalogRead
#
# analog_write(pin, value)
#
#   Arduino method: analogWrite(pin, value)
#
#   Description: "Writes an analog value (PWM wave) to a pin. On newer Arduino boards (including the Mini
#     and BT) with the ATmega168 chip, this function works on pins 3, 5, 6, 9, 10, and 11. Older USB and 
#     serial Arduino boards with an ATmega8 only support analogWrite() on pins 9, 10, and 11. Can be used 
#     to light a LED at varying brightnesses or drive a motor at various speeds. After a call to analogWrite,
#     the pin will generate a steady wave until the next call to analogWrite (or a call to digitalRead or 
#     digitalWrite on the same pin)."
#
#   Documentation: http://www.arduino.cc/en/Reference/AnalogWrite
#
# <b>Serial Communication</b>
#
# serial_available()
#
#   Arduino method: Serial.available()
#   
#   Description: "Get the number of bytes (characters) available for reading over the serial port. 
#     Returns the number of bytes available to read in the serial buffer, or 0 if none are 
#     available. If any data has come in, Serial.available() will be greater than 0. The serial buffer
#     can hold up to 128 bytes."
#
#   Documentation: http://www.arduino.cc/en/Serial/Available
#
# serial_read()
#
#   Arduino method: Serial.read()
#
#   Description: "Reads incoming serial data and returns the first byte of incoming serial data 
#     available (or -1 if no data is available)"
#
#   Documentation: http://www.arduino.cc/en/Serial/Read
#
# serial_print(data)
#
#   Arduino method: Serial.print(data)
#
#   Description: "Prints data to the serial port."
#
#   Documentation: http://www.arduino.cc/en/Serial/Print
#
# serial_println(data)
#
#   Arduino method: Serial.println(data)
#
#   Description: "Prints a data to the serial port, followed by a carriage return character 
#     (ASCII 13, or '\r') and a newline character (ASCII 10, or '\n'). This command takes the 
#     same forms as Serial.print():"
#
#   Documentation: http://www.arduino.cc/en/Serial/Println
#
# serial_flush()
#
#   Arduino method: Serial.flush()
#
#   Description: "Flushes the buffer of incoming serial data. That is, any call to Serial.read() 
#     or Serial.available() will return only data received after the most recent call 
#     to Serial.flush()."
#
#   Documentation: http://www.arduino.cc/en/Serial/Flush
#
#   June 25, 2008
#   Added a new external variable method which keeps track 
#   external_vars :sensor_position => "int, 0", :feedback => "int", :pulseTime => "unsigned long, 0"
# 
#   added ability to write additional methods besides loop in the sketch 
#   since there is quite a bit of work to do with the c translation, it is easy to write a method that
#   won't compile or even translate into c, but for basics, it works.  
#   Note: stay basic and mindful that c is picky about variables and must make a decision
#   which will not always be what you want
#   also: for now, don't leave empty methods (something like foo = 1 cures this)
# 
#   Example:
#
#   class HelloMethods < ArduinoSketch
#     output_pin 13, :as => :led
#     
#     def loop
#       blink_it
#     end

#     def blink_it
#       blink 13, 500
#     end
#
#   end
#
#   
#   added pin methods for servos and latching which generate an array of structs to contain setup and status
#   input_pin 12, :as => :back_off_button, :latch => :off
#   input_pin 8, :as => :red_button, :latch => :off # adjust is optional with default set to 200
#
#   added add_to_setup method that takes a string of c code and adds it to setup
#   colons are options and will be added if not present  
#   no translation from ruby for now
#
#   example:
#   
#   add_to_setup "call_my_new_method();", "call_another();"  
#
#   added some checking to c translation that (hopefully) makes it a bit more predictable
#   most notably, we keep track of all external variables and let the translator know they exist 
#   
#   

class ArduinoSketch
  
  include ExternalVariableProcessing
  
  # find another way to do this
  @@frequency_inc = FALSE
  @@twowire_inc	= FALSE
  
  def initialize #:nodoc:
    @servo_settings = [] # need modular way to add this
    @debounce_settings = [] # need modular way to add this
    @hysteresis_settings = []
    @spectra_settings = []
    @servo_pins = [] 
    @debounce_pins = []
    @hysteresis_pins = []
    @spectra_pins = []
    $external_array_vars = [] 
    $external_vars =[]
    $external_var_identifiers = []
    $sketch_methods = []
    $load_libraries ||= []
    $defines  ||= []
    $define_types = {}
    $array_types = {}
    $array_index_helpers = ('a'..'zz').to_a

    @declarations = []
    @pin_modes = {:output => [], :input => []}
    @pullups = []
    @other_setup = [] # specifically, Serial.begin
    @assembler_declarations = []
    @accessors = []
    @signatures = ["void blink();", "int main();", "void track_total_loop_time(void);", "unsigned long find_total_loop_time(void);"]

    helper_methods = []
    helper_methods << "void blink(int pin, int ms) {"
    helper_methods << "\tdigitalWrite( pin, HIGH );"
    helper_methods << "\tdelay( ms );"
    helper_methods << "\tdigitalWrite( pin, LOW );"
    helper_methods << "\tdelay( ms );"
    helper_methods << "}"
    helper_methods << "void track_total_loop_time(void)"
    helper_methods << "{"
    helper_methods << "\ttotal_loop_time = millis() - start_loop_time;"
    helper_methods << "\tstart_loop_time = millis();"
    helper_methods << "}"
    helper_methods << "unsigned long find_total_loop_time(void)"
    helper_methods << "{"
    helper_methods << "\nreturn total_loop_time;"
    helper_methods << "}"
    @helper_methods = helper_methods.join( "\n" )
    
    @declarations << "unsigned long start_loop_time = 0;"
    @declarations << "unsigned long total_loop_time = 0;"
  end
  
  # Setup variables outside of the loop. Does some magic based on type of arguments. Subject to renaming. Use with caution.
  def vars(opts={})
    opts.each do |k,v|
      if v.class == Symbol
       @declarations << "#{v} _#{k};"
       @accessors << <<-CODE
        #{v} #{k}(){
        \treturn _#{k};
        }
       CODE
      else
        type = case v
        when Integer
          "int"
        when String
          "char*"
        when TrueClass
          "bool"
        when FalseClass
          "bool"
        end

        @declarations << "#{type} _#{k} = #{v};"
        @accessors << <<-CODE
          #{type} #{k}(){
          \treturn _#{k};
          }
        CODE
      end
    end
  end
  

    # a different way to setup external variables outside the loop
    # 
    # in addition to being added to the c file as external variables:
    # we fake ruby2c out by adding them to internal vars for ruby2c processing
    # but we don't include then in the cpp loop
    # then, we use the indentiers to remove any parens that ruby2c adds 
    # this resolves ruby2c's habit of converting variables to methods
    # need tests and ability to add custom char length
    def external_vars(opts={})
      if opts
          opts.each do |k,v|
            if v.include? ","
              if v.split(",")[0] == "char"
                ## default is 40 characters
                if v.split(",")[2]
                    $external_vars << "#{v.split(",")[0]}* #{k}[#{v.split(",")[2].lstrip}];"
                else
                    $external_vars << "#{v.split(",")[0]} #{k}[40] = \"#{v.split(",")[1].lstrip}\";"
                end
              else
              $external_vars << "#{v.split(",")[0]} #{k} =#{v.split(",")[1]};"
              end
            else
              if v.split(",")[0] == "char"
                $external_vars << "#{v.split(",")[0]} #{k}[40];"
              else

                $external_vars << "#{v.split(",")[0]} #{k};"
              end
            end
            # check chars work here
            $external_var_identifiers << k
         end
      end
    end

    # phasing this out
    def add_to_setup(*args)
      if args
         args.each do |arg|
           $add_to_setup << arg
         end
       end
    end

    # phasing this out
    def external_arrays(*args)
      if args
        args.each do |arg|
          $external_array_vars << arg
        end
      end

    end
    
    # array "char buffer[32]"
    # result: char buffer[32];
    # array "char buffer[32]"
    # result: char buffer[32];
    # todo 
    # need to feed array external array identifiers to rtc if they are in plugins or libraries, (not so sure about this will do more testing)
    def array(arg)
      if arg
          arg = arg.chomp.rstrip.lstrip
          name = arg.scan(/\s*(\w*)\[\d*\]?/).first.first
          
    # following 10 lines seem to be unnecessary
    # and are left over from early array work
    # but they are still here for a bit
    # determine if there is an array assignement, and how many
    # then eliminate the assignment and update the array size
    #      if /\w*\[\d*\]\s*\=\s*\{(.*)\}/ =~ arg
    #        assignment = arg.scan(/\w*\[\d*\]\s*\=\s*\{(.*)\}/).first.first
    #        array_size = assignment.split(",").length
    #        if /\[(\s*)\]/ =~ arg
    #          arg.gsub!(/(\[\d*\])/, "[#{array_size}]")
    #        end
    #      end
    #      arg = arg.scan(/^((\s*|\w*)*\s*\w*\[\d*\])?/).first.first

          # help rad_processor do a better job with array types
          types = ["int", "long", "char*", "unsigned int", "unsigned long", "byte", "bool", "float" ]
          types.each_with_index do |type, i|
            @type = types[i] if /#{type}/ =~ arg
          end
          raise ArgumentError, "type not currently supported.. got: #{arg}.  Currently supporting #{types.join(", ")}" unless @type

          arg = "#{arg};" unless arg[-1,1] == ";"
          $array_types[name] = @type
          @type = nil
          $external_var_identifiers << name unless $external_var_identifiers.include?(name)
          # add array_name declaration
          $external_array_vars << arg unless $external_array_vars.include?(arg)
      end
    end
    
    # define "DS1307_SEC 0"
    # result: #define DS1307_SEC 0
    # note we send the constant identifiers and type to our rad_type_checker
    # however, it only knows about long, float, str....
    # so we don't send ints ...yet..
    # need more testing
    def define(arg)
      if arg
          arg = arg.chomp.rstrip.lstrip
          name = arg.split(" ").first
          value = arg.gsub!("#{name} ","")
          # negative
          if value =~ /^-(\d|x)*$/ 
             type = "long"
           # negative float
           elsif value =~ /^-(\d|\.|x)*$/ 
             type = "float" 
           elsif value =~ /[a-zA-Z]/
             type = "str"
             value = "\"#{value}\""
           elsif value !~ /(\.|x)/
             type = "long"
           elsif value =~ /(\d*\.\d*)/ # and no 
             type = "float"
           elsif value =~ /0x\d\d/
             type = "byte"
           else 
             raise ArgumentError, "opps, could not determine the define type, got #{value}"
           end
          $define_types[name] = type
          arg = "#define #{name} #{value}"
          $defines << arg
          dummy_for_testing = arg, type
      end
    end
  
  # Configure a single pin for output and setup a method to refer to that pin, i.e.:
  #
  #   output_pin 7, :as => :led
  #
  # would configure pin 7 as an output and let you refer to it from the then on by calling
  # the `led` method in your loop like so:
  # 
  #   def loop
  #     digital_write led, ON
  #   end
  #
  def output_pin(num, opts={})
    raise ArgumentError, "can only define pin from Fixnum, got #{num.class}" unless num.is_a?(Fixnum)
    @pin_modes[:output] << num
    if opts[:as]
      if opts[:device]
        case opts[:device]
        when :servo
          new_servo_setup(num, opts)
          return # don't use declarations, accessor, signatures below
        when :orig_servo
          orig_servo_setup(num, opts)
        when :lcd || :LCD
          lcd_setup(num, opts)
          return 
        when :pa_lcd || :pa_LCD
          pa_lcd_setup(num, opts)
          return 
        when :sf_lcd || :sf_LCD
          sf_lcd_setup(num, opts)
          return         
        when :freq_out || :freq_gen || :frequency_generator
          frequency_timer(num, opts)
          return
        when :i2c
          two_wire(num, opts) unless @@twowire_inc
          return #
        when :i2c_eeprom
          two_wire(num, opts) unless @@twowire_inc
          return #
        when :i2c_ds1307
          two_wire(num, opts) unless @@twowire_inc
          ds1307(num, opts) 
          return #
        when :i2c_blinkm
          two_wire(num, opts) unless @@twowire_inc
          blinkm
          return #
        when :onewire
          one_wire(num, opts)
          return #
        else
          raise ArgumentError, "today's device choices are: :servo, :original_servo_setup, :pa_lcd, :sf_lcd, :freq_out,:i2c, :i2c_eeprom, :i2c_ds1307, and :i2c_blinkm  got #{opts[:device]}"
        end
      end
    
# remove the next 14 lines as soon as documentation on new :device => :servo option is out
      
      if opts[:min] && opts[:max] 
        ArduinoPlugin.add_servo_struct
        @servo_pins << num
        refresh = opts[:refresh] ? opts[:refresh] : 200
        @servo_settings <<  "serv[#{num}].pin = #{num}, serv[#{num}].pulseWidth = 0, serv[#{num}].lastPulse = 0, serv[#{num}].startPulse = 0, serv[#{num}].refreshTime = #{refresh}, serv[#{num}].min = #{opts[:min]}, serv[#{num}].max = #{opts[:max]}  "
        unless opts[:device]
          puts "#{"*"*80} \n   using :max and :min to instantiate a servo is deprecated\n   use :device => :servo instead\n#{"*"*80}"
        end
      else    
          raise ArgumentError, "two are required for each servo: min & max" if opts[:min] || opts[:max] 
          raise ArgumentError, "refresh is an optional servo parameter, don't forget min & max" if opts[:refresh] 
      end
      
  # add state variables for outputs with :state => :on or :off -- useful for toggling a light with output_toggle -- need to make this more modular
      if opts[:state] 
        # add debounce settings to dbce struct array
        ArduinoPlugin.add_debounce_struct
        @debounce_pins << num
        state = opts[:latch] == :on ? 1 : 0
        prev = opts[:latch] == :on ? 0 : 1
        adjust = opts[:adjust] ? opts[:adjust] : 200
        @debounce_settings <<  "dbce[#{num}].state = #{state}, dbce[#{num}].read = 0, dbce[#{num}].prev = #{prev}, dbce[#{num}].time = 0, dbce[#{num}].adjust = #{adjust}"
      end
      
      @declarations << "int _#{opts[ :as ]} = #{num};"
      
      accessor = []
      accessor << "int #{opts[ :as ]}() {"
      accessor << "\treturn _#{opts[ :as ]};"
      accessor << "}"
      @accessors << accessor.join( "\n" )
      
      @signatures << "int #{opts[ :as ]}();"
    end
  end
  
  # Like ArduinoSketch#output_pin but configure more than one output pin simultaneously. Takes an array of pin numbers. 
  def output_pins(nums)
    ar = Array(nums)
    ar.each {|n| output_pin(n)} 
  end
  
  ### tuck the following five methods into private once they are solid 
  
  def orig_servo_setup(num, opts)
    ArduinoPlugin.add_servo_struct
    @servo_pins << num
    refresh = opts[:refresh] ? opts[:refresh] : 200
    min = opts[:min] ? opts[:min] : 700
    max = opts[:min] ? opts[:max] : 2200
    @servo_settings <<  "serv[#{num}].pin = #{num}, serv[#{num}].pulseWidth = 0, serv[#{num}].lastPulse = 0, serv[#{num}].startPulse = 0, serv[#{num}].refreshTime = #{refresh}, serv[#{num}].min = #{min}, serv[#{num}].max = #{max}  "
  end
  
  # use the servo library
  def new_servo_setup(num, opts)
    if opts[:position]
      raise ArgumentError, "position must be an integer from 0 to 360, got #{opts[:position].class}" unless opts[:position].is_a?(Fixnum)
      raise ArgumentError, "position must be an integer from 0 to 360---, got #{opts[:position]}" if opts[:position] < 0 || opts[:position] > 360
    end
    servo(num, opts)
    # move this to better place ... 
    # should probably go along with servo code into plugin
    @@servo_dh ||= FALSE
    if (@@servo_dh == FALSE)	# on second instance this stuff can't be repeated - BBR
      @@servo_dh = TRUE
      @declarations << "void servo_refresh(void);"
      helper_methods = []
      helper_methods << "void servo_refresh(void)"
      helper_methods << "{"
      helper_methods <<  "\tServo::refresh();"
      helper_methods << "}"
      @helper_methods += "\n#{helper_methods.join("\n")}"
    end
  end
  
  ## this won't work at all... no pins
  # need help
  def lcd_setup(num, opts)
    # move to plugin and load plugin
    # what's the default rate?
    opts[:rate] ||= 9600
    rate = opts[:rate] ? opts[:rate] : 9600
    swser_LCD(num, opts)
  end
  
  # use the pa lcd library
  def pa_lcd_setup(num, opts)
    if opts[:geometry]
      raise ArgumentError, "can only define pin from Fixnum, got #{opts[:geometry]}" unless opts[:geometry].is_a?(Fixnum)
      raise ArgumentError, "pa_lcd geometry must be 216, 220, 224, 240, 416, 420, got #{opts[:geometry]}" unless opts[:geometry].to_s =~ /(216|220|224|240|416|420)/
    end
    # move to plugin and load plugin
    # what's the default?
     opts[:rate] ||= 9600
    rate = opts[:rate] ? opts[:rate] : 9600
    swser_LCDpa(num, opts)
  end
  
  # use the sf (sparkfun) library
  def sf_lcd_setup(num, opts)
    if opts[:geometry]
      raise ArgumentError, "can only define pin from Fixnum, got #{opts[:geometry]}" unless opts[:geometry].is_a?(Fixnum)
      raise ArgumentError, "sf_lcd geometry must be 216, 220, 416, 420, got #{opts[:geometry]}" unless opts[:geometry].to_s =~ /(216|220|416|420)/
    end
    # move to plugin and load plugin
     opts[:rate] ||= 9600
    rate = opts[:rate] ? opts[:rate] : 9600
    swser_LCDsf(num, opts)
  end
  
  # Confiugre a single pin for input and setup a method to refer to that pin, i.e.:
  #
  #   input_pin 3, :as => :button
  #
  # would configure pin 3 as an input and let you refer to it from the then on by calling
  # the `button` method in your loop like so:
  # 
  #   def loop
  #     digital_write led if digital_read button
  #   end
  #
  def input_pin(num, opts={})
    raise ArgumentError, "can only define pin from Fixnum, got #{num.class}" unless num.is_a?(Fixnum)
    @pin_modes[:input] << num
    if opts[:as]
      # transitioning to :device => :button syntax
      if opts[:latch] || opts[:device] == :button
        if opts[:device] == :button
          opts[:latch] ||= :off
        end
        # add debounce settings to dbce struct array
        ArduinoPlugin.add_debounce_struct
        @debounce_pins << num
        state = opts[:latch] == :on ? 1 : 0
        prev = opts[:latch] == :on ? 0 : 1
        adjust = opts[:adjust] ? opts[:adjust] : 200
        @debounce_settings <<  "dbce[#{num}].state = #{state}, dbce[#{num}].read = 0, dbce[#{num}].prev = #{prev}, dbce[#{num}].time = 0, dbce[#{num}].adjust = #{adjust}"
      end
      if opts[:device] == :sensor
        ArduinoPlugin.add_sensor_struct
        count = @hysteresis_pins.length
        @hysteresis_pins << num
        @hysteresis_settings << "hyst[#{count}].pin = #{num}, hyst[#{count}].state = 0"
      end
      if opts[:device] == :spectra
        ArduinoPlugin.add_spectra_struct
        count = @spectra_pins.length
        @spectra_pins << num
        @spectra_settings << "spec[#{count}].pin = #{num}, spec[#{count}].state = 10, spec[#{count}].r1 = 0, spec[#{count}].r2 = 0, spec[#{count}].r3 = 0"
      end
      @declarations << "int _#{opts[ :as ]} = #{num};"

      accessor = []
      accessor << "int #{opts[ :as ]}() {"
      accessor << "\treturn _#{opts[ :as ]};"
      accessor << "}"
      @accessors << accessor.join( "\n" )
      
      @signatures << "int #{opts[ :as ]}();"
    end
    @pullups << num if opts[:as]
  end
  
  # Like ArduinoSketch#input_pin but configure more than one input pin simultaneously. Takes an array of pin numbers. 
  def input_pins(nums)
    ar = Array(nums)
    ar.each {|n| input_pin(n)} 
  end
  
  def add(st) #:nodoc:
    @helper_methods << "\n#{st}\n"
  end
  
  # Configure Arduino for serial communication. Optionally, set the baud rate:
  #
  #   serial_begin :rate => 2400
  #
  # default is 9600. See http://www.arduino.cc/en/Serial/Begin for more details.
  # 
  def serial_begin(opts={})
    rate = opts[:rate] ? opts[:rate] : 9600
    @other_setup << "Serial.begin(#{rate});"
  end
  
  # Treat a pair of digital I/O pins as a serial line. See: http://www.arduino.cc/en/Tutorial/SoftwareSerial
  def software_serial(rx, tx, opts={})
    raise ArgumentError, "can only define rx from Fixnum, got #{rx.class}" unless rx.is_a?(Fixnum)
    raise ArgumentError, "can only define tx from Fixnum, got #{tx.class}" unless tx.is_a?(Fixnum)
    
    output_pin(tx)
    
    rate = opts[:rate] ? opts[:rate] : 9600
 		if opts[:as]
 			@declarations << "SoftwareSerial _#{opts[ :as ]} = SoftwareSerial(#{rx}, #{tx});"
 			accessor = []
 			accessor << "SoftwareSerial& #{opts[ :as ]}() {"
 			accessor << "\treturn _#{opts[ :as ]};"
 			accessor << "}"
 			@@swser_inc ||= FALSE
 			if (@@swser_inc == FALSE) # on second instance this stuff can't be repeated
 				@@swser_inc = TRUE
	 			accessor << "int read(SoftwareSerial& s) {"
 				accessor << "\treturn s.read();"
 				accessor << "}"
 				accessor << "void println( SoftwareSerial& s, char* str ) {"
 				accessor << "\treturn s.println( str );"
 				accessor << "}"
 				accessor << "void print( SoftwareSerial& s, char* str ) {"
 				accessor << "\treturn s.print( str );"
 				accessor << "}"
 				accessor << "void println( SoftwareSerial& s, int i ) {"
 				accessor << "\treturn s.println( i );"
 				accessor << "}"
 				accessor << "void print( SoftwareSerial& s, int i ) {"
 				accessor << "\treturn s.print( i );"
 				accessor << "}"
 			end
 			@accessors << accessor.join( "\n" )
 			
 			@signatures << "SoftwareSerial& #{opts[ :as ]}();"
 
 			@other_setup << "_#{opts[ :as ]}.begin(#{rate});"
 		end
 	end 	
 	
 	def swser_LCDpa(tx, opts={})
    raise ArgumentError, "can only define tx from Fixnum, got #{tx.class}" unless tx.is_a?(Fixnum)
    output_pin(tx)
    

    rate = opts[:rate] ? opts[:rate] : 9600
    geometry = opts[:geometry] ? opts[:geometry] : 0
 		if opts[:as] 
 			@declarations << "SWSerLCDpa _#{opts[ :as ]} = SWSerLCDpa(#{tx}, #{geometry});"
 			accessor = []
 			$load_libraries << "SWSerLCDpa"
 			accessor << "SWSerLCDpa& #{opts[ :as ]}() {"
 			accessor << "\treturn _#{opts[ :as ]};"
 			accessor << "}"
 			@@slcdpa_inc ||= FALSE
 			if (@@slcdpa_inc == FALSE)	# on second instance this stuff can't be repeated - BBR
 				@@slcdpa_inc = TRUE
 	 			  accessor << "void print( SWSerLCDpa& s, uint8_t b ) {"
	  			accessor << "\treturn s.print( b );"
 	 			  accessor << "}"
 	 			  accessor << "void print( SWSerLCDpa& s, const char *str ) {"
  				accessor << "\treturn s.print( str );"
  				accessor << "}"
  				accessor << "void print( SWSerLCDpa& s, char c ) {"
  				accessor << "\treturn s.print( c );"
  				accessor << "}"
  				accessor << "void print( SWSerLCDpa& s, int i ) {"
  				accessor << "\treturn s.print( i );"
  				accessor << "}"
  				accessor << "void print( SWSerLCDpa& s, unsigned int i ) {"
  				accessor << "\treturn s.print( i );"
  				accessor << "}"
  				accessor << "void print( SWSerLCDpa& s, long i ) {"
  				accessor << "\treturn s.print( i );"
  				accessor << "}"
  				accessor << "void print( SWSerLCDpa& s, unsigned long i ) {"
  				accessor << "\treturn s.print( i );"
  				accessor << "}"
  				accessor << "void print( SWSerLCDpa& s, long i, int b ) {"
  				accessor << "\treturn s.print( i, b );"
  				accessor << "}"
  				accessor << "void println( SWSerLCDpa& s, char* str ) {"
  				accessor << "\treturn s.println( str );"
 	 			  accessor << "}"
  				accessor << "void print( SWSerLCDpa& s, char* str ) {"
  				accessor << "\treturn s.print( str );"
  				accessor << "}"
	  			accessor << "void println(SWSerLCDpa& s) {"
  				accessor << "\treturn s.println();"
  				accessor << "}"
   				accessor << "void clearscr(SWSerLCDpa& s) {"
 	 			  accessor << "\treturn s.clearscr();"
  				accessor << "}"
   				accessor << "void clearline(SWSerLCDpa& s, int line) {"
 	 			  accessor << "\treturn s.clearline( line );"
  				accessor << "}"
  				accessor << "void setxy( SWSerLCDpa& s, int x, int y) {"
  				accessor << "\treturn s.setxy( x, y );"
  				accessor << "}"
  				accessor << "void clearscr(SWSerLCDpa& s, const char *str) {"
 	 			  accessor << "\treturn s.clearscr(str);"
  				accessor << "}"
   				accessor << "void clearline(SWSerLCDpa& s, int line, const char *str) {"
 	 			  accessor << "\treturn s.clearline( line, str );"
  				accessor << "}"
  				accessor << "void setxy( SWSerLCDpa& s, int x, int y, const char *str) {"
  				accessor << "\treturn s.setxy( x, y, str );"
    			accessor << "}"
  				accessor << "void clearscr(SWSerLCDpa& s, int n) {"
 	 			  accessor << "\treturn s.clearscr(n);"
  				accessor << "}"
   				accessor << "void clearline(SWSerLCDpa& s, int line, int n) {"
 	 			  accessor << "\treturn s.clearline( line, n );"
  				accessor << "}"
  				accessor << "void setxy( SWSerLCDpa& s, int x, int y, int n) {"
  				accessor << "\treturn s.setxy( x, y, n );"
    			accessor << "}"
  				accessor << "void setgeo( SWSerLCDpa& s, int g) {"
  				accessor << "\treturn s.setgeo( g );"
  				accessor << "}"
  				accessor << "void setintensity( SWSerLCDpa& s, int i ) {"
  				accessor << "\treturn s.setintensity( i );"
  				accessor << "}"
  				accessor << "void intoBignum(SWSerLCDpa& s) {"
  				accessor << "\treturn s.intoBignum();"
  				accessor << "}"
  				accessor << "void outofBignum(SWSerLCDpa& s) {"
  				accessor << "\treturn s.outofBignum();"
  				accessor << "}"
 	 			  accessor << "void println( SWSerLCDpa& s, char c ) {"
  				accessor << "\treturn s.println( c );"
  				accessor << "}"
  				accessor << "void println( SWSerLCDpa& s, const char c[] ) {"
  				accessor << "\treturn s.println( c );"
  				accessor << "}"
  				accessor << "void println( SWSerLCDpa& s, uint8_t b ) {"
  				accessor << "\treturn s.println( b );"
  				accessor << "}"
  				accessor << "void println( SWSerLCDpa& s, int i ) {"
  				accessor << "\treturn s.println( i );"
  				accessor << "}"
  				accessor << "void println( SWSerLCDpa& s, long i ) {"
  				accessor << "\treturn s.println( i );"
  				accessor << "}"
  				accessor << "void println( SWSerLCDpa& s, unsigned long i ) {"
  				accessor << "\treturn s.println( i );"
  				accessor << "}"
  				accessor << "void println( SWSerLCDpa& s, long i, int b ) {"
  				accessor << "\treturn s.println( i, b );"
 	 			  accessor << "}"
 			end
 			@accessors << accessor.join( "\n" )
 			
 			@signatures << "SWSerLCDpa& #{opts[ :as ]}();"
 
 			@other_setup << "\t_#{opts[ :as ]}.begin(#{rate});"
 		end
 	end 	



 	def swser_LCDsf(tx, opts={})
    raise ArgumentError, "can only define tx from Fixnum, got #{tx.class}" unless tx.is_a?(Fixnum)
    output_pin(tx)
    

    rate = opts[:rate] ? opts[:rate] : 9600
    geometry = opts[:geometry] ? opts[:geometry] : 0
 		if opts[:as] 
 			@declarations << "SWSerLCDsf _#{opts[ :as ]} = SWSerLCDsf(#{tx}, #{geometry});"
 			accessor = []
 			$load_libraries << "SWSerLCDsf"
 			accessor << "SWSerLCDsf& #{opts[ :as ]}() {"
 			accessor << "\treturn _#{opts[ :as ]};"
 			accessor << "}"
 			@@slcdsf_inc ||= FALSE # assign only if nil
 			if (@@slcdsf_inc == FALSE)	# on second instance this stuff can't be repeated - BBR
 				@@slcdsf_inc = TRUE
 	 			accessor << "void print( SWSerLCDsf& s, uint8_t b ) {"
	  			accessor << "\treturn s.print( b );"
 	 			  accessor << "}"
 	 			  accessor << "void print( SWSerLCDsf& s, const char *str ) {"
  				accessor << "\treturn s.print( str );"
  				accessor << "}"
  				accessor << "void print( SWSerLCDsf& s, char c ) {"
  				accessor << "\treturn s.print( c );"
  				accessor << "}"
  				accessor << "void print( SWSerLCDsf& s, int i ) {"
  				accessor << "\treturn s.print( i );"
  				accessor << "}"
  				accessor << "void print( SWSerLCDsf& s, unsigned int i ) {"
  				accessor << "\treturn s.print( i );"
  				accessor << "}"
  				accessor << "void print( SWSerLCDsf& s, long i ) {"
  				accessor << "\treturn s.print( i );"
  				accessor << "}"
  				accessor << "void print( SWSerLCDsf& s, unsigned long i ) {"
  				accessor << "\treturn s.print( i );"
  				accessor << "}"
  				accessor << "void print( SWSerLCDsf& s, long i, int b ) {"
  				accessor << "\treturn s.print( i, b );"
  				accessor << "}"
  				accessor << "void print( SWSerLCDsf& s, char* str ) {"
  				accessor << "\treturn s.print( str );"
  				accessor << "}"
   				accessor << "void clearscr(SWSerLCDsf& s) {"
 	 			  accessor << "\treturn s.clearscr();"
  				accessor << "}"
  				accessor << "void setxy( SWSerLCDsf& s, int x, int y) {"
  				accessor << "\treturn s.setxy( x, y );"
  				accessor << "}"
  				accessor << "void clearscr(SWSerLCDsf& s, const char *str) {"
 	 			  accessor << "\treturn s.clearscr(str);"
  				accessor << "}"
  				accessor << "void clearscr(SWSerLCDsf& s, int n) {"
 	 			  accessor << "\treturn s.clearscr(n);"
  				accessor << "}"
  				accessor << "void setxy( SWSerLCDsf& s, int x, int y, const char *str) {"
  				accessor << "\treturn s.setxy( x, y, str );"
  				accessor << "}"
  				accessor << "void setxy( SWSerLCDsf& s, int x, int y, int n) {"
  				accessor << "\treturn s.setxy( x, y, n );"
  				accessor << "}"
  				accessor << "void setgeo( SWSerLCDsf& s, int g) {"
  				accessor << "\treturn s.setgeo( g );"
  				accessor << "}"
  				accessor << "void setintensity( SWSerLCDsf& s, int i ) {"
  				accessor << "\treturn s.setintensity( i );"
  				accessor << "}"
  				accessor << "void setcmd( SWSerLCDsf& s, uint8_t a, uint8_t b) {"
  				accessor << "\treturn s.setcmd( a, b );"
  				accessor << "}"
  			end
 			@accessors << accessor.join( "\n" )
 			
 			@signatures << "SWSerLCDsf& #{opts[ :as ]}();"
 
 			@other_setup << "\t_#{opts[ :as ]}.begin(#{rate});"
 		end
 	end 	


  def twowire_stepper(pin1, pin2, opts={}) # servo motor routines #
    raise ArgumentError, "can only define pin1 from Fixnum, got #{pin1.class}" unless pin1.is_a?(Fixnum)
    raise ArgumentError, "can only define pin2 from Fixnum, got #{pin2.class}" unless pin2.is_a?(Fixnum)
        
    st_speed = opts[:speed] ? opts[:speed] : 30
    st_steps = opts[:steps] ? opts[:steps] : 100
    
   		if opts[:as]
 			@declarations << "Stepper _#{opts[ :as ]} = Stepper(#{st_steps},#{pin1},#{pin2});"
 			accessor = []
 			$load_libraries << "Stepper"
 			accessor << "Stepper& #{opts[ :as ]}() {"
 			accessor << "\treturn _#{opts[ :as ]};"
 			accessor << "}"
      @@stepr_inc ||= FALSE
 			if (@@stepr_inc == FALSE)	# on second instance this stuff can't be repeated - BBR
 				@@stepr_inc = TRUE
 				accessor << "void set_speed( Stepper& s, long sp ) {"
 				accessor << "\treturn s.set_speed( sp );"
 				accessor << "}"
 				accessor << "void set_steps( Stepper& s, int b ) {"
	 			accessor << "\treturn s.set_steps( b );"
 				accessor << "}"
 				accessor << "int version( Stepper& s ) {"
 				accessor << "\treturn s.version();"
 				accessor << "}"
			end
 			
 			@accessors << accessor.join( "\n" )
 			
 			@signatures << "Stepper& #{opts[ :as ]}();"

 			@other_setup << "\t_#{opts[ :as ]}.set_speed(#{st_speed});" if opts[:speed]

 		end
 	end 
 	

  def fourwire_stepper( pin1, pin2, pin3, pin4, opts={}) # servo motor routines #
    raise ArgumentError, "can only define pin1 from Fixnum, got #{pin1.class}" unless pin1.is_a?(Fixnum)
    raise ArgumentError, "can only define pin2 from Fixnum, got #{pin2.class}" unless pin2.is_a?(Fixnum)
    raise ArgumentError, "can only define pin3 from Fixnum, got #{pin3.class}" unless pin3.is_a?(Fixnum)
    raise ArgumentError, "can only define pin4 from Fixnum, got #{pin4.class}" unless pin4.is_a?(Fixnum)
        
    st_speed = opts[:speed] ? opts[:speed] : 30
    st_steps = opts[:steps] ? opts[:steps] : 100
    
   		if opts[:as]
 			@declarations << "Stepper _#{opts[ :as ]} = Stepper(#{st_steps},#{pin1},#{pin2},#{pin3},#{pin4});"
 			accessor = []
 			$load_libraries << "Stepper"
 			accessor << "Stepper& #{opts[ :as ]}() {"
 			accessor << "\treturn _#{opts[ :as ]};"
 			accessor << "}"
      @@stepr_inc ||= FALSE
 			if (@@stepr_inc == FALSE)	# on second instance this stuff can't be repeated - BBR
 				@@stepr_inc = TRUE
 				accessor << "void set_speed( Stepper& s, long sp ) {"
 				accessor << "\treturn s.set_speed( sp );"
 				accessor << "}"
 				accessor << "void set_steps( Stepper& s, int b ) {"
	 			accessor << "\treturn s.set_steps( b );"
 				accessor << "}"
 				accessor << "int version( Stepper& s ) {"
 				accessor << "\treturn s.version();"
 				accessor << "}"
			end
 			
 			@accessors << accessor.join( "\n" )
 			
 			@signatures << "Stepper& #{opts[ :as ]}();"

 			@other_setup << "\t_#{opts[ :as ]}.set_speed(#{st_speed});" if opts[:speed]

 		end
 	end 


  def servo(pin, opts={}) # servo motor routines #
    raise ArgumentError, "can only define pin from Fixnum, got #{pin.class}" unless pin.is_a?(Fixnum)
        
    minp = opts[:min] ? opts[:min] : 544
    maxp = opts[:max] ? opts[:max] : 2400

   		if opts[:as]
 			@declarations << "Servo _#{opts[ :as ]} = Servo();"
 			accessor = []
 			$load_libraries << "Servo"
 			accessor << "Servo& #{opts[ :as ]}() {"
 			accessor << "\treturn _#{opts[ :as ]};"
 			accessor << "}"
      @@servo_inc ||= FALSE
 			if (@@servo_inc == FALSE)	# on second instance this stuff can't be repeated - BBR
 				@@servo_inc = TRUE
 				accessor << "void detach( Servo& s ) {"
 				accessor << "\treturn s.detach();"
 				accessor << "}"
 				accessor << "void position( Servo& s, int b ) {"
	 			accessor << "\treturn s.position( b );"
 				accessor << "}"
 				accessor << "void speed( Servo& s, int b ) {"
 				accessor << "\treturn s.speed( b );"
 				accessor << "}"
 				accessor << "uint8_t read( Servo& s ) {"
 				accessor << "\treturn s.read();"
 				accessor << "}"
 				accessor << "uint8_t attached( Servo& s ) {"
 				accessor << "\treturn s.attached();"
 				accessor << "}"
 				accessor << "static void refresh( Servo& s ) {"
 				accessor << "\treturn s.refresh();"
 				accessor << "}"
 			end
 			
 			@accessors << accessor.join( "\n" )
 			
 			@signatures << "Servo& #{opts[ :as ]}();"

 			@other_setup << "\t_#{opts[ :as ]}.attach(#{pin}, #{opts[:position]}, #{minp}, #{maxp});" if opts[:position]
 			@other_setup << "\t_#{opts[ :as ]}.attach(#{pin}, #{minp}, #{maxp});" unless opts[:position]

 		end
 	end 
 	
 	def frequency_timer(pin, opts={}) # frequency timer routines

    raise ArgumentError, "can only define pin from Fixnum, got #{pin.class}" unless pin.is_a?(Fixnum)
    raise ArgumentError, "only pin 11 may be used for freq_out, got #{pin}" unless pin == 11
    
    if opts[:enable]
      raise ArgumentError, "enable option must include the frequency or period option" unless opts[:frequency] || opts[:period]
    end
    if opts[:frequency]
      raise ArgumentError, "the frequency option must be an integer, got #{opts[:frequency].class}" unless opts[:frequency].is_a?(Fixnum)
    end
    if opts[:period]
      raise ArgumentError, "the frequency option must be an integer, got #{opts[:period].class}" unless opts[:period].is_a?(Fixnum) 
    end
    # refer to: http://www.arduino.cc/playground/Code/FrequencyTimer2

   		if opts[:as]
   		  
   		  @@frequency_inc = TRUE
   		  @declarations << "FrequencyTimer2 _#{opts[ :as ]} = FrequencyTimer2();"
   			accessor = []
   			$load_libraries << "FrequencyTimer2"	
   			accessor << "FrequencyTimer2& #{opts[ :as ]}() {"
   			accessor << "\treturn _#{opts[ :as ]};"
   			accessor << "}"
   			# add ||=
#   		if (@@frequency_inc == FALSE)	# on second instance this stuff can't be repeated - BBR
   			# @@frequency_inc = TRUE
   			accessor << "void set_frequency( FrequencyTimer2& s, int b ) {"
   			accessor << "\treturn s.setPeriod( 1000000L/b );"
   			accessor << "}"
   			accessor << "void set_period( FrequencyTimer2& s, int b ) {"
  	 		accessor << "\treturn s.setPeriod( b );"
   			accessor << "}"
   			accessor << "void enable( FrequencyTimer2& s ) {"
   			accessor << "\treturn s.enable();"
   			accessor << "}"
   			accessor << "void disable( FrequencyTimer2& s ) {"
   			accessor << "\treturn s.disable();"
   			accessor << "}"
#   		end

   			@accessors << accessor.join( "\n" )

   			@signatures << "FrequencyTimer2& #{opts[ :as ]}();"
	
		    @other_setup << "\tFrequencyTimer2::setPeriod(0L);" unless opts[:frequency] || opts[:period]
 			  @other_setup << "\tFrequencyTimer2::setPeriod(1000000L/#{opts[:frequency]});" if opts[:frequency]
 			  @other_setup << "\tFrequencyTimer2::setPeriod(#{opts[:period]});" if opts[:period]
 			  @other_setup << "\tFrequencyTimer2::enable();" if opts[:enable] == :true
 		end
 	end	

  def one_wire(pin, opts={})
    raise ArgumentError, "can only define pin from Fixnum, got #{pin.class}" unless pin.is_a?(Fixnum)

    if opts[:as]
      @declarations << "OneWire _#{opts[ :as ]} = OneWire(#{pin});"
      accessor = []
      $load_libraries << "OneWire"
      accessor << "OneWire& #{opts[ :as ]}() {"
      accessor << "\treturn _#{opts[ :as ]};"
      accessor << "}"
      @@onewire_inc ||= FALSE
      if (@@onewire_inc == FALSE)     # on second instance this stuff can't be repeated - BBR
        @@onewire_inc = TRUE
        accessor << "uint8_t reset(OneWire& s) {"
        accessor << "\treturn s.reset();"
        accessor << "}"
        accessor << "void skip(OneWire& s) {"
        accessor << "\treturn s.skip();"
        accessor << "}"
        accessor << "void write(OneWire& s, uint8_t v, uint8_t p = 0) {" # "power = 0"  ?????
        accessor << "\treturn s.write( v, p );"
        accessor << "}"
        accessor << "uint8_t read(OneWire& s) {"
        accessor << "\treturn s.read();"
        accessor << "}"
        accessor << "void write_bit( OneWire& s, uint8_t b ) {"
        accessor << "\treturn s.write_bit( b );"
        accessor << "}"
        accessor << "uint8_t read_bit(OneWire& s) {"
        accessor << "\treturn s.read_bit();"
        accessor << "}"
        accessor << "void depower(OneWire& s) {"
        accessor << "\treturn s.depower();"
        accessor << "}"
      end
      @accessors << accessor.join( "\n" )

      @signatures << "OneWire& #{opts[ :as ]}();"
    end
  end

 	def two_wire (pin, opts={}) # i2c Two-Wire

    	raise ArgumentError, "can only define pin from Fixnum, got #{pin.class}" unless pin.is_a?(Fixnum)
    	raise ArgumentError, "only pin 19 may be used for i2c, got #{pin}" unless pin == 19

   		if opts[:as]

   			@@twowire_inc = TRUE
   		    @declarations << "TwoWire _wire = TwoWire();"
#   		    @declarations << "TwoWire _#{opts[ :as ]} = TwoWire();"
   			accessor = []
   			$load_libraries << "Wire"	
   			accessor << "TwoWire& wire() {"
   			accessor << "\treturn _wire;"
#   			accessor << "TwoWire& #{opts[ :as ]}() {"
#   			accessor << "\treturn _#{opts[ :as ]};"
   			accessor << "}"
   			accessor << "void begin( TwoWire& s) {"
   			accessor << "\treturn s.begin();"
   			accessor << "}"
   			accessor << "void begin( TwoWire& s, uint8_t a) {"
   			accessor << "\treturn s.begin(a);"
   			accessor << "}"
   			accessor << "void begin( TwoWire& s, int a) {"
   			accessor << "\treturn s.begin(a);"
   			accessor << "}"
   			accessor << "void beginTransmission( TwoWire& s, uint8_t a ) {"
   			accessor << "\treturn s.beginTransmission( a );"
   			accessor << "}"
   			accessor << "void beginTransmission( TwoWire& s, int a ) {"
   			accessor << "\treturn s.beginTransmission( a );"
   			accessor << "}"
   			accessor << "void endTransmission( TwoWire& s ) {"
   			accessor << "\treturn s.endTransmission();"
   			accessor << "}"
   			accessor << "void requestFrom( TwoWire& s, uint8_t a, uint8_t q) {"
   			accessor << "\treturn s.requestFrom( a, q );"
   			accessor << "}"
   			accessor << "void requestFrom( TwoWire& s, int a, int q) {"
   			accessor << "\treturn s.requestFrom( a, q );"
   			accessor << "}"
   			accessor << "void send( TwoWire& s, uint8_t d) {"
   			accessor << "\treturn s.send(d);"
   			accessor << "}"
   			accessor << "void send( TwoWire& s, int d) {"
   			accessor << "\treturn s.send(d);"
   			accessor << "}"
   			accessor << "void send( TwoWire& s, char* d) {"
   			accessor << "\treturn s.send(d);"
   			accessor << "}"
   			accessor << "void send( TwoWire& s, uint8_t* d, uint8_t q) {"
   			accessor << "\treturn s.send( d, q );"
   			accessor << "}"
   			accessor << "uint8_t available( TwoWire& s) {"
   			accessor << "\treturn s.available();"
   			accessor << "}"
   			accessor << "uint8_t receive( TwoWire& s) {"
   			accessor << "\treturn s.receive();"
   			accessor << "}"

   			@accessors << accessor.join( "\n" )

   			@signatures << "TwoWire& wire();"
#   			@signatures << "TwoWire& #{opts[ :as ]}();"

 			@other_setup << "\t_wire.begin();" if opts[:enable] == :true
# 			@other_setup << "\t_#{opts[ :as ]}.begin();" if opts[:enable] == :true

 		end
 	end	

	def ds1307(pin, opts={}) # DS1307 motor routines
    	raise ArgumentError, "can only define pin from Fixnum, got #{pin.class}" unless pin.is_a?(Fixnum)
        raise ArgumentError, "only pin 19 may be used for i2c, got #{pin}" unless pin == 19
#		raise ArgumentError, "only one DS1307  may be used for i2c" if @@ds1307_inc == :true

   		if opts[:as]
 			@@ds1307_inc = TRUE
 			@declarations << "DS1307 _#{opts[ :as ]} = DS1307();"
 			accessor = []
 			$load_libraries << "DS1307"
 			accessor << "DS1307& #{opts[ :as ]}() {"
 			accessor << "\treturn _#{opts[ :as ]};"
 			accessor << "}"
 			accessor << "int get( DS1307& s, int b, boolean r ) {"
 			accessor << "\treturn s.get( b, r );"
 			accessor << "}"
 			accessor << "void set( DS1307& s, int b, int r ) {"
 			accessor << "\treturn s.set( b, r );"
 			accessor << "}"
 			accessor << "void start( DS1307& s ) {"
 			accessor << "\treturn s.start();"
 			accessor << "}"
 			accessor << "void stop( DS1307& s ) {"
 			accessor << "\treturn s.stop();"
 			accessor << "}"

 			@accessors << accessor.join( "\n" )

 			@signatures << "DS1307& #{opts[ :as ]}();"
 			@other_setup << "\t_#{opts[ :as ]}.start();" if opts[:rtcstart]

 		end
 	end 



	def blinkm

	end




  def compose_setup #:nodoc: also composes headers and signatures

    declarations = []
    plugin_directives = []
    signatures = []
    external_vars = []
    setup = []
    additional_setup =[]
    helpers = []
    main = []
    result = []
    
    declarations << comment_box( "Auto-generated by RAD" )
    
    declarations << "#include <WProgram.h>\n"
    declarations << "#include <SoftwareSerial.h>\n"
    $load_libraries.each { |lib| declarations << "#include <#{lib}.h>" } unless $load_libraries.nil?
    $defines.each { |d| declarations << d }

    plugin_directives << comment_box( 'plugin directives' )
    $plugin_directives.each {|dir| plugin_directives << dir } unless $plugin_directives.nil? ||  $plugin_directives.empty?
    
    signatures << comment_box( 'method signatures' )
    signatures << "void loop();"
    signatures << "void setup();"
    signatures << "// sketch signatures"
    @signatures.each {|sig| signatures << sig}
    signatures << "// plugin signatures"
    $plugin_signatures.each {|sig| signatures << sig } unless $plugin_signatures.nil? || $plugin_signatures.empty?
    external_vars << "\n" + comment_box( "plugin external variables" )
    $plugin_external_variables.each { |meth| external_vars << meth } unless $plugin_external_variables.nil? || $plugin_external_variables.empty?
    
    signatures << "\n" + comment_box( "plugin structs" )
    $plugin_structs.each { |k,v| signatures << v } unless $plugin_structs.nil? || $plugin_structs.empty?

    external_vars << "\n" + comment_box( "sketch external variables" )
    
    $external_vars.each {|v| external_vars << v }
    external_vars << "" 
    external_vars << "// servo_settings array"

    array_size = @servo_settings.empty? ? 1 : @servo_pins.max + 1 # conserve space if no variables needed
    external_vars << "struct servo serv[#{array_size}] = { #{@servo_settings.join(", ")} };" if $plugin_structs[:servo]
    external_vars << "" 

    external_vars << "// debounce array"
    array_size = @debounce_settings.empty? ? 1 : @debounce_pins.max + 1 # conserve space if no variables needed
    external_vars << "struct debounce dbce[#{array_size}] = { #{@debounce_settings.join(", ")} };" if $plugin_structs[:debounce]
    external_vars << ""
    
    external_vars << "// hysteresis array"
    h_array_size = @hysteresis_settings.empty? ? 1 : @hysteresis_pins.length + 1 # conserve space if no variables needed
    external_vars << "struct hysteresis hyst[#{h_array_size}] = { #{@hysteresis_settings.join(", ")} };" if $plugin_structs[:sensor]
    external_vars << ""
    
    external_vars << "// spectrasymbol soft pot array"
    sp_array_size = @spectra_settings.empty? ? 1 : @spectra_pins.length + 1 # conserve space if no variables needed
    external_vars << "struct spectra spec[#{sp_array_size}] = { #{@spectra_settings.join(", ")} };" if $plugin_structs[:spectra]
    external_vars << ""
    
    $external_array_vars.each { |var| external_vars << var } if $external_array_vars

    external_vars << "\n" + comment_box( "variable and accessors" )
    @declarations.each {|dec| external_vars << dec}
    external_vars << ""     
    @accessors.each {|ac| external_vars << ac}

    # fix naming
    external_vars << "\n" + comment_box( "assembler declarations" )
    unless @assembler_declarations.empty?
      external_vars << <<-CODE
         extern "C" {
           #{@assembler_declarations.join("\n")}
         }
      CODE
    end

    external_vars << "\n" + comment_box( "setup" )
    setup << "void setup() {"
    setup << "\t// pin modes"
    
    @pin_modes.each do |k,v|
      v.each do |value| 
        setup << "\tpinMode(#{value}, #{k.to_s.upcase});"
      end
    end

    @pullups.each do |pin|
	    setup << "\tdigitalWrite( #{pin}, HIGH ); // enable pull-up resistor for input"
    end
    
    unless $add_to_setup.nil? || $add_to_setup.empty?
      setup << "\t// setup from plugins via add_to_setup method"
      $add_to_setup.each {|item| setup << "\t#{item}"}
    end
    
    unless @other_setup.empty?
      setup << "\t// other setup"
      setup << @other_setup.join( "\n" )
    end
    
    additional_setup << "}\n"
    
    helpers << comment_box( "helper methods" )
    helpers << "\n// RAD built-in helpers"
    helpers << @helper_methods.lstrip
    
    helpers << "\n" + comment_box( "plugin methods" )  
    # need to add plugin name to this... 
    $plugin_methods.each { |meth| helpers << "#{meth[0][0]}\n" } unless $plugin_methods.nil? || $plugin_methods.empty?
    
    helpers << "\n// serial helpers"
    helpers << serial_boilerplate.lstrip
    
    main << "\n" + comment_box( "main() function" )
    main << "int main() {"
    main << "\tinit();"
    main << "\tsetup();"
    main << "\tfor( ;; ) { loop(); }"
    main << "\treturn 0;"
    main << "}"

    main << "\n" + comment_box( "loop!  Autogenerated by RubyToC, sorry it's ugly." )

  return [declarations, plugin_directives, signatures, external_vars, setup, additional_setup, helpers, main]

  end
  
  
 
  
  
  # Write inline assembler code. 'Name' is a symbol representing the name of the function to be defined in the assembly code; 'signature' is the function signature for the function being defined; and 'code' is the assembly code itself (both of these last two arguments are strings). See an example here: http://rad.rubyforge.org/examples/assembler_test.html
  def assembler(name, signature, code)
    @assembler_declarations << signature
    assembler_code = <<-CODE
      .file "#{name}.S"
      .arch #{Makefile.hardware_params['mcu']}
      .global __do_copy_data
      .global __do_clear_bss
      .text
    .global #{name}
      .type #{name}, @function
    #{code}
    CODE
            
    File.open(File.expand_path("#{RAD_ROOT}") + "/#{PROJECT_DIR_NAME}/#{name}.S", "w"){|f| f << assembler_code}
  end
  
  def self.pre_process(sketch_string) #:nodoc:
    result = sketch_string 
    # add external vars to each method (needed for better translation, will be removed in make:upload)
    result.gsub!(/(^\s*def\s.\w*(\(.*\))?)/, '\1' + " \n #{$external_vars.join("  \n ")}"  )
    # gather method names
    sketch_methods = result.scan(/^\s*def\s.\w*/)
    sketch_methods.each {|m| $sketch_methods << m.gsub(/\s*def\s*/, "") }
    
    result.gsub!("HIGH", "1")
    result.gsub!("LOW", "0")
    result.gsub!("ON", "1")
    result.gsub!("OFF", "0")
    result
  end
  
  def self.add_to_setup(meth) 
    meth = meth.gsub("setup", "additional_setup")
    post_process_ruby_to_c_methods(meth)
  end
  
  def self.post_process_ruby_to_c_methods(e)      
    clean_c_methods = []
      # need to take a look at the \(unsigned in the line below not sure if we are really trying to catch something like that
      if e !~ /^\s*(#{C_VAR_TYPES})(\W{1,6}|\(unsigned\()(#{$external_var_identifiers.join("|")})/ || $external_var_identifiers.empty?
        # use the list of identifers the external_vars method of the sketch and remove the parens the ruby2c sometime adds to variables
        # keep an eye on the gsub!.. are we getting nil errors
        e.gsub!(/((#{$external_var_identifiers.join("|")})\(\))/, '\2')  unless $external_var_identifiers.empty? 
        clean_c_methods << e
      end
      return clean_c_methods.join( "\n" )
  end
  
  private
  
  def serial_boilerplate #:nodoc:
    out = []
    out << "int serial_available() {"
    out << "\treturn (Serial.available() > 0);"
    out << "}"

    out << "char serial_read() {"
    out << "\treturn (char) Serial.read();"
    out << "}"

    out << "void serial_flush() {"
    out << "\treturn Serial.flush();"
    out << "}"

    out << "void serial_print( char str ) {"
    out << "\treturn Serial.print( str );"
    out << "}"
    
    out << "void serial_print( char* str ) {"
    out << "\treturn Serial.print( str );"
    out << "}"
    
    out << "void serial_print( int i ) {"
    out << "\treturn Serial.print( i );"
    out << "}"
    
    out << "void serial_print( long i ) {"
    out << "\treturn Serial.print( i );"
    out << "}"
  
 		out << "void serial_println( char* str ) {"
    out << "\treturn Serial.println( str );"
    out << "}"
    
    out << "void serial_println( char str ) {"
    out << "\treturn Serial.println( str );"
    out << "}"
 
  	out << "void serial_println( int i ) {"
    out << "\treturn Serial.println( i );"
    out << "}"
    
    out << "void serial_println( long i ) {"
    out << "\treturn Serial.println( i );"
    out << "}"
    
    ## added to support millis
    out << "void serial_print( unsigned long i ) {"
    out << "\treturn Serial.print( i );"
    out << "}"

    return out.join( "\n" )
  end
  
  def comment_box( content ) #:nodoc:
    out = []
    out << "/" * 74
    out << "// " + content
    out << "/" * 74
    
    return out.join( "\n" )
  end  

  
end