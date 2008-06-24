require File.dirname(__FILE__) + './models/spec_helper.rb'
require File.expand_path(File.dirname(__FILE__) + "/../../lib/rad/sim/arduino_sketch.rb")
require File.expand_path(File.dirname(__FILE__) + "/../examples/hello_world.rb" )

context "ArduinoSketch running HelloWorld example" do
  it "should successfully make an instance" do
    lambda{HelloWorld.new}.should_not raise_error
  end
end

context "HelloWorld#led" do
  it "should return a correctly configured Pin" do
    p = HelloWorld.new.led
    p.type.should == :output
    p.num.should == 7
    p.value.should == false
  end
end

context "HelloWorld#digitalWrite" do
  setup do
    @h = HelloWorld.new
  end 

  it "should set the value of the pin to true if told to" do
    @h.digitalWrite(@h.led, ON)
    @h.led.value.should == true
  end

  it "should set the value of the pin to false if told to" do
    @h.digitalWrite(@h.led, OFF)
    @h.led.value.should == false
  end
end

context "HelloWorld#delay" do
  it "should maybe keep track of the time in some way?"
end

context "HelloWorld#loop" do
  it "should execute the loop in the context of the instance"
end
