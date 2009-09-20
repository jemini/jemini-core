require 'spec_helper'
require 'managers/basic_physics_manager'

describe 'BasicPhysicsManager' do

  before :each do
    @state = Jemini::BaseState.new(mock('Container', :null_object => true), mock('Game', :null_object => true))
    @manager = BasicPhysicsManager.new(@state)
    @state.send(:set_manager, :physics, @manager)
  end
  
  it "tracks physics for new physics objects"
  
  it "no longer tracks physics for removed physics objects"
  
end
