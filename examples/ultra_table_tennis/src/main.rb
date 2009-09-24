#$profiling = false
#require 'profile' if $profiling
# VM OPTIONS : -Djava.library.path=../../lib/native_files
#require 'fileutils'

#puts "this is the file we're in: #{__FILE__}"
#puts "This is where we think we are: #{File.expand_path(File.dirname(__FILE__))}"
#puts "pwd: #{FileUtils.pwd}"

module Jemini
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
#
#class File
#  require 'rbconfig'
#  require 'fileutils'
#  puts "-----------------------fixing expand_path-------------------------"
#  class_eval do
#    class << self
#      alias_method :original_expand_path, :expand_path
#    end
#  end
#
#  def self.is_jar_path?(path)
#    #path =~ /^(http)|(file)/
#    #path =~ /^http/
#    #JRuby.runtime.class.security_restricted?
#    path =~ /\.jar\!/
#    
#  end
#
##  def self.expand_path(fname, dir_string=nil)
##    if is_jar_path?(fname)
##      puts "using jar path stuff"
##      local_url = fname.split('jar!/').last
##      "./#{local_url}"
##    else
##      original_expand_path(fname, dir_string)
##    end
###    if result =~ /jar!/
###      result = result.split('.jar!/').last if Config::CONFIG["host_os"] =~ /^win|mswin/i
###    else
##      puts "pwd: #{FileUtils.pwd}"
##      puts "before sub: #{result}"
##      result.sub!(FileUtils.pwd + '/', '')
##      puts "after sub: #{result}"
###    end
##    result
##  end
#
#  def self.expand_path(fname, dir_string=nil)
#    return original_expand_path(fname, dir_string) unless (Config::CONFIG["host_os"] =~ /^win|mswin/i) && (!is_jar_path?(fname))
#    pre_jar, post_jar = fname.split('.jar!/')
#    expanded_windows_path = "#{pre_jar}.jar!/#{original_expand_path(post_jar).sub(FileUtils.pwd + '/', '')}"
#    'http' + expanded_windows_path.split('http').last
#  end
#end


if Jemini::Resolver.run_location == Jemini::Resolver::IN_FILE_SYSTEM
  $LOAD_PATH.unshift File.expand_path(File.dirname(__FILE__) + "/..")
  $LOAD_PATH << File.expand_path(File.dirname(__FILE__))
  $LOAD_PATH << File.expand_path(File.dirname(__FILE__) + "/../../../src")
else
  $LOAD_PATH << File.expand_path(File.dirname(__FILE__))
#  $LOAD_PATH << File.expand_path(File.dirname(__FILE__) + "/../lib/ruby/jemini")
  $LOAD_PATH << File.expand_path(File.dirname(__FILE__) + "/../../../src")
  #$LOAD_PATH << (File.expand_path(File.dirname(__FILE__) + "/..") + "/../../src")
#  $LOAD_PATH << 'lib/ruby/jemini'
#  $LOAD_PATH << 'lib/ruby/jemini/managers'
#  $LOAD_PATH << 'lib/ruby/jemini/game_objects'
#  $LOAD_PATH << 'lib/ruby/jemini/states'
#  $LOAD_PATH << 'lib/ruby/jemini/behaviors'
end

%w{behaviors game_objects keymaps managers states}.each do |dir|
  $LOAD_PATH << File.expand_path(File.dirname(__FILE__) + "/#{dir}")
  $LOAD_PATH << "src/#{dir}"
end
#
#puts $LOAD_PATH
#require 'src/jemini'
#require 'file:/Users/logan/dev/jemini/examples/ultra_table_tennis/package/deploy/ultra-table-tennis.jar!/src/jemini'
#puts "classpath:"
#puts $CLASSPATH
require 'jemini'
Jemini::Game.start_app("Ultra Table Tennis", 640, 480)