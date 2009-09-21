require 'spec_helper'
require 'managers/basic_game_object_manager'

describe 'BasicGameObjectManager' do

  before :each do
    @state = Jemini::GameState.new(mock('Container', :null_object => true), mock('Game', :null_object => true))
    @manager = BasicGameObjectManager.new(@state)
    @state.send(:set_manager, :game_object, @manager)
  end
  
  it "tracks objects added to state" do
    object = @state.create :GameObject
    @manager.game_objects.should include(object)
  end
  
  describe "#remove_game_object" do
  
    it "calls before-callback, unload, and after-callback on an object when removing it" do
      object = @state.create :GameObject, :HandlesEvents
      @manager.should_receive(:before).ordered
      @manager.on_before_remove_game_object :before
      object.should_receive(:unload).ordered
      @manager.should_receive(:after).ordered
      @manager.on_after_remove_game_object :after
      @manager.remove_game_object(object)
    end
  
    it "deletes all behaviors on an object after removing it"
    
    it "removes all listeners on an object after removing it"
    
  end
    
end
