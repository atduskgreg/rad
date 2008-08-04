# TODO:
#   compilation
#   gather pieces of code we need as strings
#   translate non-loop methods
#   do plugin stuff
#   deal with examples/ exception
#   manage upload process
#   compose_setup should move in here entirely

# require 'arduino_sketch'

class SketchCompiler
  attr_accessor :path, :body, :klass, :target_dir, :name
  
  def initialize path_to_sketch 
    @path = File.expand_path(path_to_sketch)
    @body = open(@path).read
    @name = @path.split("/").last.split(".").first
    @klass = @name.split(".").first.split("_").collect{|c| c.capitalize}.join("")     
    @target_dir = parent_dir
  end
  
  def parent_dir
    @path.split("/")[0..@path.split("/").length-2].join("/")
  end
  
  def build_dir
    "#{@target_dir}/#{@name}"
  end

  def create_build_dir! optional_path_prefix=nil
    @target_dir = optional_path_prefix if optional_path_prefix
    mkdir_p build_dir
  end
  
  
end