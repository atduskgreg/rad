# TODO:
#   compilation
#   gather pieces of code we need as strings
#   translate non-loop methods
#   do plugin stuff
#   deal with examples/ exception
#   manage upload process
#   from arduino_sketch.rb: compose_setup

class SketchCompiler
  attr_accessor :path, :body, :sketch_class
  
  def initialize path_to_sketch
    @path = File.expand_path(path_to_sketch)
    @body = open(@path).read
    @sketch_name = @path.split("/").last
    @sketch_class = @sketch_name.split(".").first.split("_").collect{|c| c.capitalize}.join("")     
  end
  

  
end