class HardwareLibrary < ArduinoSketch
  
  def initialize
    super
  end
  
  # Treat a pair of digital I/O pins as a serial line. See: http://www.arduino.cc/en/Tutorial/SoftwareSerial
  def software_serial(rx, tx, opts={})
    raise ArgumentError, "can only define rx from Fixnum, got #{rx.class}" unless rx.is_a?(Fixnum)
    raise ArgumentError, "can only define tx from Fixnum, got #{tx.class}" unless tx.is_a?(Fixnum)

    output_pin(tx)
    input_pin(rx)

    rate = opts[:rate] ? opts[:rate] : 9600
    if opts[:as]
      @declarations << "SoftwareSerial _#{opts[ :as ]} = SoftwareSerial(#{rx}, #{tx});"
      accessor = <<-STR
        SoftwareSerial& #{opts[ :as ]}() {
        return _#{opts[ :as ]};
        }
      STR
      @@swser_inc ||= FALSE
      if (@@swser_inc == FALSE) # on second instance this stuff can't be repeated
        @@swser_inc = TRUE
        accessor += <<-STR
        int read(SoftwareSerial& s) {
          return s.read();
        }
        void println( SoftwareSerial& s, char* str ) {
          return s.println( str );
        }
        void print( SoftwareSerial& s, char* str ) {
          return s.print( str );
        }
        void println( SoftwareSerial& s, int i ) {
          return s.println( i );
        }
        void print( SoftwareSerial& s, int i ) {
          return s.print( i );
        }
        STR
      end
      @accessors << accessor

      @signatures << "SoftwareSerial& #{opts[ :as ]}();"

      @other_setup << "\t_#{opts[ :as ]}.begin(#{rate});"
    end
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

  def swser_LCDpa(tx, opts={})
    raise ArgumentError, "can only define tx from Fixnum, got #{tx.class}" unless tx.is_a?(Fixnum)

    rate = opts[:rate] ? opts[:rate] : 9600
    geometry = opts[:geometry] ? opts[:geometry] : 0
    if opts[:as] 
      @declarations << "SWSerLCDpa _#{opts[ :as ]} = SWSerLCDpa(#{tx}, #{geometry});"
      $load_libraries << "SWSerLCDpa"
      accessor = <<-STR
        SWSerLCDpa& #{opts[ :as ]}() {
          return _#{opts[ :as ]};
        }
      STR
      @@slcdpa_inc ||= FALSE
      if (@@slcdpa_inc == FALSE)	# on second instance this stuff can't be repeated - BBR
        @@slcdpa_inc = TRUE
        # ------------------- print generics -------------------------------
        accessor += <<-STR			  
        void print( SWSerLCDpa& s, uint8_t b ) {
          return s.print( b );
        }
        void print( SWSerLCDpa& s, const char *str ) {
          return s.print( str );
        }
        void print( SWSerLCDpa& s, char c ) {
          return s.print( c );
        }
        void print( SWSerLCDpa& s, int i ) {
          return s.print( i );
        }
        void print( SWSerLCDpa& s, unsigned int i ) {
          return s.print( i );
        }
        void print( SWSerLCDpa& s, long i ) {
          return s.print( i );
        }
        void print( SWSerLCDpa& s, unsigned long i ) {
          return s.print( i );
        }
        void print( SWSerLCDpa& s, long i, int b ) {
          return s.print( i, b );
        }
        STR
        # ------------------ PA-LCD specific functions ---------------------------------
        accessor += <<-STR
        void clearscr(SWSerLCDpa& s) {
          return s.clearscr();
        }
        void clearscr(SWSerLCDpa& s, const char *str) {
          return s.clearscr(str);
        }
        void clearscr(SWSerLCDpa& s, int n) {
          return s.clearscr(n);
        }
        void clearscr(SWSerLCDpa& s, long n, int b) {
          return s.clearscr(n, b);
        }
        void clearline(SWSerLCDpa& s, int line) {
          return s.clearline( line );
        }
        void clearline(SWSerLCDpa& s, int line, const char *str) {
          return s.clearline( line, str );
        }
        void clearline(SWSerLCDpa& s, int line, int n) {
          return s.clearline( line, n );
        }
        void clearline(SWSerLCDpa& s, int line, long n,  int b) {
          return s.clearline( line, n, b );
        }
        void home( SWSerLCDpa& s) {
          return s.home();
        }
        void home( SWSerLCDpa& s, const char *str) {
          return s.home( str );
        }
        void home( SWSerLCDpa& s, int n) {
          return s.home( n );
        }
        void home( SWSerLCDpa& s, long n, int b) {
          return s.home( n, b );
        }
        void setxy( SWSerLCDpa& s, int x, int y) {
          return s.setxy( x, y );
        }
        void setxy( SWSerLCDpa& s, int x, int y, const char *str) {
          return s.setxy( x, y, str );
        }
        void setxy( SWSerLCDpa& s, int x, int y, long n, int b) {
          return s.setxy( x, y, n, b );
        }
        void setxy( SWSerLCDpa& s, int x, int y, int n) {
          return s.setxy( x, y, n );
        }
        void setgeo( SWSerLCDpa& s, int g) {
          return s.setgeo( g );
        }
        void setintensity( SWSerLCDpa& s, int i ) {
          return s.setintensity( i );
        }
        void intoBignum(SWSerLCDpa& s) {
          return s.intoBignum();
        }
        void outofBignum(SWSerLCDpa& s) {
          return s.outofBignum();
        }
        STR
      end

      @accessors << accessor

      @signatures << "SWSerLCDpa& #{opts[ :as ]}();"

      @other_setup << "\t_#{opts[ :as ]}.begin(#{rate});"
      @other_setup << "\t_#{opts[ :as ]}.clearscr();"     if :clear_screen == :true

    end
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

  def swser_LCDsf(tx, opts={})
    raise ArgumentError, "can only define tx from Fixnum, got #{tx.class}" unless tx.is_a?(Fixnum)    

    rate = opts[:rate] ? opts[:rate] : 9600
    geometry = opts[:geometry] ? opts[:geometry] : 0
    if opts[:as] 
      @declarations << "SWSerLCDsf _#{opts[ :as ]} = SWSerLCDsf(#{tx}, #{geometry});"

      $load_libraries << "SWSerLCDsf"
      accessor = <<-STR
        SWSerLCDsf& #{opts[ :as ]}() {
          return _#{opts[ :as ]};
        }
      STR
      @@slcdsf_inc ||= FALSE # assign only if nil
      if (@@slcdsf_inc == FALSE)	# on second instance this stuff can't be repeated - BBR
        @@slcdsf_inc = TRUE
        accessor += <<-STR
        void print( SWSerLCDsf& s, uint8_t b ) {
          return s.print( b );
        }
        void print( SWSerLCDsf& s, const char *str ) {
          return s.print( str );
        }
        void print( SWSerLCDsf& s, char c ) {
          return s.print( c );
        }
        void print( SWSerLCDsf& s, int i ) {
          return s.print( i );
        }
        void print( SWSerLCDsf& s, unsigned int i ) {
          return s.print( i );
        }
        void print( SWSerLCDsf& s, long i ) {
          return s.print( i );
        }
        void print( SWSerLCDsf& s, unsigned long i ) {
          return s.print( i );
        }
        void print( SWSerLCDsf& s, long i, int b ) {
          return s.print( i, b );
        }
        STR
        # ------------------ Spark Fun Specific  Functions ---------------------------------
        accessor += <<-STR
        void clearscr(SWSerLCDsf& s) {
          return s.clearscr();
        }
        void clearscr(SWSerLCDsf& s, const char *str) {
          return s.clearscr(str);
        }
        void clearscr(SWSerLCDsf& s, int n) {
          return s.clearscr(n);
        }
        void clearscr(SWSerLCDsf& s, long n, int b) {
          return s.clearscr(n, b);
        }
        void home( SWSerLCDsf& s) {
          return s.home();
        }
        void home( SWSerLCDsf& s, const char *str) {
          return s.home( str );
        }
        void home( SWSerLCDsf& s, int n) {
          return s.home( n );
        }
        void home( SWSerLCDsf& s, long n, int b) {
          return s.home( n, b );
        }
        void setxy( SWSerLCDsf& s, int x, int y) {
          return s.setxy( x, y );
        }
        void setxy( SWSerLCDsf& s, int x, int y, const char *str) {
          return s.setxy( x, y, str );
        }
        void setxy( SWSerLCDsf& s, int x, int y, int n) {
          return s.setxy( x, y, n );
        }
        void setxy( SWSerLCDsf& s, int x, int y, long n, int b) {
          return s.setxy( x, y, n, b );
        }
        void setgeo( SWSerLCDsf& s, int g) {
          return s.setgeo( g );
        }
        void setintensity( SWSerLCDsf& s, int i ) {
          return s.setintensity( i );
        }
        void setcmd( SWSerLCDsf& s, uint8_t a, uint8_t b) {
          return s.setcmd( a, b );
        }
        STR
      end
      @accessors << accessor

      @signatures << "SWSerLCDsf& #{opts[ :as ]}();"

      @other_setup << "\t_#{opts[ :as ]}.begin(#{rate});"
      @other_setup << "\t_#{opts[ :as ]}.clearscr();"     if :clear_screen == :true

    end
  end 	


  def loop_timer(opts={}) # loop timer methods #

    if opts[:as]
      @declarations << "LoopTimer _#{opts[ :as ]} = LoopTimer();"
      $load_libraries << "LoopTimer"
      accessor = <<-STR
        LoopTimer& #{opts[ :as ]}() {
          return _#{opts[ :as ]};
        }
      STR
      @@loptim_inc ||= FALSE
      if (@@loptim_inc == FALSE)	# on second instance this stuff can't be repeated - BBR
        @@limtim_inc = TRUE
        accessor += <<-STR
        void track( LoopTimer& s ) {
          return s.track();
        }
        unsigned long get_total( LoopTimer& s ) {
          return s.get_total();
        }
        STR
      end

      @accessors << accessor

      @signatures << "LoopTimer& #{opts[ :as ]}();"

    end
  end

  # use the servo library
  def servo_setup(num, opts)
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
  
  def servo(pin, opts={}) # servo motor routines #
    raise ArgumentError, "can only define pin from Fixnum, got #{pin.class}" unless pin.is_a?(Fixnum)

    minp = opts[:min] ? opts[:min] : 544
    maxp = opts[:max] ? opts[:max] : 2400

    if opts[:as]
      @declarations << "Servo _#{opts[ :as ]} = Servo();"
      $load_libraries << "Servo"
      accessor = <<-STR
        Servo& #{opts[ :as ]}() {
          return _#{opts[ :as ]};
        }
      STR
      @@servo_inc ||= FALSE
      if (@@servo_inc == FALSE)	# on second instance this stuff can't be repeated - BBR
        @@servo_inc = TRUE
        accessor += <<-STR
        uint8_t attach( Servo& s, int p ) {
          return s.attach(p);
        }
        uint8_t attach( Servo& s, int p, int pos ) {
          return s.attach(p, pos );
        }
        uint8_t attach( Servo& s, int p, uint16_t mn, uint16_t mx ) {
          return s.attach(p, mn, mx);
        }
        uint8_t attach( Servo& s, int p, int pos, uint16_t mn, uint16_t mx ) {
          return s.attach(p, pos, mn, mx);
        }
        void detach( Servo& s ) {
          return s.detach();
        }
        void position( Servo& s, int b ) {
          return s.position( b );
        }
        void speed( Servo& s, int b ) {
          return s.speed( b );
        }
        uint8_t read( Servo& s ) {
          return s.read();
        }
        uint8_t attached( Servo& s ) {
          return s.attached();
        }
        static void refresh( Servo& s ) {
          return s.refresh();
        }
        STR
      end

      @accessors << accessor

      @signatures << "Servo& #{opts[ :as ]}();"

      @other_setup << "\t_#{opts[ :as ]}.attach(#{pin}, #{opts[:position]}, #{minp}, #{maxp});" if opts[:position]
      @other_setup << "\t_#{opts[ :as ]}.attach(#{pin}, #{minp}, #{maxp});" unless opts[:position]

    end
  end
  
  def twowire_stepper(pin1, pin2, opts={}) # servo motor routines #
    raise ArgumentError, "can only define pin1 from Fixnum, got #{pin1.class}" unless pin1.is_a?(Fixnum)
    raise ArgumentError, "can only define pin2 from Fixnum, got #{pin2.class}" unless pin2.is_a?(Fixnum)

    st_speed = opts[:speed] ? opts[:speed] : 30
    st_steps = opts[:steps] ? opts[:steps] : 100

    if opts[:as]
      @declarations << "Stepper _#{opts[ :as ]} = Stepper(#{st_steps},#{pin1},#{pin2});"
      $load_libraries << "Stepper"
      accessor = <<-STR
        Stepper& #{opts[ :as ]}() {
          return _#{opts[ :as ]};
        }
      STR
      @@stepr_inc ||= FALSE
      if (@@stepr_inc == FALSE)	# on second instance this stuff can't be repeated - BBR
      @@stepr_inc = TRUE
      accessor = <<-STR
        void set_speed( Stepper& s, long sp ) {
          return s.set_speed( sp );
        }
        void set_steps( Stepper& s, int b ) {
          return s.set_steps( b );
        }
        int version( Stepper& s ) {
          return s.version();
        }
        STR
    end

    @accessors << accessor

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
      $load_libraries << "Stepper"
      accessor = <<-STR
        Stepper& #{opts[ :as ]}() {
          return _#{opts[ :as ]};
        }
      STR
      @@stepr_inc ||= FALSE
      if (@@stepr_inc == FALSE)	# on second instance this stuff can't be repeated - BBR
        @@stepr_inc = TRUE
        accessor += <<-STR
        void set_speed( Stepper& s, long sp ) {
          return s.set_speed( sp );
        }
        void set_steps( Stepper& s, int b ) {
          return s.set_steps( b );
        }
        int version( Stepper& s ) {
          return s.version();
        }
        STR
      end

      @accessors << accessor

      @signatures << "Stepper& #{opts[ :as ]}();"

      @other_setup << "\t_#{opts[ :as ]}.set_speed(#{st_speed});" if opts[:speed]

    end
  end
 	
  def frequency_timer(pin, opts={}) # frequency timer routines

    @@frequency_inc ||= FALSE
    raise ArgumentError, "there can be only one instance of Frequency Timer2" if @@frequency_inc == TRUE
    @@frequency_inc = TRUE

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

      @declarations << "FrequencyTimer2 _#{opts[ :as ]} = FrequencyTimer2();"

      $load_libraries << "FrequencyTimer2"
        accessor = <<-STR
        FrequencyTimer2& #{opts[ :as ]}() {
          return _#{opts[ :as ]};
        }
        void set_frequency( FrequencyTimer2& s, int b ) {
          return s.setPeriod( 1000000L/b );
        }
        void set_period( FrequencyTimer2& s, int b ) {
          return s.setPeriod( b );
        }
        void enable( FrequencyTimer2& s ) {
          return s.enable();
        }
        void disable( FrequencyTimer2& s ) {
          return s.disable();
        }
      STR

      @accessors << accessor

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
      accessor = <<-STR 
        OneWire& #{opts[ :as ]}() {
          return _#{opts[ :as ]};
        }
    STR
      @@onewire_inc ||= FALSE
      if (@@onewire_inc == FALSE)     # on second instance this stuff can't be repeated - BBR
        @@onewire_inc = TRUE
        accessor += <<-STR
        uint8_t reset(OneWire& s) {
          return s.reset();
        }
        void skip(OneWire& s) {
          return s.skip();
        }
        void write(OneWire& s, uint8_t v, uint8_t p = 0) {
          return s.write( v, p );
        }
        uint8_t read(OneWire& s) {
          return s.read();
        }
        void write_bit( OneWire& s, uint8_t b ) {
          return s.write_bit( b );
        }
        uint8_t read_bit(OneWire& s) {
          return s.read_bit();
        }
        void depower(OneWire& s) {
          return s.depower();
        }
        STR
      end
      @accessors << accessor

      @signatures << "OneWire& #{opts[ :as ]}();"
    end
  end

  def two_wire (pin, opts={}) # i2c Two-Wire

    raise ArgumentError, "can only define pin from Fixnum, got #{pin.class}" unless pin.is_a?(Fixnum)
    raise ArgumentError, "only pin 19 may be used for i2c, got #{pin}" unless pin == 19

    if opts[:as]

      @@twowire_inc = TRUE
       @declarations << "TwoWire _wire = TwoWire();"
      $load_libraries << "Wire"	
      accessor = <<-STR
        TwoWire& wire() {
          return _wire;
        }
        void begin( TwoWire& s) {
          return s.begin();
        }
        void begin( TwoWire& s, uint8_t a) {
          return s.begin(a);
        }
        void begin( TwoWire& s, int a) {
          return s.begin(a);
        }
        void beginTransmission( TwoWire& s, uint8_t a ) {
          return s.beginTransmission( a );
        }
        void beginTransmission( TwoWire& s, int a ) {
          return s.beginTransmission( a );
        }
        void endTransmission( TwoWire& s ) {
          return s.endTransmission();
        }
        void requestFrom( TwoWire& s, uint8_t a, uint8_t q) {
          return s.requestFrom( a, q );
        }
        void requestFrom( TwoWire& s, int a, int q) {
          return s.requestFrom( a, q );
        }
        void send( TwoWire& s, uint8_t d) {
          return s.send(d);
        }
        void send( TwoWire& s, int d) {
          return s.send(d);
        }
        void send( TwoWire& s, char* d) {
          return s.send(d);
        }
        void send( TwoWire& s, uint8_t* d, uint8_t q) {
          return s.send( d, q );
        }
        uint8_t available( TwoWire& s) {
          return s.available();
        }
        uint8_t receive( TwoWire& s) {
          return s.receive();
        }
      STR

      @accessors << accessor

      @signatures << "TwoWire& wire();"

      @other_setup << "\t_wire.begin();"    # We never get here a second time. If we go to the trouble 
                                            # of setting up i2c, we gotta start it and it never gets 
                                            # stopped. This is not 'optional!'
    end

  end
  
  # work in progress
  def ethernet(pin, opts={})
    raise ArgumentError, "can only define pin from Fixnum, got #{pin.class}" unless pin.is_a?(Fixnum)
    if opts[:as]
      accessor = []
      $load_libraries << "AF_XPort"
      $load_libraries << "AFSoftSerial"
      # needs to be more granular:
      accessor << "AF_XPort xport = AF_XPort(XPORT_RXPIN, XPORT_TXPIN, XPORT_RESETPIN, XPORT_DTRPIN, XPORT_RTSPIN, XPORT_CTSPIN);"
      rate = opts[:rate] ? opts[:rate] : 57600
      @other_setup << "xport.begin(#{rate});"
      @accessors << accessor.join( "\n" )
    end
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
  
  
  
  def ds1307(pin, opts={}) # DS1307 real time clock routines routines

    @@ds1307_inc ||= FALSE
    raise ArgumentError, "only one DS1307  may be used for i2c" unless @@ds1307_inc == FALSE
    @@ds1307_inc = TRUE
    raise ArgumentError, "can only define pin from Fixnum, got #{pin.class}" unless pin.is_a?(Fixnum)
    raise ArgumentError, "only pin 19 may be used for i2c, got #{pin}" unless pin == 19
    if opts[:as]
        @declarations << "DS1307 _#{opts[ :as ]} = DS1307();"
        $load_libraries << "DS1307"
        accessor = <<-STR
        DS1307& #{opts[ :as ]}() {
          return _#{opts[ :as ]};
        }
        void get( DS1307& s, byte *buf, boolean r ) {
          return s.get( buf, r );
        }
        byte get( DS1307& s, int b, boolean r ) {
          return s.get( b, r );
        }
        void set( DS1307& s, int b, int r ) {
          return s.set( b, r );
        }
        void start( DS1307& s ) {
          return s.start();
        }
        void stop( DS1307& s ) {
          return s.stop();
        }
        STR

        @accessors << accessor

        @signatures << "DS1307& #{opts[ :as ]}();"
        @other_setup << "\t_#{opts[ :as ]}.start();" if opts[:rtcstart]
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