

class ArduinoHardwareConfig < ArduinoSketch
  
  def initialize
    super
  end
  
  def i2c_eeprom(pin, opts={}) # i2c serial eeprom routines #

    dev_addr = opts[:address] ? opts[:address] : 0

    if opts[:as]
      @declarations << "I2CEEPROM _#{opts[ :as ]} = I2CEEPROM(#{dev_addr});"
      $load_libraries << "I2CEEPROM"
      accessor = <<-STR
        I2CEEPROM& #{opts[ :as ]}() {
          return _#{opts[ :as ]};
        }
      STR
      @@i2cepr_inc ||= FALSE
      if (@@i2cepr_inc == FALSE)	# on second instance this stuff can't be repeated - BBR
        @@i2cepr_inc = TRUE
        accessor += <<-STR
        void write_byte( I2CEEPROM& s, unsigned int addr, byte b ) {
          return s.write_byte( addr, b );
        }
        void write_page( I2CEEPROM& s, unsigned int addr, byte* d, int l ) {
          return s.write_page( addr, d, l );
        }
        byte read_byte( I2CEEPROM& s, unsigned int addr ) {
          return s.read_byte( addr );
        }
        void read_buffer( I2CEEPROM& s, unsigned int addr, byte *d, int l ) {
          return s.read_buffer( addr, d, l );
        }
        STR
      end

      @accessors << accessor

      @signatures << "I2CEEPROM& #{opts[ :as ]}();"

    end
  end
  
  private
  
  def serial_boilerplate #:nodoc:

    out = <<-STR
        int serial_available() {
          return (Serial.available() > 0);
        }

        char serial_read() {
          return (char) Serial.read();
        }

        void serial_flush() {
          return Serial.flush();
        }

        void serial_print( char str ) {
          return Serial.print( str );
        }

        void serial_print( char* str ) {
          return Serial.print( str );
        }

        void serial_print( int i ) {
          return Serial.print( i );
        }

        void serial_print( long i ) {
          return Serial.print( i );
        }

      	void serial_println( char* str ) {
          return Serial.println( str );
        }

        void serial_println( char str ) {
          return Serial.println( str );
        }

      	void serial_println( int i ) {
          return Serial.println( i );
        }

        void serial_println( long i ) {
          return Serial.println( i );
        }

        void serial_print( unsigned long i ) {
          return Serial.print( i );
        }
  STR

    return out
  end
  
end 