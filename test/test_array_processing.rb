$TESTING = true

# need to tell it where we are
# lets review these
# neee to remove this constant from tests and pull it from rad
C_VAR_TYPES = "unsigned|int|long|double|str|char|byte|float|bool"
require "#{File.expand_path(File.dirname(__FILE__))}/../lib/rad/variable_processing"
require "#{File.expand_path(File.dirname(__FILE__))}/../lib/rad/arduino_sketch"
require 'test/unit'


class TestArrayProcessing < Test::Unit::TestCase

  def setup
    @t = ArduinoSketch.new
    # vars
  end
  
  # with July 25 2008 rework of arrays, this needs reworking/pruning
  
  def test_int_array
    name = "foo_a"
    value_string = "int tomatoes[]"
    expected = "int tomatoes[];"
    result = @t.array(value_string)
    assert_equal(expected, result[0])
  end
  
  def test_int_array_with_semi
    name = "foo_b"
    value_string = "int tomatoes[];"
    expected = "int tomatoes[];"
    result = @t.array(value_string)
    assert_equal(expected, result[0])
  end
  
  def test_int_array_with_assignment
    name = "foo_c"
    value_string = "int tomatoes[] = {1,2,3,4}"
    expected = "int tomatoes[] = {1,2,3,4};"
    result = @t.array(value_string)
    assert_equal(expected, result[0])
  end
  
  def test_int_array_with_assignment_and_semi
    name = "foo_d"
    value_string = "int tomatoes[] = {1,2,3};"
    expected = "int tomatoes[] = {1,2,3};"
    result = @t.array(value_string)
    assert_equal(expected, result[0])
  end
  
  def test_unsigned_int_array
    name = "foo_e"
    value_string = "unsigned int tomatoes[]"
    expected = "unsigned int tomatoes[];"
    result = @t.array(value_string)
    assert_equal(expected, result[0])
  end
  
  def test_unsigned_int_array_with_assignment
    name = "foo_f"
    value_string = "unsigned int tomatoes[] = {1,2,3};"
    expected = "unsigned int tomatoes[] = {1,2,3};"
    result = @t.array(value_string)
    assert_equal(expected, result[0])
  end
  
  ### adding defines
  
  def test_define_numbers
    name = "foo_g"
    value_string = "NUMBERS 10"
    expected = "#define NUMBERS 10"
    result = @t.define(value_string)
    assert_equal(expected, result[0])
  end
  
  def test_define_numbers_type
    name = "foo_gg"
    value_string = "NUMBERS 10"
    expected = "long"
    result = @t.define(value_string)
    assert_equal(expected, result[1])
  end
  
  def test_define_value_type_long_via_gvar
    name = "foo_ggg"
    value_string = "NUMBERS 10"
    expected = "long"
    result = @t.define(value_string)
    assert_equal(expected, $define_types["NUMBERS"])
  end
  
  def test_define_string
    name = "foo_h"
    value_string = "TEXT word"
    expected = "#define TEXT \"word\""
    result = @t.define(value_string)
    assert_equal(expected, result[0])
  end
  
  def test_define_string_type
     name = "foo_hh"
     value_string = "TEXT word"
     expected = "str"
     result = @t.define(value_string)
     assert_equal(expected, result[1])
   end
   
   def test_define_string_type__via_gvar
     name = "foo_hhh"
     value_string = "TEXT word"
     expected = "str"
     result = @t.define(value_string)
     assert_equal(expected, $define_types["TEXT"])
   end
  
  def test_define_stings_with_spaces
    name = "foo_i"
    value_string = "TEXT words with spaces"
    expected = "#define TEXT \"words with spaces\""
    result = @t.define(value_string)
    assert_equal(expected, result[0])
  end
  
  def test_define_stings_with_spaces_type
    name = "foo_ii"
    value_string = "TEXT words with spaces"
    expected = "str"
    result = @t.define(value_string)
    assert_equal(expected, result[1])
  end
  
  def test_define_stings_with_spaces_type_via_gvar
    name = "foo_iii"
    value_string = "TEXT words with spaces"
    expected = "str"
    result = @t.define(value_string)
    assert_equal(expected, $define_types["TEXT"])
  end
  
  def test_define_float
    name = "foo_j"
    value_string = "FLOAT 10.0"
    expected = "#define FLOAT 10.0"
    result = @t.define(value_string)
    assert_equal(expected, result[0])
  end
  
  def test_define_float_type
    name = "foo_jj"
    value_string = "FLOAT 10.0"
    expected = "float"
    result = @t.define(value_string)
    assert_equal(expected, result[1])
  end

  
  def test_define_float_type_via_gvar
    name = "foo_jjj"
    value_string = "FLOAT 10.0"
    expected = "float"
    result = @t.define(value_string)
    assert_equal(expected, $define_types["FLOAT"])
  end
  
#
  
  
  
  
  
  
  
  
  # question for brian... do we need variable assignment with no value when
  # we have "" and 0
end