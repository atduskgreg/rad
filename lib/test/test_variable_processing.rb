#!/usr/local/bin/ruby -w

$TESTING = true

# need to tell it where we are

require 'vendor/rad/variable_processing'
require 'vendor/rad/arduino_sketch'
require 'test/unit'



class TestVariableProcessing < Test::Unit::TestCase

  def setup
    @t = ArduinoSketch.new
  end
  
  # question for brian... do we need variable assignment with no value when
  # we have "" and 0
  


  def test_int_as_int
    name = "foo_a"
    value_string = 1
    expected = "int __foo_a = 1;"
    result = @t.pre_process_vars(name, value_string)
    puts result
    assert_equal(expected, result[0])
  end
  
  def test_string_as_int
    name = "foo_b"
    value_string = "1"
    expected = "int __foo_b = 1;"
    result = @t.pre_process_vars(name, value_string)
    puts result
    assert_equal(expected, result[0])
  end
  
  def test_float_as_float
    name = "foo_c"
    value_string = 0.10
    expected = "float __foo_c = 0.1;"
    result = @t.pre_process_vars(name, value_string)
    puts result
    assert_equal(expected, result[0])
  end
  
  def test_string_as_float
    name = "foo_d"
    value_string = "0.10"
    expected = "float __foo_d = 0.1;"
    result = @t.pre_process_vars(name, value_string)
    puts result
    assert_equal(expected, result[0])
  end
  
  def test_byte # would this to return hex
    name = "foo_f"
    value_string = 0x00
    expected = "int __foo_f = 0;"
    result = @t.pre_process_vars(name, value_string)
    puts result
    assert_equal(expected, result[0])
  end
  
  def test_byte_with_string_input
    name = "foo_g"
    value_string = "0x00"
    expected = "byte __foo_g = 0x00;"
    result = @t.pre_process_vars(name, value_string)
    puts result
    assert_equal(expected, result[0])
  end
  
  def test_string
    name = "foo_h"
    value_string = "arduino"
    expected = "char* __foo_h = \"arduino\";"
    result = @t.pre_process_vars(name, value_string)
    puts result
    assert_equal(expected, result[0])
  end
  
  def test_int_with_type
    name = "foo_i"
    value_string = "int"
    expected = "long __foo_i;"
    result = @t.pre_process_vars(name, value_string)
    puts result
    assert_equal(expected, result[0])
  end
  
  def test_odd_name
    name = "bacon_j"
    value_string = "arduino"
    expected = "char* __bacon_j = \"arduino\";"
    result = @t.pre_process_vars(name, value_string)
    puts result
    assert_equal(expected, result[0])
  end
  
  

  
end
