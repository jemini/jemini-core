JEMINI_DIR = File.expand_path(File.join(File.dirname(__FILE__), '..', '..'))

configuration do |c|
  c.project_name = 'LifeTank'
  c.output_dir = 'package'
  c.main_ruby_file = 'main'
  c.main_java_file = 'org.rubyforge.rawr.Main'
  c.copy_to_build = [{:from => File.join(JEMINI_DIR, 'lib'), :to => 'lib'}]
  # Compile all Ruby and Java files recursively
  # Copy all other files taking into account exclusion filter
  c.source_dirs = ['src', 'lib/ruby', File.join(JEMINI_DIR, 'src')]
  c.source_exclude_filter = []

  # Location of the jruby-complete.jar. Override this if your jar lives elsewhere.
  # This allows Rawr to make sure it uses a compatible jrubyc when compiling,
  # so the class files are always compatible, regardless of your system JRuby.
  c.jruby_jar = File.join JEMINI_DIR, 'lib', 'jruby-complete.jar'
  c.compile_ruby_files = true
  #c.java_lib_files = []  
  c.java_lib_dirs = [File.join('..', '..', 'lib'), 'lib']
#  c.files_to_copy = Dir.glob('data/**/*')
  c.java_library_path = File.join 'lib', 'native_files'
  c.target_jvm_version = 1.6

  c.jars[:data] = { :directory => 'data', :location_in_jar => 'data', :exclude => /bak/}
  # add -verbosegc to see what the GC is doing
  c.jvm_arguments = "-XX:+UseConcMarkSweepGC -Djruby.compile.mode=FORCE -Xms256m -Xmx512m"

  # Bundler options
  # c.do_not_generate_plist = false
end
