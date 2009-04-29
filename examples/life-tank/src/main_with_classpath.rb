require 'java'
puts File.expand_path(File.dirname(__FILE__) + '/../../../lib')
Dir.glob(File.expand_path(File.dirname(__FILE__) + '/../../../lib/*.jar')).each do |jar|
  $CLASSPATH << jar
end
require 'src/main'