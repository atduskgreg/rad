#!/usr/local/bin/ruby -w

$TESTING = true

# this is a test stub for now
# lets review these
# neee to remove this constant from tests and pull it from rad
C_VAR_TYPES = "unsigned|int|long|double|str|char|byte|float|bool"
require "#{File.expand_path(File.dirname(__FILE__))}/../lib/rad/variable_processing"
require "#{File.expand_path(File.dirname(__FILE__))}/../lib/rad/arduino_sketch"
require 'test/unit'



class TestTranslationPostProcessing < Test::Unit::TestCase

  


  def setup
    $external_var_identifiers = ["__foo", "__toggle"]   
  end
  
  # remove these external variables and parens on variables
  # need to actually run code through ruby_to_c for some of these tests
  
  def test_int
    name = "foo_a"
    value_string = "int(__toggle = 0);"
    expected = ""
    result = ArduinoSketch.post_process_ruby_to_c_methods(value_string)
    assert_equal(expected, result)
  end
  
  def test_bool
    name = "foo_a"
    value_string = "bool(__toggle = 0);"
    expected = ""
    result = ArduinoSketch.post_process_ruby_to_c_methods(value_string)
    assert_equal(expected, result)
  end
  
  def test_long
    name = "foo_a"
    value_string = "long(__foo = 0);"
    expected = ""
    result = ArduinoSketch.post_process_ruby_to_c_methods(value_string)
    assert_equal(expected, result)
  end
  
  ## need to look at unsigned long 
  ## need parens removal tests
  


end