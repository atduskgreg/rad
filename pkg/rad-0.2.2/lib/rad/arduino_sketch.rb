# ArduinoSketch is the main access point for working with RAD. Sub-classes of ArduinoSketch have access to a wide array of convenient class methods (documented below) for doing the most common kinds of setup needed when programming the Arduino such as configuring input and output pins and establishing serial connections. Here is the canonical 'hello world' example of blinking a single LED in RAD:
#
#   class HelloWorld < ArduinoSketch
#     output_pin 13, :as => led
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
class ArduinoSketch
  
  def initialize #:nodoc:
    @declarations = []
    @pin_modes = {:output => [], :input => []}
    @pullups = []
    @other_setup = [] # specifically, Serial.begin
    @assembler_declarations = []
    @accessors = []
    @signatures = ["void blink();", "int main();"]

    helper_methods = []
    helper_methods << "void blink(int pin, int ms) {"
    helper_methods << "\tdigitalWrite( pin, HIGH );"
    helper_methods << "\tdelay( ms );"
    helper_methods << "\tdigitalWrite( pin, LOW );"
    helper_methods << "\tdelay( ms );"
    helper_methods << "}"
    @helper_methods = helper_methods.join( "\n" )
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
  
  # Confiugre a single pin for output and setup a method to refer to that pin, i.e.:
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
 			@accessors << accessor.join( "\n" )
 			
 			@signatures << "SoftwareSerial& #{opts[ :as ]}();"
 
 			@other_setup << "_#{opts[ :as ]}.begin(#{rate});"
 		end
 	end 	
 	
 	def swser_LCDpa(tx, opts={})
    raise ArgumentError, "can only define tx from Fixnum, got #{tx.class}" unless tx.is_a?(Fixnum)
    output_pin(tx)
    
    rate = opts[:rate] ? opts[:rate] : 9600
 		if opts[:as]
 			@declarations << "SWSerLCDpa _#{opts[ :as ]} = SWSerLCDpa(#{tx});"
 			accessor = []
 			accessor << "SWSerLCDpa& #{opts[ :as ]}() {"
 			accessor << "\treturn _#{opts[ :as ]};"
 			accessor << "}"
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
 			accessor << "void home(SWSerLCDpa& s) {"
 			accessor << "\treturn s.home();"
 			accessor << "}"
 			accessor << "void setgeo( SWSerLCDpa& s, int i ) {"
 			accessor << "\treturn s.setgeo( i );"
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
 			accessor << "void setxy( SWSerLCDpa& s, int x, int y) {"
 			accessor << "\treturn s.setxy( x, y );"
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
 			@accessors << accessor.join( "\n" )
 			
 			@signatures << "SWSerLCDpa& #{opts[ :as ]}();"
 
 			@other_setup << "_#{opts[ :as ]}.begin(#{rate});"
 		end
 	end 	
  
  def compose_setup #:nodoc: also composes headers and signatures
    result = []
    
    result << comment_box( "Auto-generated by RAD" )
    
    result << "#include <WProgram.h>\n"
    result << "#include <SoftwareSerial.h>\n"
    result << "#include <SWSerLCDpa.h>"

    
    result << comment_box( 'method signatures' )
    result << "void loop();"
    result << "void setup();"
    @signatures.each {|sig| result << sig}

    result << "\n" + comment_box( "variable and accessors" )
    @declarations.each {|dec| result << dec}
    result << "" # blank line    
    @accessors.each {|ac| result << ac}

    result << "\n" + comment_box( "assembler declarations" )
    unless @assembler_declarations.empty?
      result << <<-CODE
         extern "C" {
           #{@assembler_declarations.join("\n")}
         }
      CODE
    end

    result << "\n" + comment_box( "setup" )
    result << "void setup() {"
    result << "\t// pin modes"
    
    @pin_modes.each do |k,v|
      v.each do |value| 
        result << "\tpinMode(#{value}, #{k.to_s.upcase});"
      end
    end

    @pullups.each do |pin|
	    result << "\tdigitalWrite( #{pin}, HIGH ); // enable pull-up resistor for input"
    end
    
    unless @other_setup.empty?
      result << "\t// other setup"
      result << @other_setup.join( "\n" )
    end
    
    result << "}\n"
    
    result << comment_box( "helper methods" )
    result << "\n// RAD built-in helpers"
    result << @helper_methods.lstrip
    
    result << "\n// serial helpers"
    result << serial_boilerplate.lstrip
    
    result << "\n" + comment_box( "main() function" )
    result << "int main() {"
    result << "\tinit();"
    result << "\tsetup();"
    result << "\tfor( ;; ) { loop(); }"
    result << "\treturn 0;"
    result << "}"

    result << "\n" + comment_box( "loop!  Autogenerated by RubyToC, sorry it's ugly." )

    return result.join( "\n" )
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
    result.gsub!("HIGH", "1")
    result.gsub!("LOW", "0")
    result.gsub!("ON", "1")
    result.gsub!("OFF", "0")
    result
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