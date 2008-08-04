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
    @sc.klass.should == "AddHysteresis"
  end
end

context "SketchCompiler#create_build_dir! without a path prefix" do
  before do
    @sc = SketchCompiler.new("lib/examples/add_hysteresis.rb")
  end
  it "should create the sketch dir in the correct place" do
    @sc.should_receive( :mkdir_p ).with( "/Users/greg/code/rad/lib/examples/add_hysteresis" )
    @sc.create_build_dir!
  end
end

context "SketchCompiler#create_build_dir! with a path prefix" do
  before do
    @sc = SketchCompiler.new("lib/examples/add_hysteresis.rb")
  end
  it "should create the sketch dir in the correct place" do
    @sc.should_receive( :mkdir_p ).with( "prefix/add_hysteresis" )
    @sc.create_build_dir! "prefix"
  end
end

context "SketchCompiler#build_dir" do
  before do
    @sc = SketchCompiler.new("lib/examples/add_hysteresis.rb")
  end
  
  
  it "should be correct with a default target_dir" do
    @sc.build_dir.should == "/Users/greg/code/rad/lib/examples/add_hysteresis"
  end
  
  it "should be correct with an altered target_dir" do
    @sc.target_dir = "examples"
    @sc.build_dir.should == "examples/add_hysteresis"
  end
  
end
