#!/usr/local/bin/ruby -w

$TESTING = true

# need to tell it where we are
# lets review these
C_VAR_TYPES = "int|void|unsigned|long|short|uint8_t|static|byte|float"
require 'vendor/rad/variable_processing'
require 'vendor/rad/arduino_sketch'
require 'test/unit'



class TestArrayProcessing < Test::Unit::TestCase

  def setup
    @t = ArduinoSketch.new
    # vars
  end
  
  def test_int_array
    name = "foo_a"
    value_string = 1
    expected = "int tomatoes[];"
    result = @t.array("int tomatoes[]")
    assert_equal(expected, result[0])
  end
  
  def test_int_array_with_semi
    name = "foo_a"
    value_string = 1
    expected = "int tomatoes[];"
    result = @t.array("int tomatoes[];")
    assert_equal(expected, result[0])
  end
  
  def test_int_array_with_assignment
    name = "foo_a"
    value_string = 1
    expected = "int tomatoes[4];"
    result = @t.array("int tomatoes[] = {1,2,3,4}")
    assert_equal(expected, result[0])
  end
  
  def test_int_array_with_assignment_and_semi
    name = "foo_a"
    value_string = 1
    expected = "int tomatoes[3];"
    result = @t.array("int tomatoes[] = {1,2,3};")
    assert_equal(expected, result[0])
  end
  
  def test_unsigned_int_array
    name = "foo_a"
    value_string = 1
    expected = "unsigned int tomatoes[];"
    result = @t.array("unsigned int tomatoes[]")
    assert_equal(expected, result[0])
  end
  
  def test_unsigned_int_array_with_assignment
    name = "foo_a"
    value_string = 1
    expected = "unsigned int tomatoes[3];"
    result = @t.array("unsigned int tomatoes[] = {1,2,3};")
    assert_equal(expected, result[0])
  end
  
  
  
  
  
  
  
  
  # question for brian... do we need variable assignment with no value when
  # we have "" and 0
end