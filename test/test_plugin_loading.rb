#!/usr/local/bin/ruby -w

$TESTING = true

# this is a test stub for now
# lets review these
# neee to remove this constant from tests and pull it from rad
PLUGIN_C_VAR_TYPES = "int|void|unsigned|long|short|uint8_t|static|char\\*|byte"

require "rubygems"
require "#{File.expand_path(File.dirname(__FILE__))}/../lib/rad/rad_processor.rb"
require "#{File.expand_path(File.dirname(__FILE__))}/../lib/rad/rad_rewriter.rb"
require "#{File.expand_path(File.dirname(__FILE__))}/../lib/rad/rad_type_checker.rb"
require "#{File.expand_path(File.dirname(__FILE__))}/../lib/rad/variable_processing"
require "#{File.expand_path(File.dirname(__FILE__))}/../lib/rad/arduino_sketch"
require "#{File.expand_path(File.dirname(__FILE__))}/../lib/rad/arduino_plugin"
require 'test/unit'




class TestPluginLoading < Test::Unit::TestCase

  


  def setup
    $external_var_identifiers = ["__foo", "__toggle", "wiggle"]   
    $define_types = { "KOOL" => "long", "ZAK" => "str"}
    $array_types = { "my_array" => "int"}  
    $plugin_directives = []
    $plugin_external_variables = []
    $plugin_signatures =[]
    $plugin_methods = []
    $add_to_setup = []
    $load_libraries = []
    $plugin_structs = {}
    $plugin_methods_hash = {}  
    $plugins_to_load = []  
    plugin_signatures = []
    plugin_methods = []
     
    @plugin_string =<<-STR
    class PluginTesting < ArduinoPlugin



     #
     #
     #  BlinkM_funcs.h -- Arduino library to control BlinkM
     #  --------------
     #
     #
     #  Note: original version of this file lives with the BlinkMTester sketch
     #
     #  2007, Tod E. Kurt, ThingM, http://thingm.com/
     #
     #  version: 20080203
     #
     #  history:
     #   20080101 - initial release
     #   20080203 - added setStartupParam(), bugfix receiveBytes() from Dan Julio
     #	20080727 - ported to rad jd barnhart
     #
     #   first step, declare output pin 19 as i2c
     ##  output_pin 19, :as => :wire, :device => :i2c, :enable => :true # reminder, true issues wire.begin


     include_wire

     add_blink_m_struct



     # Not needed when pin is declared with :enable => :true 

     static int BlinkM_sendBack(byte addr)
     {
       int num = 0x11;
       char buf[5];
       itoa(num, buf, 16);
       return "cool"
     }
 
     static char* another_method(byte addr)
     {
       int num = 0x11;
       char buf[5];
       itoa(num, buf, 16);
       return "cool"
     }

    end
    STR

    @sketch_string =<<-STR
    class SanMiquel < ArduinoSketch

     # looking for hints?  check out the examples directory
     # example sketches can be uploaded to your arduino with
     # rake make:upload sketch=examples/hello_world
     # just replace hello_world with other examples

       def loop
         delay 100
         my_lcd.home "k"
         my_lcd.setxy 0,1

         BlinkM_sendBack 10
         delay 1000
         test_address
       end


    end

    STR
    
  end
  
  # remove these external variables and parens on variables
  # need to actually run code through ruby_to_c for some of these tests
  
  def test_int
    name = "foo_a"
    # check_for_plugin_use(sketch_string, plugin_string, file_name)
    ArduinoPlugin.check_for_plugin_use(@sketch_string, @plugin_string, "hello_plugins")
    value_string = "int(__toggle = 0);"
    expected =  ["hello_plugins"]
    result = $plugins_to_load
    assert_equal(expected, result)
  end
  
  def test_two
    name = "foo_a"
    # check_for_plugin_use(sketch_string, plugin_string, file_name)
    ArduinoPlugin.check_for_plugin_use(@sketch_string, @plugin_string, "hello_plugins")
    value_string = "int(__toggle = 0);"
    expected = {"hello_plugins"=>["BlinkM_sendBack", "another_method"]}
    result = $plugin_methods_hash
    assert_equal(expected, result)
  end
  
  
  
  ## need to look at unsigned long 
  ## need parens removal tests
  


end