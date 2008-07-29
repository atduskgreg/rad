## RAD plugins -- the start

## June 25, 2008
## jd@jdbarnhart.com
## 


# Disclaimer: This is only a first run at the notion of plugins and started off as just a way to keep from adding everything to ArduinoSketch.  
# ArduinoPlugin is the RAD class for adding "plugins" which add functionality such as servo control, special lcd screen methods, debounce methods, etc.. Sub-classes of ArduinoPlugin (the plugins) add  class methods for doing thing beyond the most common kinds of setup needed when programming the Arduino.  Here is an example of controlling a servo:
#
#   class MoveServo < ArduinoSketch
#
#     external_vars :sensor_position => "int, 0", :servo_amount => "int, 0"
#
#     output_pin 4, :as => :my_servo, :min => 700, :max => 2200
#     input_pin 1, :as => :sensor
#     def loop
#       sensor_position = analogRead(sensor)
#       servo_amount = (sensor_position*2 + 500)
#       move_servo my_servo, servo_amount
#     end
#   end
#
# 
# Here's one for latching an led

#   output_pin 5, :as => :red_led
#   input_pin 8, :as => :red_button, :latch => :off, # optional adjustment to amount of time for debounce (default 200) :adjust => 250
#                                                    # latch sets the led as on or off initially and sets up a array of structs to keep timing and state
#
#     def loop
#       debounce_toggle(red_button, red_led)
#     end
#   end
#
# Since this is a first pass, there is work to do here, such as 
#   checking if plugin methods are needed and only loading those that are, 
#   more compreshensive plugin organization (more railsish with tests, etc)
#   a scheme to encourage plugin authors and provide an easy way to avoid method and variable namespace collisions
#   a scheme to flag when a prerequisite plugin is required
# on with the show:



class ArduinoPlugin
  
def initialize #:nodoc:
  
  $plugin_directives = $plugin_directives || []
  $plugin_external_variables = $plugin_external_variables || []
  # moved to check_for_plugin_use $plugin_structs = $plugin_structs || {}
  $plugin_signatures = $plugin_signatures || []
  $plugin_methods = $plugin_methods || []
 # $plugin_methods_hash = $plugin_methods_hash || {}  ### new
 # $plugins_to_load = $plugins_to_load || []  ### new
  $add_to_setup = $add_to_setup || []
  $load_libraries = $load_libraries || []


end
  
# c declarations are automatic
# you won't need them in the plugins
# so, the first thing we can do is gather all the plugin methods, and scan the 
# sketch available plugins...
# if the sketch has them, we include the plugins in the build...
# otherwise not..

  def include_wire
    $load_libraries << "Wire" unless $load_libraries.include?("Wire")
  end


  def add_to_setup(*args)
    if args
       args.each do |arg|
         $add_to_setup << arg
       end
     end
  end


  def plugin_directives(*args)
    if args
       args.each do |arg|
         $plugin_directives << arg
       end
     end
  end


  def external_variables(*args)
    if args
       args.each do |arg|
         puts self.class
         puts "\tadding plugin external variables: #{arg}"
         # colons aptional
         colon  = arg[arg.length - 1, 1] == ";"  ? '' : ';' 
         $plugin_external_variables << "#{arg}#{colon}"
       end
     end
  end
  
  def add_blink_m_struct
    $plugin_structs[:blink_m] = <<-STR
    typedef struct _blinkm_script_line {
        uint8_t dur;
        uint8_t cmd[4];    // cmd,arg1,arg2,arg3
    } blinkm_script_line;
    STR
  end
  
  def self.add_blink_m_struct
    $plugin_structs[:blink_m] = <<-STR
    typedef struct _blinkm_script_line {
        uint8_t dur;
        uint8_t cmd[4];    // cmd,arg1,arg2,arg3
    } blinkm_script_line;
    STR
  end
  
  def add_debounce_struct
    $plugin_structs[:debounce] = <<-STR
    struct debounce {
      int state;
      int read;
      int prev;
      unsigned long time;
      unsigned long adjust;
    };
    STR
  end
  
  
  def add_servo_struct 
    $plugin_structs[:servo] = <<-STR
    struct servo {
      int pin;
      long unsigned pulseWidth;
      long unsigned lastPulse;
      long unsigned startPulse;
      long unsigned refreshTime;
      int min;
      int max;
    };
    STR
  end
  
  def self.add_debounce_struct
    $plugin_structs[:debounce] = <<-STR
    struct debounce {
      int state;
      int read;
      int prev;
      unsigned long time;
      unsigned long adjust;
    };
    STR
  end
  
  
  def self.add_servo_struct
    $plugin_structs[:servo] = <<-STR
    struct servo {
      int pin;
      long unsigned pulseWidth;
      long unsigned lastPulse;
      long unsigned startPulse;
      long unsigned refreshTime;
      int min;
      int max;
    };
    STR
  end
  
  def self.add_sensor_struct
    $plugin_structs[:sensor] = <<-STR
    struct hysteresis {
      int pin;
      int state;
    };
    STR
  end
  
  def self.add_spectra_struct
    $plugin_structs[:spectra] = <<-STR
    struct spectra {
      int pin;
      int state;
      int r1;
      int r2;
      int r3;
    };
    STR
  end
  

  def self.check_for_plugin_use(sketch_string, plugin_string, file_name) # rename klass to filename
    $plugin_structs = $plugin_structs || {}
    $plugin_methods_hash = $plugin_methods_hash || {}  
    $plugins_to_load = $plugins_to_load || []  
    plugin_signatures = []
    plugin_methods = []
    ## need a test for this
    ## fails on string interpolation, but since ruby_to_c also currently fails ...
    sketch_string = sketch_string.gsub(/#(?!\{.*\}).*/, "")
    plugin_signatures << plugin_string.scan(/^\s*(((#{PLUGIN_C_VAR_TYPES})\s*)+\w*\(.*\))/)
    # gather just the method name and then add to #plugin_methods_hash
    plugin_signatures[0].map {|sig| "#{sig[0]}"}.each {|m| plugin_methods << m.gsub!(/^.*\s(\w*)\(.*\)/, '\1')}
    # we don't know the methods yet, so... 
    $plugin_methods_hash[file_name] = plugin_methods
    $plugin_methods_hash.each do |k,meths|
      meths.each do |meth|
        if sketch_string.include?(meth)
           # load this plugin... 
           $plugins_to_load << k unless $plugins_to_load.include?(k)
         end
      end
    end

  end


  def self.process(plugin_string)
    plugin_signatures = []
    first_process = plugin_string 
    # todo: need to add plugin names to the methods, so we can add them as comments in the c code
    # gather the c methods
    $plugin_methods << first_process.scan(/^\s*(((#{PLUGIN_C_VAR_TYPES}).*\)).*(\n.*)*^\s*\})/)
    plugin_signatures << first_process.scan(/^\s((#{PLUGIN_C_VAR_TYPES}).*\(.*\))/)
    $plugin_signatures << plugin_signatures[0].map {|sig| "#{sig[0]};"}
    ## strip out the methods and pass it back 
    result = plugin_string
    # strip out the c methods so we have only ruby before eval
    result.gsub(/^\s*(#{PLUGIN_C_VAR_TYPES}).*(\n.*)*^\s*\}/, ""  )
    
  end
  
  private
  
  def add_struct(struct)
    
    
  end
    
end