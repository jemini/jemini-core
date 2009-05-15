GEMINI_DIR = File.expand_path(File.join(File.dirname(__FILE__), '..', '..'))

configuration do |c|
  c.project_name = 'ChangeMe'
  c.output_dir = 'package'
  c.main_ruby_file = 'main'
  c.main_java_file = 'org.rubyforge.rawr.Main'
  c.copy_to_build = [{:from => File.join(GEMINI_DIR, 'lib'), :to => 'lib/java'},
                     {:from => File.join(GEMINI_DIR, 'src'), :to => '.'}
                    ]
  # Compile all Ruby and Java files recursively
  # Copy all other files taking into account exclusion filter
#  c.source_dirs = ['src', 'lib/ruby', {:from => File.join(GEMINI_DIR, 'src'), :to => '.'}]
  c.source_dirs = ['src', 'lib/ruby']
  c.source_exclude_filter = []

  # Location of the jruby-complete.jar. Override this if your jar lives elsewhere.
  # This allows Rawr to make sure it uses a compatible jrubyc when compiling,
  # so the class files are always compatible, regardless of your system JRuby.
  #c.jruby_jar = 'lib/java/jruby-complete.jar'
  c.compile_ruby_files = true
  #c.java_lib_files = []  
#  c.java_lib_dirs = [:from => File.join(GEMINI_DIR, 'lib'), :to => 'lib/java']
  c.java_lib_dirs = ['lib/java']
  #c.files_to_copy = []
  c.java_library_path = File.join 'lib', 'native_files'
  c.target_jvm_version = 1.5
  #c.jars[:data] = { :directory => 'data/images', :location_in_jar => 'images', :exclude => /bak/}
  #c.jvm_arguments = ""

  # Bundler options
  # c.do_not_generate_plist = false
end
