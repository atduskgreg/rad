RAD_ROOT = "#{File.dirname(__FILE__)}/../.." unless defined?(RAD_ROOT)

unless defined?(PROJECT_DIR_NAME)
  a = File.expand_path(File.expand_path("#{RAD_ROOT}")).split("/")
  PROJECT_DIR_NAME = a[a.length-1]
end

PLUGIN_C_VAR_TYPES = "int|void|unsigned|long|short|uint8_t|static|byte|char\\*|uint8_t"


%w(generators/makefile/makefile.rb rad_processor.rb rad_rewriter.rb rad_type_checker.rb variable_processing.rb arduino_sketch.rb arduino_plugin.rb hardware_library.rb tasks/rad.rb sketch_compiler.rb).each do |path|
  require File.expand_path("#{RAD_ROOT}/vendor/rad/#{path}")
end

