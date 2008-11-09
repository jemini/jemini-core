require 'rawr'
require 'rawr'
require 'rake'
require 'spec/rake/spectask'

desc "Run all spec tests"
Spec::Rake::SpecTask.new do |t|
  t.libs << ["src"]
  t.spec_files = FileList['test/unit/**/*_spec.rb']
  t.spec_opts = ['--color']
end
