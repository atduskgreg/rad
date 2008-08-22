Gem::Specification.new do |s|
  s.name = %q{rad}
  s.version = "0.2.5"
  
  s.date = %q{2008-08-18}
  s.default_executable = %q{rad}
  s.summary = "RAD: Ruby Arduino Development - 0.2.5.1"
  s.email = "greg@grabb.it"
  s.executables = ["rad"]
  s.homepage = "http://github.com/atduskreg/rad"  
  s.description = "Ruby Arduino Development: a framework for programming the Arduino physcial computing platform using Ruby"
  s.has_rdoc = true
  s.authors = ["Greg Borenstein", "plugins+: JD Barnhart"]
  s.files = ["History.txt", "License.txt", "Manifest.txt", "README.rdoc", "Rakefile", "bin/rad", "lib/examples/add_hysteresis.rb", "lib/examples/blink_m_address_assignment.rb", "lib/examples/blink_m_hello.rb", "lib/examples/blink_m_multi.rb", "lib/examples/configure_pa_lcd_boot.rb", "lib/examples/debounce_methods.rb", "lib/examples/external_variable_fu.rb", "lib/examples/external_variables.rb", "lib/examples/first_sound.rb", "lib/examples/frequency_generator.rb", "lib/examples/hello_array.rb", "lib/examples/hello_array2.rb", "lib/examples/hello_array_eeprom.rb", "lib/examples/hello_eeprom.rb", "lib/examples/hello_eeprom_lcdpa.rb", "lib/examples/hello_lcd_charset.rb", "lib/examples/hello_pa_lcd.rb", "lib/examples/hello_servos.rb", "lib/examples/hello_world.rb", "lib/examples/hysteresis_duel.rb", "lib/examples/i2c_with_clock_chip.rb", "lib/examples/motor_knob.rb", "lib/examples/orig_servo_throttle.rb", "lib/examples/servo_buttons.rb", "lib/examples/servo_calibrate_continuous.rb", "lib/examples/servo_throttle.rb", "lib/examples/sparkfun_lcd.rb", "lib/examples/spectra_soft_pot.rb", "lib/examples/times_method.rb", "lib/examples/toggle.rb", "lib/examples/two_wire.rb", "lib/libraries/DS1307/DS1307.cpp", "lib/libraries/DS1307/DS1307.h", "lib/libraries/DS1307/keywords.txt", "lib/libraries/FrequencyTimer2/FrequencyTimer2.cpp", "lib/libraries/FrequencyTimer2/FrequencyTimer2.h", "lib/libraries/FrequencyTimer2/keywords.txt", "lib/libraries/OneWire/OneWire.cpp", "lib/libraries/OneWire/OneWire.h", "lib/libraries/OneWire/keywords.txt", "lib/libraries/OneWire/readme.txt", "lib/libraries/SWSerLCDpa/SWSerLCDpa.cpp", "lib/libraries/SWSerLCDpa/SWSerLCDpa.h", "lib/libraries/SWSerLCDsf/SWSerLCDsf.cpp", "lib/libraries/SWSerLCDsf/SWSerLCDsf.h", "lib/libraries/Servo/Servo.cpp", "lib/libraries/Servo/Servo.h", "lib/libraries/Stepper/Stepper.cpp", "lib/libraries/Stepper/Stepper.h", "lib/libraries/Stepper/keywords.txt", "lib/libraries/Wire/Wire.cpp", "lib/libraries/Wire/Wire.h", "lib/libraries/Wire/keywords.txt", "lib/libraries/Wire/twi.h", "lib/libraries/Wire/utility/twi.c", "lib/libraries/Wire/utility/twi.h", "lib/plugins/bitwise_ops.rb", "lib/plugins/blink_m.rb", "lib/plugins/debounce.rb", "lib/plugins/debug_output_to_lcd.rb", "lib/plugins/hysteresis.rb", "lib/plugins/input_output_state.rb", "lib/plugins/lcd_padding.rb", "lib/plugins/mem_test.rb", "lib/plugins/servo_pulse.rb", "lib/plugins/servo_setup.rb", "lib/plugins/smoother.rb", "lib/plugins/spark_fun_serial_lcd.rb", "lib/plugins/spectra_symbol.rb", "lib/rad.rb", "lib/rad/arduino_plugin.rb", "lib/rad/arduino_sketch.rb", "lib/rad/generators/makefile/makefile.erb", "lib/rad/generators/makefile/makefile.rb", "lib/rad/init.rb", "lib/rad/rad_processor.rb", "lib/rad/rad_rewriter.rb", "lib/rad/rad_type_checker.rb", "lib/rad/sim/arduino_sketch.rb", "lib/rad/tasks/build_and_make.rake", "lib/rad/tasks/rad.rb", "lib/rad/todo.txt", "lib/rad/variable_processing.rb", "lib/rad/version.rb", "scripts/txt2html", "setup.rb", "spec/models/arduino_sketch_spec.rb", "spec/spec.opts", "test/test_array_processing.rb", "test/test_plugin_loading.rb", "test/test_translation_post_processing.rb", "test/test_variable_processing.rb", "website/index.html", "website/index.txt", "website/javascripts/rounded_corners_lite.inc.js", "website/stylesheets/screen.css", "website/template.rhtml", "website/examples/assembler_test.rb.html", "website/examples/gps_reader.rb.html", "website/examples/hello_world.rb.html", "website/examples/serial_motor.rb.html"]
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