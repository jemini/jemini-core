require 'spec_helper'
require 'behaviors/taggable'

describe Taggable do
  it_should_behave_like "initial mock state"

  before(:each) do
    @game_object = Gemini::GameObject.new(@state)
    @game_object.add_behavior :Taggable
  end
  
  it "can validate the presence of one or more tags on a GameObject" do
    @game_object.add_tag :foo
    @game_object.should have_tag(:foo)
    @game_object.add_tag :bar, :baz
    @game_object.should have_tag(:bar, :baz)
  end
  
  it "allows one or more tags to be added to a GameObject" do
    @game_object.add_tag :foo
    @game_object.should have_tag(:foo)
    @game_object.add_tag :bar, :baz, :quux
    @game_object.should have_tag(:bar, :baz, :quux)
  end
  
  it "allows a tag to be deleted from a GameObject" do
    @game_object.add_tag :foo, :bar, :baz, :quux
    @game_object.remove_tag :foo
    @game_object.should_not have_tag(:foo)
    @game_object.should have_tag(:bar, :baz, :quux)
    
  end

  it "allows multiple tags to be deleted from a game object" do
    @game_object.add_tag :foo, :bar, :baz, :quux
    @game_object.remove_tag :bar, :baz, :quux
    @game_object.should_not have_tag(:bar, :baz, :quux)
    @game_object.should have_tag(:foo)
  end

end