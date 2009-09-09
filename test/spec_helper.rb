require 'java'

Dir.glob(File.join('lib', '**/*.jar')).each do |jar_file|
  $CLASSPATH << jar_file
end

$LOAD_PATH << File.expand_path(File.join(File.dirname(__FILE__), 'game'))

require 'jemini'
require 'test_state'

require 'shared_specs'