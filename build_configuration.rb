configuration do |c|
  c.project_name = 'gemini'
  c.output_dir = 'package'
#  c.main_ruby_file = 'main'
#  c.main_java_file = 'org.rubyforge.rawr.Main'

  # Compile all Ruby and Java files recursively
  # Copy all other files taking into account exclusion filter
  c.source_dirs = ['src']
  c.source_exclude_filter = []

  c.compile_ruby_files = true
  #c.java_lib_files = []  
  c.java_lib_dirs = ['lib']
  c.files_to_copy = Dir.glob('lib/native_files/*')

  c.target_jvm_version = 1.5
  #c.jars[:data] = { :directory => 'data/images', :location_in_jar => 'images', :exclude => /bak/}
  #c.jvm_arguments = ""

  # Bundler options
  # c.do_not_generate_plist = false
end
