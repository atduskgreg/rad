require File.dirname(__FILE__) + '/spec_helper.rb'
require File.expand_path(File.dirname(__FILE__) + "/../../lib/rad/arduino_sketch.rb")

context "Arduino#serial_begin" do
  setup do
    @as = ArduinoSketch.new
  end
  
  specify "should default baud_rate to 9600" do
    @as.serial_begin
    @as.instance_variable_get("@other_setup").should include("Serial.begin(9600);")
  end
  specify "should set an alternate baud_rate if told" do
    @as.serial_begin :rate => 2400
    @as.instance_variable_get("@other_setup").should include("Serial.begin(2400);")
  end
  specify "should add the correct function call to the composed_setup" do
    @as.serial_begin
    @as.compose_setup.should match(Regexp.new(Regexp.escape("Serial.begin(9600);")))
  end
end


context "Arduino Base" do
  setup do
    @as = ArduinoSketch.new
  end
  
  specify "output_pin method without :as arg. should add the pin to the pin_mode hash's output list and leave the declarations alone" do
    @as.output_pin 1
    @as.instance_variable_get("@declarations").first.should == nil
    @as.instance_variable_get("@pin_modes")[:output].should include(1)
  end
  
  specify "output_pin method with :as arg. should add the pin to the pin_mode hash's output list write the appropriate declaration and accessor" do
    @as.output_pin 3, :as => :led
    @as.instance_variable_get("@declarations").first.should == "int _led = 3;"
    @as.instance_variable_get("@accessors").first.should == "int led(){\nreturn _led;\n}"
    @as.instance_variable_get("@pin_modes")[:output].should include(3)
  end
  
  specify "output_pins method should add the pin to the pin_mode hash's output list and leave the declarations and accessors alone" do
    @as.output_pins [5,4,3,2]
    @as.instance_variable_get("@pin_modes")[:output].should include(5)
    @as.instance_variable_get("@pin_modes")[:output].should include(4)
    @as.instance_variable_get("@pin_modes")[:output].should include(3)
    @as.instance_variable_get("@pin_modes")[:output].should include(2)
    @as.instance_variable_get("@declarations").first.should == nil
    @as.instance_variable_get("@accessors").first.should == nil
  end
  
  specify "input_pin method with :as arg. should add the pin to the pin_mode hash's input list write the appropriate declaration and accessor" do
    @as.input_pin 1, :as => :knob
    @as.instance_variable_get("@declarations").first.should == "int _knob = 1;"
    @as.instance_variable_get("@accessors").first.should == "int knob(){\nreturn _knob;\n}"
    @as.instance_variable_get("@pin_modes")[:input].should include(1)
  end
  
  specify "input_pins method should add the pins to the pin_mode hash's input list and leave the declarations and accessors alone" do
    @as.input_pins [5,4,3,2]
    @as.instance_variable_get("@pin_modes")[:input].should include(5)
    @as.instance_variable_get("@pin_modes")[:input].should include(4)
    @as.instance_variable_get("@pin_modes")[:input].should include(3)
    @as.instance_variable_get("@pin_modes")[:input].should include(2)
    @as.instance_variable_get("@declarations").first.should == nil
    @as.instance_variable_get("@accessors").first.should == nil
  end
  
  specify "compose_setup should append each appropriate pinMode statement and :as accessor to the setup_function string with a newline" do
    @as.output_pins [1, 2]
    @as.input_pin 3, :as => :button
    
    result = @as.send :compose_setup
    
    result.should match(Regexp.new(Regexp.escape("pinMode(1, OUTPUT);\n")))
    result.should match(Regexp.new(Regexp.escape("pinMode(2, OUTPUT);\n")))
    result.should match(Regexp.new(Regexp.escape("pinMode(3, INPUT);\n")))
    result.should match(Regexp.new(Regexp.escape("int _button = 3;\n")))
    result.should match(Regexp.new(Regexp.escape("int button(){\nreturn _button;\n}")))
  end
  
end