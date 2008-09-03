require File.expand_path(File.dirname(__FILE__) + "/../init.rb")
require 'ruby_to_ansi_c'

C_VAR_TYPES = "unsigned|int|long|double|str|char|byte|bool"

# incredibly primitive tests 
# rake test:compile or rake test:upload
# runs through all sketches in the example directory

def run_tests(sketch, type)
  sh %{rake make:#{type} sketch=examples/#{sketch}}
end

namespace :test do
  
  desc "iterate through all the sketches in the example directory"
  task :upload => :gather do 
    @examples.each {|e| run_tests(e, "upload")}
  end
  
  task :compile => :gather do 

    @examples.each {|e| run_tests(e, "compile")}
  end
  
  desc "gather all tests"
  task :gather do # => "make:upload" do
    @examples = []
    if ENV['sketch']
      @examples << ENV['sketch']
    else
      Dir.entries( File.expand_path("#{RAD_ROOT}/examples/") ).each do |f|
        @examples << f.split('.').first if (f =~ /\.rb$/)
      end
    end
  end

end


namespace :make do
  
  desc "compile the sketch and then upload it to your Arduino board"
  task :upload => :compile do
    if Makefile.hardware_params['physical_reset']
      puts "Reset the Arduino and hit enter.\n==If your board doesn't need it, you can turn off this prompt in config/software.yml=="
      STDIN.gets.chomp
    end
    sh %{cd #{@sketch.build_dir}; make upload}
  end
    
  desc "generate a makefile and use it to compile the .cpp"
  task :compile => [:clean_sketch_dir, "build:sketch"] do # should also depend on "build:sketch"
    Makefile.compose_for_sketch( @sketch.build_dir )

    # not allowed? sh %{export PATH=#{Makefile.software_params[:arduino_root]}/tools/avr/bin:$PATH}
    sh %{cd #{@sketch.build_dir}; make depend; make}
  end
  
  desc "generate a makefile and use it to compile the .cpp using the current .cpp file"
  task :compile_cpp => ["build:sketch_dir", "build:gather_required_plugins", "build:plugin_setup", "build:setup", :clean_sketch_dir] do # should also depend on "build:sketch"
    Makefile.compose_for_sketch( @sketch.build_dir )
    # not allowed? sh %{export PATH=#{Makefile.software_params[:arduino_root]}/tools/avr/bin:$PATH}
    sh %{cd #{@sketch.build_dir}; make depend; make}
  end
  
  desc "generate a makefile and use it to compile the .cpp and upload it using current .cpp file"
  task :upload_cpp => ["build:sketch_dir", "build:gather_required_plugins", "build:plugin_setup", "build:setup", :clean_sketch_dir] do # should also depend on "build:sketch"
    Makefile.compose_for_sketch( @sketch.build_dir )
    # not allowed? sh %{export PATH=#{Makefile.software_params[:arduino_root]}/tools/avr/bin:$PATH}
    sh %{cd #{@sketch.build_dir}; make depend; make upload}
  end
  
  task :clean_sketch_dir => ["build:file_list", "build:sketch_dir"] do
    FileList.new(Dir.entries("#{@sketch.build_dir}")).exclude("#{@sketch.name}.cpp").exclude(/^\./).each do |f|
      sh %{rm #{@sketch.build_dir}/#{f}}
    end
  end
  
end

namespace :build do

  desc "actually build the sketch"
  task :sketch => [:file_list, :sketch_dir, :gather_required_plugins, :plugin_setup, :setup] do
    c_methods = []
    sketch_signatures = []
    # until we better understand RubyToC let's see what's happening on errors
    @sketch.sketch_methods.each do |meth|   
      raw_rtc_meth = RADProcessor.translate(constantize(@sketch.klass), meth)
      puts "Translator Error: #{raw_rtc_meth.inspect}" if raw_rtc_meth =~ /\/\/ ERROR:/ 
      c_methods << raw_rtc_meth unless meth == "setup"
      # treat the setup method differently
      @additional_setup = [] if meth == "setup"
      raw_rtc_meth.each {|m| @additional_setup << ArduinoSketch.add_to_setup(m) } if meth == "setup"
    end
    c_methods.each {|meth| sketch_signatures << "#{meth.scan(/^\w*\s?\*?\n.*\)/)[0].gsub("\n", " ")};" }
    clean_c_methods = []
    # remove external variables that were previously injected
    c_methods.join("\n").each { |meth| clean_c_methods << ArduinoSketch.post_process_ruby_to_c_methods(meth) }
    c_methods_with_timer = clean_c_methods.join.gsub(/loop\(\)\s\{/,"loop() {")
    # last chance to add/change setup
    @setup[2] << sketch_signatures.join("\n") unless sketch_signatures.empty?
    # add special setup method to existing setup if present
    if @additional_setup
      @setup[2] << "void additional_setup();" # declaration
      @setup[4] << "\tadditional_setup();" # call from setup 
      @setup[5] << @additional_setup.join("") # 
    end
    result = "#{@setup.join( "\n" )}\n#{c_methods_with_timer}\n"
    File.open("#{@sketch.build_dir}/#{@sketch.name}.cpp", "w"){|f| f << result}
  end

  # needs to write the library include and the method signatures
  desc "build setup function"
  task :setup do
    eval "class #{@sketch.klass} < ArduinoSketch; end;"
    
    @@as = HardwareLibrary.new
    
    delegate_methods = @@as.methods - Object.new.methods
    delegate_methods.reject!{|m| m == "compose_setup"}
        
    delegate_methods.each do |meth|
       constantize(@sketch.klass).module_eval <<-CODE
       def self.#{meth}(*args)
       @@as.#{meth}(*args)
       end
       CODE
    end
    # allow variable declaration without quotes: @foo = int 
    ["long","unsigned","int","byte","short"].each do |type|
      constantize(@sketch.klass).module_eval <<-CODE
       def self.#{type}
        return "#{type}"
       end
       CODE
    end   
    
    @sketch.process_constants
    
    eval ArduinoSketch.pre_process(@sketch.body)
    @@as.process_external_vars(constantize(@sketch.klass))
    @setup = @@as.compose_setup
  end
  
  desc "add plugin methods"
  task :plugin_setup do
    $plugins_to_load.each do |name|
       klass = name.split(".").first.split("_").collect{|c| c.capitalize}.join("")
       eval "class #{klass} < ArduinoPlugin; end;"
    
       @@ps = ArduinoPlugin.new
       plugin_delegate_methods = @@ps.methods - Object.new.methods
       plugin_delegate_methods.reject!{|m| m == "compose_setup"}
    
       plugin_delegate_methods.each do |meth|
         constantize(klass).module_eval <<-CODE
         def self.#{meth}(*args)
           @@ps.#{meth}(*args)
         end
         CODE
       end

      eval ArduinoPlugin.process(File.read("vendor/plugins/#{name}"))
      
    end
    @@no_plugins = ArduinoPlugin.new if @plugin_names.empty?
  end
  
  desc "determine which plugins to load based on use of methods in sketch"
  task :gather_required_plugins do
    @plugin_names.each do |name|
       ArduinoPlugin.check_for_plugin_use(@sketch.body, File.read("vendor/plugins/#{name}"), name )
    end
    puts "#{$plugins_to_load.length} of #{$plugin_methods_hash.length} plugins are being loaded:  #{$plugins_to_load.join(", ")}"
  end
  
  desc "setup target directory named after your sketch class"
  task :sketch_dir => [:file_list] do
    @sketch.create_build_dir!
  end

  task :file_list do
    # take another look at this, since if the root directory name is changed, everything breaks
    # perhaps we generate a constant when the project is generated an pop it here or in the init file
    if ENV['sketch']
      @sketch = SketchCompiler.new File.expand_path("#{ENV['sketch']}.rb")
    else
      # assume the only .rb file in the sketch dir is the sketch:
      @sketch = SketchCompiler.new Dir.glob("#{File.expand_path(File.dirname(__FILE__))}/../../../*.rb").first
    end

    @plugin_names = []
    Dir.entries( File.expand_path("#{RAD_ROOT}/vendor/plugins/") ).each do |f|
      if (f =~ /\.rb$/)
        @plugin_names << f
      end
    end
  end
end

#yoinked from Rails
def constantize(camel_cased_word)
  unless /\A(?:::)?([A-Z]\w*(?:::[A-Z]\w*)*)\z/ =~ camel_cased_word
    raise NameError, "#{camel_cased_word.inspect} is not a valid constant name!"
  end

  Object.module_eval("::#{$1}", __FILE__, __LINE__)
end