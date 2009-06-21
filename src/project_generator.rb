require 'fileutils'
#require 'rawr'

module Gemini
  class ProjectGenerator
    include FileUtils

    def initialize(options)
      @project_dir       = options[:project_dir]
      @project_title     = options[:project_title]
      @rawr_install_args = options[:rawr_install]
    end

    def generate_project
      generate_default_dirs
      generate_main
      generate_main_with_natives
      copy_libs
      rawr_install
      generate_hello_world_state
      copy_gemini_jar
    end

    def generate_main
      mkdir_p File.expand_path(File.join(@project_dir, 'src'))
      path = File.expand_path(File.join(@project_dir, 'src', 'main.rb'))

      File.open(path, "w") do |f|
        f << <<-ENDL
require 'java'

$LOAD_PATH.clear
$LOAD_PATH << File.expand_path(File.dirname(__FILE__))

# only when running in non-standalone
jar_glob = File.expand_path(File.join(File.dirname(__FILE__), '..', 'lib', 'java', '*.jar'))
Dir.glob(jar_glob).each do |jar|
  $CLASSPATH << jar
end

require 'gemini'

begin
  # Change :HelloState to point to the initial state of your game
  Gemini::Main.start_app("", 800, 600, :HelloState, false)
rescue => e
  warn e
  warn e.backtrace
end
        ENDL
      end
    end

    def generate_main_with_natives
      mkdir_p File.expand_path(File.join(@project_dir, 'src'))
      path = File.expand_path(File.join(@project_dir, 'src', 'main_with_natives.rb'))
      File.open(path, "w") do |f|
        f << <<-ENDL
system("jruby -J-Djava.library.path=lib/native_files \#{File.expand_path(File.join(File.dirname(__FILE__)), 'main.rb')}")
ENDL
      end
    end

    def copy_gemini_jar
      destination = File.expand_path(File.join(@project_dir, 'lib', 'java'))
      source      = File.expand_path(File.join(File.dirname(__FILE__), '..', 'package', 'jar', 'gemini.jar'))

      mkdir_p destination
      cp source, destination
    end

    #TODO: Implement
    def build_gemini_jar
      
    end

    def generate_default_dirs
      mkdir_p File.expand_path(File.join(@project_dir, 'src', 'game_objects'))
      mkdir_p File.expand_path(File.join(@project_dir, 'src', 'behaviors'))
      mkdir_p File.expand_path(File.join(@project_dir, 'src', 'input_mappings'))
      mkdir_p File.expand_path(File.join(@project_dir, 'src', 'input_helpers'))
      mkdir_p File.expand_path(File.join(@project_dir, 'src', 'states'))
    end

    def generate_hello_world_state
      mkdir_p File.expand_path(File.join(@project_dir, 'src', 'states'))
      path = File.expand_path(File.join(@project_dir, 'src', 'states', 'hello_world_state.rb'))
      File.open(path, "w") do |f|
        f << <<-ENDL
        class HelloWorldState < Gemini::BaseState
        end
ENDL
      end
    end

    def rawr_install
      mkdir_p @project_dir
      puts `rawr install #{@rawr_install_args} #{@project_dir}`
    end

    def copy_libs
      mkdir_p File.expand_path(File.join(@project_dir, 'lib', 'java'))
      copy_libs = %w{ibxm.jar jinput.jar jogg-0.0.7.jar jorbis-0.0.15.jar lwjgl.jar lwjgl_util_applet.jar natives-linux.jar natives-mac.jar natives-win32.jar phys2d.jar slick.jar}
      copy_libs.each do |copy_lib|
        from = File.expand_path(File.join(File.dirname(__FILE__), '..', 'lib', copy_lib))
        cp from, File.join(@project_dir, 'lib', 'java')
      end
#      mkdir_p File.expand_path(File.join(@project_dir, 'lib', 'java', 'native_libs'))
      cp_r File.expand_path(File.join(File.dirname(__FILE__), '..', 'lib', 'native_files')) + '/', File.join(@project_dir, 'lib', 'java', 'native_files')
    end
  end
end