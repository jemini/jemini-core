$profiling = false
require 'profile' if $profiling
# VM OPTIONS : -Djava.library.path=../../lib/native_files
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

class File
  puts "-----------------------fixing expand_path-------------------------"
  class_eval do
    class << self
      alias_method :new_expand_path, :expand_path
    end
  end

  def File.is_jnlp_url?(path)
    #path =~ /^(http)|(file)/
    path =~ /^http/
  end

  def File.expand_path fname, dir_string=nil
    if is_jnlp_url?(fname)
      local_url = fname.split( 'jar!/').last
       "./#{local_url}"
    else
      new_expand_path( fname, dir_string )
    end
  end
end


if Gemini::Resolver.run_location == Gemini::Resolver::IN_FILE_SYSTEM
  $LOAD_PATH.unshift File.expand_path(File.dirname(__FILE__) + "/..")
  $LOAD_PATH << File.expand_path(File.dirname(__FILE__))
  $LOAD_PATH << File.expand_path(File.dirname(__FILE__) + "/../../../src")
else
  $LOAD_PATH << File.expand_path(File.dirname(__FILE__))
  $LOAD_PATH << File.expand_path(File.dirname(__FILE__) + "/../lib/ruby/gemini")
  #$LOAD_PATH << (File.expand_path(File.dirname(__FILE__) + "/..") + "/../../src")
end

%w{behaviors game_objects keymaps managers states}.each do |dir|
  $LOAD_PATH << File.expand_path(File.dirname(__FILE__) + "/#{dir}")
end

puts $LOAD_PATH
#require 'src/gemini'
#require 'file:/Users/logan/dev/gemini/examples/ultra_table_tennis/package/deploy/ultra-table-tennis.jar!/src/gemini'
require 'gemini'
Gemini::Main.new("Ultra Table Tennis", 640, 480)