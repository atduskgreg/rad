require 'erb'
require 'yaml'

class Makefile
  class << self
    
    # build the sketch Makefile for the given template based on the values in its software and hardware config files
    def compose_for_sketch(sketch_name)
      params = hardware_params.merge software_params
      params['target'] = sketch_name.split("/").last
      
      params['libraries_root'] = "#{File.expand_path(RAD_ROOT)}/vendor/libraries"
      params['libraries'] = $load_libraries # load only libraries used 
      
      params['asm_files'] = Dir.entries( File.expand_path(RAD_ROOT) + "/" + PROJECT_DIR_NAME ).select{|e| e =~ /\.S/}            
            
      e = ERB.new File.read("#{File.dirname(__FILE__)}/makefile.erb")
      
      File.open("#{RAD_ROOT}/#{sketch_name}/Makefile", "w") do |f|
        f << e.result(binding)
      end
    end
    
    # def libraries
    #   Dir.entries("#{RAD_ROOT}/vendor/libraries").select{|e| !(e =~ /\./)}
    # end
    
    def hardware_params
      return @hardware_params if @hardware_params
      return @hardware_params = YAML.load_file( "#{RAD_ROOT}/config/hardware.yml")
    end
      
    def software_params
      return @software_params if @software_params
      return @software_params = YAML.load_file( "#{RAD_ROOT}/config/software.yml" )
    end
      
  end
end