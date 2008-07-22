def run_tests(sketch, type)
  sh %{rake make:#{type} sketch=#{RAD_ROOT}/lib/examples/#{sketch}}
end

namespace :test do
  
  desc "run the framework unit tests"
  task :units do
    FileList['test/test_*.rb'].each do |test|
      sh %{ ruby #{RAD_ROOT}/#{test} }
    end
  end
  
  
  desc "iterate through all the sketches in the example directory"
  task :upload => :gather do 
    @examples.each {|e| run_tests(e, "upload")}
  end
  
  desc "compile all examples to test the framework"
  task :compile => :gather do 
    @examples.each {|e| run_tests(e, "compile")}
    end
  end
  
  desc "gather all tests"
  task :gather do # => "make:upload" do
    @examples = []
    @test_results = []
    Dir.entries( File.expand_path("#{RAD_ROOT}/lib/examples") ).each do |f|
      if (f =~ /\.rb$/)
        @examples << f.split('.').first
      end
  end

end