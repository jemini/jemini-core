require 'spec_helper'
require 'behaviors/animated_image'
require 'managers/resource_manager'

describe 'AnimatedImage' do
  it_should_behave_like 'initial mock state'

  before :each do
    Jemini::Resource.send(:class_variable_set, :@@base_path, 'test/game_with_animations/data')
    @resource_manager = ResourceManager.new(@state)

    def @resource_manager.load_resource(name, type)
      OpenStruct.new(:width => 16, :height => 16, :name => name)
    end

    @state.stub!(:manager).with(:resource).and_return(@resource_manager)
    @resource_manager.load_resources
    @game_object = Jemini::GameObject.new(@state, :AnimatedImage)
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
    it 'starts an animation and automatically updates' do
      @game_object.animate_as :dwarf
      @game_object.animate :walk
      @game_object.image.name.should match(/dwarf_walk1/)
      @game_object.update(10)
      @game_object.image.name.should match(/dwarf_walk1/)
      @game_object.update(490)
      @game_object.image.name.should match(/dwarf_walk2/)
      @game_object.update(10)
      @game_object.image.name.should match(/dwarf_walk2/)
    end
  end

  describe '#animate_pulse' do
    it ''
  end

  describe '#animate_cycle' do
    
  end

  describe '#animation' do

  end

  describe '#animations' do
    
  end

  describe 'default animations' do
    
  end
end