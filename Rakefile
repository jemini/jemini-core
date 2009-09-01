require 'rawr'
require 'rake'
require 'spec/rake/spectask'
require 'rake/rdoctask'

desc "Run all spec tests"
Spec::Rake::SpecTask.new do |t|
  t.libs << ["src", 'test']
  t.spec_files = FileList['test/unit/**/*_spec.rb']
  t.spec_opts = ['--color']
end

load 'tasks/setup.rb'

ensure_in_path 'src'
require 'jemini_version'

#Dir.glob("tasks/**/*.rake").each do |rake_file|
#  load File.expand_path(File.dirname(__FILE__) + "/" + rake_file)
#end

PROJ.name = 'jemini'
PROJ.authors = 'Logan Barnett, David Koontz'
PROJ.email = 'logustus@gmail.com'
PROJ.url = 'http://rubyforge.org/projects/jemini/'
PROJ.version = Jemini::VERSION
PROJ.summary = "Jemini is a Ruby game engine that separates the game logic from reusable game features. Includes hardware accelerated graphics, physics, standalone distros, and more."
PROJ.rubyforge.name = 'jemini'
PROJ.spec.files = FileList['test/**/*_spec.rb'],
PROJ.spec.opts << '--color'
PROJ.spec.libs << 'test/unit'
PROJ.ruby_opts = []
PROJ.libs << 'src'
PROJ.gem.dependencies << ["rawr", ">= 1.3.7"]
PROJ.gem.platform = "java"
PROJ.rdoc.exclude << /lib/
PROJ.rdoc.exclude << /jemini\.jar/

task :update_version_readme do
  readme = IO.readlines( 'README.txt')
  File.open( 'README.txt', 'w' ) { |f|
    f << "Jemini #{Jemini::VERSION}\n"
    readme.shift
    f << readme
  }
end

desc "Create documentation"
Rake::RDocTask.new do |task|
  task.rdoc_dir = "doc"
  task.rdoc_files = FileList["src/**/*.rb", "README.txt"]
  task.options = [
    "--title", "Jemini - A game library for Ruby/JRuby",
    "--main", "README.txt"
  ]
end


# TODO: There's a task that runs before gem:package that sucks in the manifest data, hook before that task instead
task 'gem:package' => [:update_version_readme]
