require 'java'
require 'instance_stubber'
require 'spec'
#require 'rubygems'
#require 'mocha'

#java.lang.System.set_property('java.jruby.debug.fullTrace', 'true')

ENV['LOG_LEVEL'] ||= 'UNKNOWN'

Spec::Runner.configure do |config|
  
end

Dir.glob(File.join('lib', '**/*.jar')).each do |jar_file|
  $CLASSPATH << jar_file
end

# $game_path used elsewhere in tests
$game_path = File.expand_path(File.join(File.dirname(__FILE__), 'game'))
$LOAD_PATH << $game_path

#Margin of error for RSpec be_close matchers.
MARGIN = 0.001

require 'jemini'
require 'test_state'

require 'shared_specs'
require 'matchers'

def stub_image_resource(reference)
  @references ||= {}
  @references[reference] = mock("resource for #{reference}")
  @game_state.manager(:resource).should_not be_nil
  @game_state.manager(:resource).stub!(:get_image) do |key|
    @references[key]
  end
end
