require 'rubygems'  # >= 1.8.10
require "rubygems/package_task"
require 'fileutils'

RAD_ROOT = File.expand_path(File.dirname(__FILE__))

  

begin
  gem 'rake', '>= 0.9.2'
  require 'rake'
  require 'rake/clean'
  require 'rake/testtask'
  require 'rake/packagetask'
  require 'rake/contrib/rubyforgepublisher'
rescue LoadError
  puts 'To build Rad, you must install the rake gem:'
  puts '$ sudo gem install rake'
  exit
end


begin
  gem 'rdoc', '>= 3.9.4'
  require 'rdoc'
  require 'rdoc/task'
rescue LoadError
  puts 'To use RDoc to produce HTML and command-line documentation, you must install the rdoc gem:'
  puts '$ sudo gem install rdoc'
  exit
end

begin
  gem 'hoe', '>= 2.12.3'
  require 'hoe'
rescue LoadError
  puts 'To use Hoe as a rake/rubygems helper for project Rakefiles, you must install the hoe gem:'
  puts '$ sudo gem install hoe'
  exit
end

begin
  gem 'rspec', '>= 2.6.0'
  require 'rspec'
rescue LoadError
  puts 'To use rspec for testing you must install rspec gem:'
  puts '$ sudo gem install rspec'
  exit
end

begin
  gem 'syntax', '>= 1.0.0'
  require 'Syntax'
rescue LoadError
  puts 'To use Syntax for performing simple syntax highlighting for the website files, you must install the syntax gem:'
  puts '$ sudo gem install syntax'
  exit
end

begin
  require 'RedCloth'
  gem 'RedCloth', '>= 4.2.8'
rescue LoadError
  puts 'To use RedCloth as a Textile parser for the website files, you must install the RedCloth gem:'
  puts '$ sudo gem install RedCloth'
  exit
end

include FileUtils
require File.join(File.dirname(__FILE__), 'lib', 'rad', 'version')

BIN = "rad"
AUTHOR = 'Greg Borenstein'  # can also be an array of Authors
EMAIL = "greg@mfdz.com"
DESCRIPTION = "A framework for programming the Arduino physcial computing platform using Ruby. RAD converts Ruby scripts written using a set of Rails-like conventions and helpers into C source code which can be compiled and run on the Arduino microcontroller."
GEM_NAME = 'rad' # what ppl will type to install your gem

@config_file = "~/.rubyforge/user-config.yml"
@config = nil
def rubyforge_username
  unless @config
    begin
      @config = YAML.load(File.read(File.expand_path(@config_file)))
    rescue
      puts <<-EOS
ERROR: No rubyforge config file found: #{@config_file}"
Run 'rubyforge setup' to prepare your env for access to Rubyforge
 - See http://newgem.rubyforge.org/rubyforge.html for more details
      EOS
      exit
    end
  end
  @rubyforge_username ||= @config["username"]
end

RUBYFORGE_PROJECT = 'rad' # The unix name for your project
HOMEPATH = "http://#{RUBYFORGE_PROJECT}.rubyforge.org"
DOWNLOAD_PATH = "http://rubyforge.org/projects/#{RUBYFORGE_PROJECT}"

NAME = "rad"
REV = nil 
# UNCOMMENT IF REQUIRED: 
# REV = `svn info`.each {|line| if line =~ /^Revision:/ then k,v = line.split(': '); break v.chomp; else next; end} rescue nil
VERS = Rad::VERSION::STRING + (REV ? ".#{REV}" : "")
CLEAN.include ['**/.*.sw?', '*.gem', '.config', '**/.DS_Store']
RDOC_OPTS = ['--quiet', '--title', 'rad documentation',
    "--opname", "index.html",
    "--line-numbers", 
    "--main", "README",
    "--inline-source"]

class Hoe
  def extra_deps 
    @extra_deps.reject { |x| Array(x).first == 'hoe' } 
  end 
end

# Generate all the Rake tasks
# Run 'rake -T' to see list of generated tasks (from gem root directory)
hoe = Hoe.spec(GEM_NAME) do |p|
  p.author = AUTHOR 
  p.description = DESCRIPTION
  p.email = EMAIL
  p.summary = DESCRIPTION
  p.url = HOMEPATH
  p.rubyforge_name = RUBYFORGE_PROJECT if RUBYFORGE_PROJECT
  p.test_globs = ["test/**/test_*.rb"]
  p.version = VERS
  p.clean_globs |= CLEAN  #An array of file patterns to delete on clean.
  
  # == Optional
  p.changes = p.paragraphs_of("History.txt", 0..1).join("\n\n")  
  p.extra_deps =  [ ['RubyToC', '>= 1.0.0'] ]
  #p.spec_extras = {}    # A hash of extra values to set in the gemspec.
end

CHANGES = hoe.paragraphs_of('History.txt', 0..1).join("\n\n")
PATH    = (RUBYFORGE_PROJECT == GEM_NAME) ? RUBYFORGE_PROJECT : "#{RUBYFORGE_PROJECT}/#{GEM_NAME}"
hoe.remote_rdoc_dir = File.join(PATH.gsub(/^#{RUBYFORGE_PROJECT}\/?/,''), 'rdoc')

desc 'Generate website files'
task :website_generate do
  Dir['website/**/*.txt'].each do |txt|
    sh %{ ruby scripts/txt2html #{txt} > #{txt.gsub(/txt$/,'html')} }
  end
end

desc 'Upload website files to rubyforge'
task :website_upload do
  host = "#{rubyforge_username}@rubyforge.org"
  remote_dir = "/var/www/gforge-projects/#{PATH}/"
  local_dir = 'website'
  sh %{rsync -aCv #{local_dir}/ #{host}:#{remote_dir}}
end

desc 'Generate and upload website files'
task :website => [:website_generate, :website_upload, :publish_docs]

desc 'Release the website and new gem version'
task :deploy => [:check_version, :website, :release] do
  puts "Remember to create SVN tag:"
  puts "svn copy svn+ssh://#{rubyforge_username}@rubyforge.org/var/svn/#{PATH}/trunk " +
    "svn+ssh://#{rubyforge_username}@rubyforge.org/var/svn/#{PATH}/tags/REL-#{VERS} "
  puts "Suggested comment:"
  puts "Tagging release #{CHANGES}"
end

desc 'Runs tasks website_generate and install_gem as a local deployment of the gem'
task :local_deploy => [:website_generate, :install_gem]

task :check_version do
  unless ENV['VERSION']
    puts 'Must pass a VERSION=x.y.z release version'
    exit
  end
  unless ENV['VERSION'] == VERS
    puts "Please update your version.rb to match the release version, currently #{VERS}"
    exit
  end
end

desc "Run the specs under spec/models"
RSpec::Core::RakeTask.new do |t|
  t.rspec_opts = ['--options', "spec/spec.opts"]
end

desc "Default task is to run specs"
task :default => :spec

