require 'spec_helper'
require 'managers/input_manager'

describe 'InputManager' do
  it_should_behave_like "initial mock state"

  before :each do
    #TODO: Provide (mock) container
#    @input_manager = Jemini::InputManager.new(@state)
  end

  it "can take a player count" do
    pending "Determine how to handle players"
    lambda {@input_manager.player_count = 2}.should_not raise_error
  end

  it "can take an array of player ids" do
    pending "Determine how to handle players"
    lambda {@input_manager.player_ids = [:logan, :david, :jay]}.should_not raise_error
  end

  it "can take a range of player ids" do
    pending "Determine how to handle players"
    lambda {@input_manager.player_ids = 0..3}.should_not raise_error
  end
end