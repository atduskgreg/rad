require File.dirname(__FILE__) + '/spec_helper.rb'
require File.expand_path(File.dirname(__FILE__) + "/../../lib/rad/sketch_compiler.rb")

context "SketchCompiler.new" do
  before do
    @as = File.expand_path(File.dirname(__FILE__)) + "/../../lib/examples/add_hysteresis.rb"
  end
  it "should correctly absolutize a path with /../ that starts at /" do
    SketchCompiler.new(@as).path.should == "/Users/greg/code/rad/lib/examples/add_hysteresis.rb"
  end
  
  it "should correct absolutize a relative path" do
    SketchCompiler.new("lib/examples/add_hysteresis.rb").path.should == "/Users/greg/code/rad/lib/examples/add_hysteresis.rb"
  end
  
  it "should load the body of the sketch" do
    sc = SketchCompiler.new @as
    sc.body.should == open(@as).read
  end
    
end

context "SketchCompiler#sketch_class" do
  before do
    @sc = SketchCompiler.new File.expand_path(File.dirname(__FILE__)) + "/../../lib/examples/add_hysteresis.rb"
  end
  it "should calculate correctly from the path" do
    @sc.sketch_class.should == "AddHysteresis"
  end
end