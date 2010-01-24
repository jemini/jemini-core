require File.expand_path(File.join(File.dirname(__FILE__), '..', '..', 'spec_helper'))
require 'game_objects/sprite'

describe "Sprite" do
  it_should_behave_like "initial mock state"

  before do
    Jemini::Resource.send(:class_variable_set, :@@base_path, 'test/game/data')
    @resource_manager = ResourceManager.new(@state)

    def @resource_manager.load_resource(name, type)
      OpenStruct.new(:width => 16, :height => 16, :name => name)
    end

    @state.stub!(:manager).with(:resource).and_return(@resource_manager)
    @resource_manager.load_resources
  end

  it "has the DrawableImage behavior" do
    @sprite = Sprite.new(@state)
    @sprite.should have_behavior(:DrawableImage)
  end

  it "loads the image from the constructor" do
    @sprite = Sprite.new(@state, :dwarf_default1)
    @sprite.image.name.should == "test/game/data/dwarf_default1.png"
  end
end