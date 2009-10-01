require 'spec_helper'
require 'behaviors/animated_image'
require 'managers/resource_manager'

describe 'AnimatedImage' do
  it_should_behave_like 'initial mock state'

  before :each do
    @game_object = Jemini::GameObject.new(@state, :AnimatedImage)
    @state.stub!(:manager).with(:resource).and_return(@resource_manager)
    @resource_manager = ResourceManager.new(@state)
    @resource_manager.stub!(:load_resource).and_return(mock('Resource'))
    Jemini::Resource.send(:class_variable_set, :@@base_path, 'test/game_with_animations/data')
  end

  describe '#animate_as' do
    it 'loads all animations fitting the name <noun>_<action><sequence>' do
      @game_object.animate_as :dwarf
      @game_object.animations.should have(3).animations
    end
  end

  describe '#animation_fps=' do

  end

  describe '#animate' do
    
  end

  describe '#animate_pulse' do

  end

  describe '#animate_cycle' do
    
  end

  describe '#animation' do

  end

  describe '#animations' do
    
  end
end