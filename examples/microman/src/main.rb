$profiling = false
require 'profile' if $profiling
# VM OPTIONS : -Djava.library.path=../../lib/native_files
require 'fileutils'

puts "this is the file we're in: #{__FILE__}"
puts "This is where we think we are: #{File.expand_path(File.dirname(__FILE__))}"
puts "pwd: #{FileUtils.pwd}"

module Gemini
  class Resolver
    IN_FILE_SYSTEM = :in_file_system
    IN_JAR_FILE = :in_jar_file
    
    # Returns a const value indicating if the currently executing code is being run from the file system or from within a jar file.
    def self.run_location
      if __FILE__ =~ /\.jar\!/
        :in_jar_file 
      else
        :in_file_system
      end
    end
  end
end

if Gemini::Resolver.run_location == Gemini::Resolver::IN_FILE_SYSTEM
  $LOAD_PATH.unshift File.expand_path(File.dirname(__FILE__) + "/..")
  $LOAD_PATH << File.expand_path(File.dirname(__FILE__))
  $LOAD_PATH << File.expand_path(File.dirname(__FILE__) + "/../../../src")
else
  $LOAD_PATH << File.expand_path(File.dirname(__FILE__))
  $LOAD_PATH << File.expand_path(File.dirname(__FILE__) + "/../../../src")
end

%w{behaviors game_objects keymaps managers states}.each do |dir|
  $LOAD_PATH << File.expand_path(File.dirname(__FILE__) + "/#{dir}")
  $LOAD_PATH << "src/#{dir}"
end

puts $LOAD_PATH
#require 'src/gemini'
#require 'file:/Users/logan/dev/gemini/examples/ultra_table_tennis/package/deploy/ultra-table-tennis.jar!/src/gemini'
puts "classpath:"
puts $CLASSPATH
require 'gemini'
Gemini::Main.new("Microman", 640, 480)