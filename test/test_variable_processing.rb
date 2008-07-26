#!/usr/local/bin/ruby -w

$TESTING = true

# need to tell it where we are
# lets review these
# neee to remove this constant from tests and pull it from rad
C_VAR_TYPES = "unsigned|int|long|double|str|char|byte|float|bool"
require "#{File.expand_path(File.dirname(__FILE__))}/../lib/rad/variable_processing"
require "#{File.expand_path(File.dirname(__FILE__))}/../lib/rad/arduino_sketch"
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
    assert_equal(expected, result[0])
  end
  
  def test_string_as_int
    name = "foo_b"
    value_string = "1"
    expected = "int __foo_b = 1;"
    result = @t.pre_process_vars(name, value_string)
    assert_equal(expected, result[0])
  end
  
  def test_float_as_float
    name = "foo_c"
    value_string = 0.10
    expected = "float __foo_c = 0.1;"
    result = @t.pre_process_vars(name, value_string)
    assert_equal(expected, result[0])
  end
  
  def test_string_as_float
    name = "foo_d"
    value_string = "0.10"
    expected = "float __foo_d = 0.1;"
    result = @t.pre_process_vars(name, value_string)
    assert_equal(expected, result[0])
  end
  
  def test_byte # would this to return hex
    name = "foo_f"
    value_string = 0x00
    expected = "int __foo_f = 0;"
    result = @t.pre_process_vars(name, value_string)
    assert_equal(expected, result[0])
  end
  
  def test_byte_with_string_input
    name = "foo_g"
    value_string = "0x00"
    expected = "byte __foo_g = 0x00;"
    result = @t.pre_process_vars(name, value_string)
    assert_equal(expected, result[0])
  end
  
  def test_string
    name = "foo_h"
    value_string = "arduino"
    expected = "char* __foo_h = \"arduino\";"
    result = @t.pre_process_vars(name, value_string)
    assert_equal(expected, result[0])
  end
  
  def test_int_with_type
    name = "foo_i"
    value_string = "int"
    expected = "int __foo_i;"
    result = @t.pre_process_vars(name, value_string)
    assert_equal(expected, result[0])
  end
  
  def test_odd_name
    name = "bacon_j"
    value_string = "arduino"
    expected = "char* __bacon_j = \"arduino\";"
    result = @t.pre_process_vars(name, value_string)
    assert_equal(expected, result[0])
  end
  
  def test_int_with_type_two
    name = "foo_k"
    value_string = "2, int"
    expected = "int __foo_k = 2;"
    result = @t.pre_process_vars(name, value_string)
    assert_equal(expected, result[0])
  end
  
  def test_int_with_long
    name = "foo_l"
    value_string = "2, int"
    expected = "int __foo_l = 2;"
    result = @t.pre_process_vars(name, value_string)
    assert_equal(expected, result[0])
  end
  
  def test_int_with_byte
    name = "foo_m"
    value_string = "2, byte"
    expected = "byte __foo_m = 2;"
    result = @t.pre_process_vars(name, value_string)
    assert_equal(expected, result[0])
  end
  
  def test_int_with_unsigned_int
    name = "foo_n"
    value_string = "2, unsigned int"
    expected = "unsigned int __foo_n = 2;"
    result = @t.pre_process_vars(name, value_string)
    assert_equal(expected, result[0])
  end
  
  def test_int_with_unsigned_long
    name = "foo_o"
    value_string = "2, unsigned long"
    expected = "unsigned long __foo_o = 2;"
    result = @t.pre_process_vars(name, value_string)
    assert_equal(expected, result[0])
  end
  
  def test_int_with_short_int
    name = "foo_q"
    value_string = "2, short int"
    expected = "short int __foo_q = 2;"
    result = @t.pre_process_vars(name, value_string)
    assert_equal(expected, result[0])
  end
  
  def test_int_with_unsigned_short_int
    name = "foo_r"
    value_string = "2, unsigned short int"
    expected = "unsigned short int __foo_r = 2;"
    result = @t.pre_process_vars(name, value_string)
    assert_equal(expected, result[0])
  end
  
  def test_float_with_type
    name = "foo_s"
    value_string = "2.0, float"
    expected = "float __foo_s = 2.0;"
    result = @t.pre_process_vars(name, value_string)
    assert_equal(expected, result[0])
  end
  
  def test_true
    name = "foo_t"
    value_string = true
    expected = "bool __foo_t = 1;"
    result = @t.pre_process_vars(name, value_string)
    assert_equal(expected, result[0])
  end
  
  def test_false
    name = "foo_v"
    value_string = false
    expected = "bool __foo_v = 0;"
    result = @t.pre_process_vars(name, value_string)
    assert_equal(expected, result[0])
  end
  
  def test_negative_int_string
    name = "foo_w"
    value_string = "-1, int"
    expected = "int __foo_w = -1;"
    result = @t.pre_process_vars(name, value_string)
    assert_equal(expected, result[0])
  end
  
  def test_negative_float_string
    name = "foo_x"
    value_string = "-0.1, float"
    expected = "float __foo_x = -0.1;"
    result = @t.pre_process_vars(name, value_string)
    assert_equal(expected, result[0])
  end
  
  def test_negative_larger_float_string
    name = "foo_y"
    value_string = "-1000.01, float"
    expected = "float __foo_y = -1000.01;"
    result = @t.pre_process_vars(name, value_string)
    assert_equal(expected, result[0])
  end
  
  def test_negative_long_string
    name = "foo_z"
    value_string = "-.0991, float"
    expected = "float __foo_z = -0.0991;"
    result = @t.pre_process_vars(name, value_string)
    assert_equal(expected, result[0])
  end
  
  def test_negative_float_string_two
    name = "foo_aa"
    value_string = "-.01, float"
    expected = "float __foo_aa = -0.01;"
    result = @t.pre_process_vars(name, value_string)
    assert_equal(expected, result[0])
  end
  
  def test_negative_interter_string
    name = "foo_bb"
    value_string = "-.01, float"
    expected = "float __foo_bb = -0.01;"
    result = @t.pre_process_vars(name, value_string)
    assert_equal(expected, result[0])
  end
  
  def test_dash_string
    name = "foo_cc"
    value_string = "-hmmm"
    expected = "char* __foo_cc = \"-hmmm\";"
    result = @t.pre_process_vars(name, value_string)
    assert_equal(expected, result[0])
  end
  
  
  

  
end
