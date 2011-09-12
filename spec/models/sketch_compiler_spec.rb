require File.dirname(__FILE__) + '/spec_helper.rb'
require File.expand_path(File.dirname(__FILE__) + "/../../lib/rad/sketch_compiler.rb")

describe SketchCompiler do
  describe "#sketch_methods" do
    before(:each) do
      @as = File.expand_path(File.dirname(__FILE__)) + "/../../lib/examples/i2c_with_clock_chip.rb"
      @sc = SketchCompiler.new @as
    end
  
    it "should locate all the methods defined in the sketch" do
      @sc.sketch_methods.should include( "loop")
      @sc.sketch_methods.should include( "printlz")
      @sc.sketch_methods.should include( "print_hexbyte")
      @sc.sketch_methods.should include( "clear_bottom_line")
    end
  end

  describe "#process_constants" do
    before(:each) do
      @as = File.expand_path(File.dirname(__FILE__)) + "/../../lib/examples/external_variable_fu.rb"
      @sc = SketchCompiler.new @as
    end
  
    it "should correctly process constants" do
      @sc.process_constants
      @sc.body.should_not match(/HIGH/)
      @sc.body.should_not match(/LOW/)
      @sc.body.should_not match(/ON/)
      @sc.body.should_not match(/OFF/)
    end
  end

  describe "#new" do
    before(:each) do
      @as = File.expand_path(File.dirname(__FILE__) + "/../../lib/examples/add_hysteresis.rb")
    end
    it "should correctly absolutize a path with /../ that starts at /" do
      SketchCompiler.new(@as).path.should ==  @as
    end
  
    it "should correct absolutize a relative path" do
      SketchCompiler.new("lib/examples/add_hysteresis.rb").path.should == @as
    end
  
    it "should load the body of the sketch" do
      sc = SketchCompiler.new @as
      sc.body.should == open(@as).read
    end
    
  end

  describe "#sketch_class" do
    before(:each) do
      @sc = SketchCompiler.new File.expand_path(File.dirname(__FILE__)) + "/../../lib/examples/add_hysteresis.rb"
    end
    it "should calculate correctly from the path" do
      @sc.klass.should == "AddHysteresis"
    end
  end

  describe "#create_build_dir! without a path prefix" do
    before(:each) do
      @sc = SketchCompiler.new("lib/examples/add_hysteresis.rb")
    end
    it "should create the sketch dir in the correct place" do
      expected_dir_path = File.expand_path(File.dirname(__FILE__) + "/../../lib/examples/add_hysteresis")
      @sc.should_receive( :mkdir_p ).with(expected_dir_path)
      @sc.create_build_dir!
    end
  end

  describe "#create_build_dir! with a path prefix" do
    before(:each) do
      @sc = SketchCompiler.new("lib/examples/add_hysteresis.rb")
    end
    it "should create the sketch dir in the correct place" do
      @sc.should_receive( :mkdir_p ).with( "prefix/add_hysteresis" )
      @sc.create_build_dir! "prefix"
    end
  end

  describe "#build_dir" do
    before(:each) do
      @sc = SketchCompiler.new("lib/examples/add_hysteresis.rb")
    end
  
  
    it "should be correct with a default target_dir" do
      expected_dir_path = File.expand_path(File.dirname(__FILE__) + "/../../lib/examples/add_hysteresis")
      @sc.build_dir.should == expected_dir_path
    end
  
    it "should be correct with an altered target_dir" do
      @sc.target_dir = "examples"
      @sc.build_dir.should == "examples/add_hysteresis"
    end
  end
end
