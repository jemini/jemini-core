require 'spec_helper'
require 'fileutils'
require 'project_generator'

describe 'Jemini::ProjectGenerator', 'project generation' do
  before :each do
    @project_dir = File.expand_path(File.join(File.dirname(__FILE__), '..', '..', "spec_tmp"))
    FileUtils.rm_rf @project_dir
    @project_title = "Halo Killer"
  end

  after :each do
    FileUtils.rm_rf @project_dir
  end

  it "generates a ready-to-go Jemini project by typing jemini <my project>" do
    puts `jruby #{File.expand_path(File.join(File.dirname(__FILE__), '..', '..', 'bin', 'jemini'))} -RI--no-download #{@project_dir}`

    File.should be_exist(File.join(@project_dir))
    File.should be_directory(File.join(@project_dir))
  end

  it "generates src/main.rb" do
    generator = Jemini::ProjectGenerator.new(:project_dir => @project_dir, :project_title => @project_title)
    generator.generate_main
    File.should be_exist(File.join(@project_dir, 'src', 'main.rb'))
  end

  it "generates src/game_objects" do
    generator = Jemini::ProjectGenerator.new(:project_dir => @project_dir)
    generator.generate_default_dirs

    File.should be_exist(File.join(@project_dir, 'src', 'game_objects'))
    File.should be_directory(File.join(@project_dir, 'src', 'game_objects'))
  end

  it "generates src/behaviors" do
    generator = Jemini::ProjectGenerator.new(:project_dir => @project_dir)
    generator.generate_default_dirs

    File.should be_exist(File.join(@project_dir, 'src', 'behaviors'))
    File.should be_directory(File.join(@project_dir, 'src', 'behaviors'))
  end

  it "generates src/states" do
    generator = Jemini::ProjectGenerator.new(:project_dir => @project_dir)
    generator.generate_default_dirs

    File.should be_exist(File.join(@project_dir, 'src', 'states'))
    File.should be_directory(File.join(@project_dir, 'src', 'states'))
  end

  it "generates src/input_mappings" do
    generator = Jemini::ProjectGenerator.new(:project_dir => @project_dir)
    generator.generate_default_dirs

    File.should be_exist(File.join(@project_dir, 'src', 'input_mappings'))
    File.should be_directory(File.join(@project_dir, 'src', 'input_mappings'))
  end

  it "generates src/input_helpers" do
    generator = Jemini::ProjectGenerator.new(:project_dir => @project_dir)
    generator.generate_default_dirs

    File.should be_exist(File.join(@project_dir, 'src', 'input_helpers'))
    File.should be_directory(File.join(@project_dir, 'src', 'input_helpers'))
  end

  it "invokes Rawr to install itself in the project" do
    generator = Jemini::ProjectGenerator.new(:project_dir => @project_dir, :rawr_install => '--no-download')
    generator.rawr_install

    File.should be_exist(File.join(@project_dir, 'build_configuration.rb'))
    File.should be_exist(File.join(@project_dir, 'Rakefile'))
    File.should be_exist(File.join(@project_dir, 'src', 'org', 'rubyforge', 'rawr', 'Main.java'))
  end

  it "supplies Rawr with options to have an immediately usable build_configuration.rb"

  it "generates a 'hello world' state" do
    generator = Jemini::ProjectGenerator.new(:project_dir => @project_dir)
    generator.generate_hello_world_state
    File.should be_exist(File.join(@project_dir, 'src', 'states', 'hello_world_state.rb'))
  end

  it "generates main.rb to use the 'hello world' state" do
    generator = Jemini::ProjectGenerator.new(:project_dir => @project_dir, :project_title => @project_title)
    generator.generate_main
    File.readlines(File.join(@project_dir, 'src', 'main.rb')).join("\n").should match(/:HelloState/)
  end

  it "generates a main_with_natives.rb which invokes `jruby main.rb` with native libs configured" do
    generator = Jemini::ProjectGenerator.new(:project_dir => @project_dir)
    generator.generate_main_with_natives
    File.should be_exist(File.join(@project_dir, 'src', 'main_with_natives.rb'))
  end

  it "copies a jemini.jar into the lib/java dir" do
    puts `jruby -S rake rawr:jar`
    generator = Jemini::ProjectGenerator.new(:project_dir => @project_dir)
    generator.copy_jemini_jar
    File.should be_exist(File.join(@project_dir, 'lib', 'java', 'jemini.jar'))
  end

  it "builds a jemini.jar into the lib/java dir" do
    pending "Rawr must first support this feature"
    generator = Jemini::ProjectGenerator.new(:project_dir => @project_dir)
    generator.build_jemini_jar

    File.should be_exist(File.join(@project_dir, 'lib', 'java', 'gemini.jar'))
  end

  it "copies in the LWJGL and Slick jars lib/java dir" do
    generator = Gemini::ProjectGenerator.new(:project_dir => @project_dir)
    generator.copy_libs
    File.should be_exist(File.join(@project_dir, 'lib', 'java', 'slick.jar'))
    File.should be_exist(File.join(@project_dir, 'lib', 'java', 'phys2d.jar'))
    File.should be_exist(File.join(@project_dir, 'lib', 'java', 'ibxm.jar'))
    File.should be_exist(File.join(@project_dir, 'lib', 'java', 'jinput.jar'))
    File.should be_exist(File.join(@project_dir, 'lib', 'java', 'jogg-0.0.7.jar'))
    File.should be_exist(File.join(@project_dir, 'lib', 'java', 'jorbis-0.0.15.jar'))
    File.should be_exist(File.join(@project_dir, 'lib', 'java', 'lwjgl.jar'))
    File.should be_exist(File.join(@project_dir, 'lib', 'java', 'lwjgl_util_applet.jar'))
    File.should be_exist(File.join(@project_dir, 'lib', 'java', 'natives-linux.jar'))
    File.should be_exist(File.join(@project_dir, 'lib', 'java', 'natives-mac.jar'))
    File.should be_exist(File.join(@project_dir, 'lib', 'java', 'natives-win32.jar'))
  end

  it "copies in the native libs into the lib/java/native_files dir" do
    generator = Jemini::ProjectGenerator.new(:project_dir => @project_dir)
    generator.copy_libs
    File.should be_exist(File.join(@project_dir, 'lib', 'java', 'native_files', 'OpenAL32.dll'))
    File.should be_exist(File.join(@project_dir, 'lib', 'java', 'native_files', 'libjinput-linux.so'))
    File.should be_exist(File.join(@project_dir, 'lib', 'java', 'native_files', 'libjinput-linux64.so'))
    File.should be_exist(File.join(@project_dir, 'lib', 'java', 'native_files', 'liblwjgl.jnilib'))
    File.should be_exist(File.join(@project_dir, 'lib', 'java', 'native_files', 'libopenal.so'))
    File.should be_exist(File.join(@project_dir, 'lib', 'java', 'native_files', 'jinput-dx8.dll'))
    File.should be_exist(File.join(@project_dir, 'lib', 'java', 'native_files', 'liblwjgl.so'))
    File.should be_exist(File.join(@project_dir, 'lib', 'java', 'native_files', 'lwjgl.dll'))
    File.should be_exist(File.join(@project_dir, 'lib', 'java', 'native_files', 'jinput-raw.dll'))
    File.should be_exist(File.join(@project_dir, 'lib', 'java', 'native_files', 'libjinput-osx.jnilib'))
    File.should be_exist(File.join(@project_dir, 'lib', 'java', 'native_files', 'liblwjgl64.so'))
    File.should be_exist(File.join(@project_dir, 'lib', 'java', 'native_files', 'openal.dylib'))
  end
end
