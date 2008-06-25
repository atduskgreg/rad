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
  $plugin_structs = $plugin_structs || {}
  $plugin_signatures = $plugin_signatures || []
  $plugin_methods = $plugin_methods || []
  $add_to_setup = $add_to_setup || []


end
  
# c declarations are automatic
# you won't need them in the plugins
# so, the first thing we can do is gather all the plugin methods, and scan the 
# sketch available plugins...
# if the sketch has them, we include the plugins in the build...
# otherwise not..


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
  
  def add_debounce_struct
    $plugin_structs[:debounce] = <<-STR
    struct debounce {
      int pin;
      int state;
      int read;
      int prev;
      int time;
      unsigned long adjust;
    };
    STR
  end
  
  
  def add_servo_struct 
    $plugin_structs[:servo] = <<-STR
    struct servo {
      int pin;
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
      int pin;
      int state;
      int read;
      int prev;
      int time;
      unsigned long adjust;
    };
    STR
  end
  
  
  def self.add_servo_struct
    $plugin_structs[:servo] = <<-STR
    struct servo {
      int pin;
      long unsigned lastPulse;
      long unsigned startPulse;
      long unsigned refreshTime;
      int min;
      int max;
    };
    STR
  end


  def self.process(plugin_string)
    plugin_signatures = []
    first_process = plugin_string 
    # todo: need to add plugin names to the methods, so we can add them as comments in the c code
    # gather the c methods
    $plugin_methods << first_process.scan(/^\s*(((int|void|unsigned|long|short).*\)).*(\n.*)*^\s*\})/)
    plugin_signatures << first_process.scan(/^\s((int|void|unsigned|long|short).*\(.*\))/)
    $plugin_signatures << plugin_signatures[0].map {|sig| "#{sig[0]};"}
    ## strip out the methods and pass it back 
    result = plugin_string
    # strip out the c methods so we have only ruby before eval
    result.gsub(/^\s*(int|void|unsigned|long|short).*(\n.*)*^\s*\}/, ""  )
    
  end
  
  private
  
  def add_struct(struct)
    
    
  end
    
end