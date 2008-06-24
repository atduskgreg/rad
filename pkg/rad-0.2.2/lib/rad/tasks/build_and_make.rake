require File.expand_path(File.dirname(__FILE__) + "/../init.rb")
require 'ruby_to_ansi_c'

namespace :make do
  
  desc "compile the sketch and then upload it to your Arduino board"
  task :upload => :compile do
    if Makefile.hardware_params['physical_reset']
      puts "Reset the Arduino and hit enter.\n==If your board doesn't need it, you can turn off this prompt in config/software.yml=="
      STDIN.gets.chomp
    end
    sh %{cd #{RAD_ROOT}/#{@sketch_name}; make upload}
  end
  
  desc "generate a makefile and use it to compile the .cpp"
  task :compile => [:clean_sketch_dir, "build:sketch"] do # should also depend on "build:sketch"
    Makefile.compose_for_sketch( @sketch_name )
    # not allowed? sh %{export PATH=#{Makefile.software_params[:arduino_root]}/tools/avr/bin:$PATH}
    sh %{cd #{RAD_ROOT}/#{@sketch_name}; make depend; make}
  end
  
  task :clean_sketch_dir => ["build:file_list", "build:sketch_dir"] do
    @sketch_name = @file_names.first.split(".").first
    
    FileList.new(Dir.entries("#{RAD_ROOT}/#{@sketch_name}")).exclude("#{@sketch_name}.cpp").exclude(/^\./).each do |f|
      sh %{rm #{RAD_ROOT}/#{@sketch_name}/#{f}}
    end
  end
end

namespace :build do

  desc "actually build the sketch"
  task :sketch => [:file_list, :sketch_dir, :setup] do
    klass = @file_names.first.split(".").first.split("_").collect{|c| c.capitalize}.join("")
    eval ArduinoSketch.pre_process(File.read(@file_names.first))
    @loop = RubyToAnsiC.translate(constantize(klass), "loop")
    result = "#{@setup}\n#{@loop}\n"
    name = @file_names.first.split(".").first
    File.open("#{name}/#{name}.cpp", "w"){|f| f << result}
  end

  # needs to write the library include and the method signatures
  desc "build setup function"
  task :setup do
    klass = @file_names.first.split(".").first.split("_").collect{|c| c.capitalize}.join("")
    eval "class #{klass} < ArduinoSketch; end;"
    
    @@as = ArduinoSketch.new
    
    delegate_methods = @@as.methods - Object.new.methods
    delegate_methods.reject!{|m| m == "compose_setup"}
        
    delegate_methods.each do |meth|
       constantize(klass).module_eval <<-CODE
       def self.#{meth}(*args)
       @@as.#{meth}(*args)
       end
       CODE
    end
    
    eval File.read(@file_names.first)
    @setup = @@as.compose_setup
  end
  
  desc "setup target directory named after your sketch class"
  task :sketch_dir => [:file_list] do
    mkdir_p "#{@file_names.first.split(".").first}"
  end

  task :file_list do
    @file_names = []
    Dir.entries( File.expand_path(RAD_ROOT) ).each do |f|
      if (f =~ /\.rb$/)
        @file_names << f
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