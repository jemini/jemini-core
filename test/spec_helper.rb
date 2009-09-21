require 'java'

Dir.glob(File.join('lib', '**/*.jar')).each do |jar_file|
  $CLASSPATH << jar_file
end

require 'jemini'
require 'test_state'

require 'shared_specs'
require 'matchers'
