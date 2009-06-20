require 'spec_helper'
require 'fileutils'
require 'gemini_generator'

describe 'Gemini::Generator', 'project generation' do
  before :each do
    @project_dir = File.expand_path(File.join(File.dirname(__FILE__), '..', '..', "spec_tmp"))
    FileUtils.rm_rf @project_dir
    @project_title = "Halo Killer"
  end

  after :each do
    FileUtils.rm_rf @project_dir
  end

  it "generates a ready-to-go Gemini project by typing gemini <my project>" do
#    system("../../bin/gemini #{@project_dir}")
    puts "jruby #{File.expand_path(File.join(File.dirname(__FILE__), '..', '..', 'bin', 'gemini'))} #{@project_dir}"
    puts `jruby #{File.expand_path(File.join(File.dirname(__FILE__), '..', '..', 'bin', 'gemini'))} #{@project_dir}`
    File.should be_exist(File.join(@project_dir))
    File.should be_directory(File.join(@project_dir))
  end

  it "generates src/main.rb" do
    generator = Gemini::Generator.new(:project_dir => @project_dir, :project_title => @project_title)
    generator.generate_main
    File.should be_exist(File.join(@project_dir, 'src', 'main.rb'))
  end

  it "generates src/game_objects" do
    generator = Gemini::Generator.new(:project_dir => @project_dir)
    generator.generate_default_dirs

    File.should be_exist(File.join(@project_dir, 'src', 'game_objects'))
    File.should be_directory(File.join(@project_dir, 'src', 'game_objects'))
  end
  
  it "generates src/behaviors" do
    generator = Gemini::Generator.new(:project_dir => @project_dir)
    generator.generate_default_dirs

    File.should be_exist(File.join(@project_dir, 'src', 'behaviors'))
    File.should be_directory(File.join(@project_dir, 'src', 'behaviors'))
  end

  it "generates src/states" do
    generator = Gemini::Generator.new(:project_dir => @project_dir)
    generator.generate_default_dirs

    File.should be_exist(File.join(@project_dir, 'src', 'states'))
    File.should be_directory(File.join(@project_dir, 'src', 'states'))
  end

  it "generates src/input_mappings" do
    generator = Gemini::Generator.new(:project_dir => @project_dir)
    generator.generate_default_dirs

    File.should be_exist(File.join(@project_dir, 'src', 'input_mappings'))
    File.should be_directory(File.join(@project_dir, 'src', 'input_mappings'))
  end

  it "generates src/input_helpers" do
    generator = Gemini::Generator.new(:project_dir => @project_dir)
    generator.generate_default_dirs

    File.should be_exist(File.join(@project_dir, 'src', 'input_helpers'))
    File.should be_directory(File.join(@project_dir, 'src', 'input_helpers'))
  end

  it "invokes Rawr to install itself in the project"

  it "supplies Rawr with options to have an immediately usable build_configuration.rb"

  it "generates a 'hello world' state"
  
  it "generates main.rb to use the 'hello world' state" do
    generator = Gemini::Generator.new(:project_dir => @project_dir, :project_title => @project_title)
    generator.generate_main
    File.readlines(File.join(@project_dir, 'src', 'main.rb')).join("\n").should match(/:HelloState/)
  end

  it "generates a main_with_natives.rb which invokes `jruby main.rb` with native libs configured" do
    generator = Gemini::Generator.new(:project_dir => @project_dir)
    generator.generate_main_with_natives
    File.should be_exist(File.join(@project_dir, 'src', 'main_with_natives.rb'))
  end

  it "copies in a gemini.jar into the lib/java dir" do
    pending
    generator = Gemini::Generator.new(:project_dir => @project_dir)
    generator.copy_libs

  end

  it "copies in the LWJGL and Slick jars lib/java dir" do
    generator = Gemini::Generator.new(:project_dir => @project_dir)
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
    generator = Gemini::Generator.new(:project_dir => @project_dir)
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