require 'spec_helper'
require 'behaviors/physical'

MARGIN = 0.001
MILLISECONDS = 1000.0

describe "Physical" do
  before :each do
    @state = TestState.new(mock('Container', :null_object => true), mock('Game', :null_object => true))
    @state.set_manager(:physics, @state.create(:BasicPhysicsManager))
    @game_object = @state.create :GameObject, :Physical
  end
  
  describe "#add_excluded_physical" do
    it "allows the object to occupy the same space as the given target" do
      @other_object = @state.create :GameObject, :Physical
      @game_object.body_position = Vector.new(1.0, 1.0)
      @other_object.body_position = Vector.new(1.0, 1.0)
      @game_object.add_excluded_physical(@other_object)
      @state.manager(:update).update(MILLISECONDS)
      @game_object.body_position.x.should be_close(1.0, MARGIN)
      @game_object.body_position.y.should be_close(1.0, MARGIN)
      @other_object.body_position.x.should be_close(1.0, MARGIN)
      @other_object.body_position.y.should be_close(1.0, MARGIN)
    end
  end
  
  describe "#add_force" do
    it "moves the object" do
      starting_location = Vector.new(0.0, 0.0)
      @game_object.set_body_position(starting_location)
      @game_object.add_force(Vector.new(1.0, 1.0))
      @state.manager(:update).update(MILLISECONDS)
      @game_object.body_position.x.should > starting_location.x
      @game_object.body_position.y.should > starting_location.y
    end
    
    it "moves more massive objects less distance with the same force" do
      force = Vector.new(1.0, 0.0)
      @game_object.mass = 1.0
      @game_object.add_force(force)
      @big_object = @state.create :GameObject, :Physical
      @big_object.body_position.y = @game_object.body_position.y + 1000.0
      @big_object.mass = 2.0
      @big_object.add_force(force)
      @state.manager(:update).update(MILLISECONDS)
      @big_object.body_position.x.should < @game_object.body_position.x
    end
  end
    
end
