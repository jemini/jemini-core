require 'fileutils'

module Gemini
  class Generator
    include FileUtils

    def initialize(options)
      @project_dir   = options[:project_dir]
      @project_title = options[:project_title]
    end

    def generate_project
      generate_default_dirs
      generate_main
      generate_main_with_natives
      copy_libs
    end

    def generate_main
      mkdir_p File.expand_path(File.join(@project_dir, 'src'))
      path = File.expand_path(File.join(@project_dir, 'src', 'main.rb'))

      File.open(path, "w") do |f|
        f << <<-ENDL
$LOAD_PATH.clear
$LOAD_PATH << File.expand_path(File.dirname(__FILE__))
require 'gemini'

begin
  # Change :HelloState to point to the initial state of your game
  Gemini::Main.start_app("#{@project_title}", 800, 600, :HelloState, false)
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
        system('jruby -D#{File.expand_path(File.join(File.dirname(__FILE__)), 'main.rb')}
ENDL
      end
    end

    def generate_default_dirs
      mkdir_p File.expand_path(File.join(@project_dir, 'src', 'game_objects'))
      mkdir_p File.expand_path(File.join(@project_dir, 'src', 'behaviors'))
      mkdir_p File.expand_path(File.join(@project_dir, 'src', 'input_mappings'))
      mkdir_p File.expand_path(File.join(@project_dir, 'src', 'input_helpers'))
      mkdir_p File.expand_path(File.join(@project_dir, 'src', 'states'))
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