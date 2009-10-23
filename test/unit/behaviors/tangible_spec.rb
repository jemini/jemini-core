require 'spec_helper'
require 'behaviors/tangible'

describe 'Tangible' do
  it_should_behave_like 'initial mock state'
  it_should_behave_like 'resourceless game state'
  
  before :each do
    @state = TestState.new(mock('Container', :null_object => true), mock('Game', :null_object => true))
    @state.send(:set_manager, :tangible, @state.create(:TangibleManager))

    @game_object = @state.create :GameObject, :Tangible
    @game_object.add_behavior :Tangible
    @game_object.set_tangible_shape :Box, 20, 20
    @game_object.position = Vector.new(3,3)
  end

  it 'passes the other tangible in the collision message' do
    other = @state.create :GameObject, :Tangible
    other.set_tangible_shape :Box, 20, 20
    other.position = Vector.new(5, 5)

    called = false
    @game_object.on_tangible_collision do |message|
      called = true
      message.should_not be_nil
      message.other_tangible.should == other
    end

    @state.manager(:update).update(10)

    called.should be_true
  end
end
