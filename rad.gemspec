Gem::Specification.new do |s|
  s.name = %q{rad}
  s.version = "0.2.2"
  
  s.date = %q{2008-06-25}
  s.default_executable = %q{rad}
  s.summary = "Fork of the Ruby Arduino Development - 0.2.4.3"
  s.email = "jd@jdbarnhart.com"
  s.executables = ["rad"]
  s.homepage = "http://github.com/madrona/rad"
  s.description = "Ruby Arduino Development: a framework for programming the Arduino physcial computing platform using Ruby"
  s.has_rdoc = true
  s.authors = ["Greg Borenstein", "plugins+: JD Barnhart"]
  s.files = ["History.txt", "License.txt", "Manifest.txt",
  "README.rdoc", "Rakefile", "bin/rad", "lib/libraries/Servo/keywords.txt", "lib/libraries/Servo/Servo.cpp", "lib/libraries/Servo/Servo.h", "lib/libraries/SWSerLCDpa/SWSerLCDpa.cpp", "lib/libraries/SWSerLCDpa/SWSerLCDpa.h", "lib/libraries/SWSerLCDsf/SWSerLCDsf.cpp", "lib/libraries/SWSerLCDsf/SWSerLCDsf.h", "lib/plugins/debounce.rb", "lib/plugins/debug_output_to_lcd.rb", "lib/plugins/input_output_state.rb", "lib/plugins/mem_test.rb", "lib/plugins/servo_pulse.rb", "lib/plugins/servo_setup.rb", "lib/plugins/smoother.rb", "lib/plugins/spark_fun_serial_lcd.rb", "lib/rad.rb", "lib/rad/arduino_sketch.rb", "lib/rad/arduino_plugin.rb", "lib/rad/init.rb", "lib/rad/todo.txt", "lib/rad/tasks/build_and_make.rake", "lib/rad/tasks/rad.rb", "lib/rad/version.rb", "lib/rad/generators/makefile/makefile.erb", "lib/rad/generators/makefile/makefile.rb", "scripts/txt2html", "setup.rb", "spec/models/spec_helper.rb", "spec/models/arduino_sketch_spec.rb", "spec/spec.opts", "website/index.html", "website/index.txt", "website/javascripts/rounded_corners_lite.inc.js", "website/stylesheets/screen.css", "website/template.rhtml", "website/examples/assembler_test.rb.html", "website/examples/gps_reader.rb.html", "website/examples/hello_world.rb.html", "website/examples/serial_motor.rb.html"]
  s.test_files = []
  s.rdoc_options = ["--main", "README.rdoc"]
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{rad}
  s.rubygems_version = %q{1.2.0}
  s.extra_rdoc_files = ["History.txt", "Manifest.txt", "README.rdoc"]
  s.add_dependency("mime-types", ["> 0.0.0"])
  
  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 2

    if current_version >= 3 then
      s.add_runtime_dependency(%q<RubyToC>, [">= 1.0.0"])
    else
      s.add_dependency(%q<RubyToC>, [">= 1.0.0"])
    end
  else
    s.add_dependency(%q<RubyToC>, [">= 1.0.0"])
  end
  
  
end