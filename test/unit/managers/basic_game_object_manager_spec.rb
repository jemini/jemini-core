require 'spec_helper'
require 'managers/basic_game_object_manager'

describe 'BasicGameObjectManager' do

  before :each do
    @state = Jemini::BaseState.new(mock('Container', :null_object => true), mock('Game', :null_object => true))
    @manager = BasicGameObjectManager.new(@state)
    @state.send(:set_manager, :game_object, @manager)
  end
  
  it "tracks objects added to state" do
    object = @state.create :GameObject
    @manager.game_objects.should include(object)
  end
  
  describe "#remove_game_object" do
  
    it "calls unload on an object when removing it" do
      object = @state.create :GameObject, :ReceivesEvents
      object.should_receive(:unload).ordered
      @manager.remove_game_object(object)
    end
  
    it "triggers before and after callbacks for removal"
    
    it "deletes all behaviors on an object after removing it"
    
    it "removes all listeners on an object after removing it"
    
  end
    
end
