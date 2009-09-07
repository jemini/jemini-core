require 'spec_helper'
require 'behaviors/drawable_shape'

describe 'DrawableShape' do
  
  before :each do
    @state = TestState.new(mock('Container', :null_object => true), mock('Game', :null_object => true))
    @game_object = @state.create :GameObject, :DrawableShape
  end
  
  describe "#set_visual_shape" do
    it "accepts an array of points"
  end
  
end
