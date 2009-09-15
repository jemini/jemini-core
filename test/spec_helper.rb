require 'java'

Dir.glob(File.join('lib', '**/*.jar')).each do |jar_file|
  $CLASSPATH << jar_file
end

# $game_path used elsewhere in tests
$game_path = File.expand_path(File.join(File.dirname(__FILE__), 'game'))
$LOAD_PATH << $game_path

require 'jemini'
require 'test_state'

require 'shared_specs'