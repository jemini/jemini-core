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
    @game_object.animation_speed = 500
  end

  describe '#animate_as' do
    it 'loads all animations fitting the name <noun>_<action><sequence>' do
      @game_object.animate_as :dwarf
      @game_object.animations.should have(3).animations
    end
  end

  describe '#animation_fps=' do
    it 'allows variable speeds'
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

    it 'reverts to the default animation when the animation is complete' do
      @game_object.animate_as :dwarf
      @game_object.animate :walk
      @game_object.image.name.should match(/dwarf_walk1/)
      @game_object.update(1250)
      @game_object.image.name.should match(/dwarf_default1/)
    end
  end

  describe '#animate_pulse' do
    it 'allows transitions to other animation types' do
      @game_object.animate_as :dwarf
      @game_object.animate_pulse :walk, 250
      @game_object.update(10)
      @game_object.image.name.should match(/dwarf_walk1/)
      @game_object.animate :shoot
      @game_object.update(10)
      @game_object.image.name.should match(/dwarf_shoot1/)
    end

    it 'updates only when pulsed on each frame' do
      @game_object.animate_as :dwarf
      @game_object.animate_pulse :walk, 250
      @game_object.update(10)
      @game_object.image.name.should match(/dwarf_walk1/)
      @game_object.animate_pulse :walk, 250
      @game_object.update(10)
      @game_object.image.name.should match(/dwarf_walk2/)
    end

    it 'cycles the animation' do
      @game_object.animate_as :dwarf
      @game_object.animate_pulse :walk, 250
      @game_object.update(10)
      @game_object.image.name.should match(/dwarf_walk1/)
      @game_object.animate_pulse :walk, 250
      @game_object.update(10)
      @game_object.image.name.should match(/dwarf_walk2/)
      @game_object.animate_pulse :walk, 500
      @game_object.update(10)
      @game_object.image.name.should match(/dwarf_walk1/)
      @game_object.animate_pulse :walk, 500
      @game_object.update(10)
      @game_object.image.name.should match(/dwarf_walk2/)
    end

    it 'reverts to default if the pulse is missed during a frame' do
      @game_object.animate_as :dwarf
      @game_object.animate_pulse :walk, 250
      @game_object.image.name.should match(/dwarf_walk1/)
      @game_object.update(250)
      @game_object.update(10)
      @game_object.image.name.should match(/dwarf_default1/)
    end

  end

  describe '#animate_cycle' do
    it 'indefinitely repeats the animation provided' do
      @game_object.animate_as :dwarf
      @game_object.animate_cycle :walk
      @game_object.image.name.should match(/dwarf_walk1/)
      @game_object.update(10)
      @game_object.image.name.should match(/dwarf_walk1/)
      @game_object.update(490)
      @game_object.image.name.should match(/dwarf_walk2/)
      @game_object.update(10)
      @game_object.image.name.should match(/dwarf_walk2/)
      @game_object.update(490)
      @game_object.image.name.should match(/dwarf_walk1/)
      @game_object.update(10)
      @game_object.image.name.should match(/dwarf_walk1/)
      @game_object.update(490)
      @game_object.image.name.should match(/dwarf_walk2/)
    end

  end

  describe '#animation' do
    it 'gets the current animation name'
  end

  describe '#animations' do
    it 'gets a list of all animations names'
  end

  describe 'default animations' do
    it 'cycles forever' do
      @game_object.animate_as :dwarf
      @game_object.animate :walk
      @game_object.image.name.should match(/dwarf_walk1/)
      @game_object.update(1500)
      @game_object.image.name.should match(/dwarf_default1/)
      @game_object.update(500)
      @game_object.image.name.should match(/dwarf_default2/)
      @game_object.update(500)
      @game_object.image.name.should match(/dwarf_default1/)
      @game_object.update(500)
      @game_object.image.name.should match(/dwarf_default2/)
    end
  end
end