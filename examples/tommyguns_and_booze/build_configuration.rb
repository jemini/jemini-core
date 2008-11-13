configuration do |c|
  c.project_name = 'Tommyguns and Booze'
  c.output_dir = 'package'
  c.main_ruby_file = 'main'
  c.main_java_file = 'org.rubyforge.rawr.Main'

  # Compile all Ruby and Java files recursively
  # Copy all other files taking into account exclusion filter
  c.source_dirs = ['src']
  c.source_exclude_filter = []

  c.compile_ruby_files = true
  #c.java_lib_files = []
  c.java_lib_dirs = ['../../lib']
  # the copy is so bad. Don't use it.
  #c.files_to_copy = (Dir.glob('../../lib/native_files/**/*') + Dir.glob('../../src/**/*.rb')).reject {|file| File.directory? file}

  c.target_jvm_version = 1.5
  c.jars[:data] = { :directory => 'data', :location_in_jar => 'data', :exclude => /bak/}
  c.jvm_arguments = "-Djava.library.path=lib/native_files -XX:+UseConcMarkSweepGC -Djruby.compile.mode=FORCE -server -Xms256m -Xmx512m"

  # Bundler options
  # c.do_not_generate_plist = false
end
