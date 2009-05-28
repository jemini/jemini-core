require 'java'

Dir.glob(File.join('lib', '**/*.jar')).each do |jar_file|
  $CLASSPATH << jar_file
end

require 'gemini'
require 'test_state'

require 'shared_specs'