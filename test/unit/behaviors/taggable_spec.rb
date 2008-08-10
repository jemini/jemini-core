require 'behaviors/taggable'
require 'game_object'
require 'base_state'

describe Taggable do
  class TagGameObject < Gemini::GameObject
    has_behavior :Taggable
  end
  
  before(:each) do
    @game_object = TagGameObject.new
  end
  
  it "can validate the presence of one or more tags on a GameObject" do
    @game_object.add_tag :foo
    @game_object.has_tag?(:foo).should be_true
    @game_object.add_tag :bar, :baz
    @game_object.has_tag?(:bar, :baz).should be_true
  end
  
  it "allows one or more tags to be added to a GameObject" do
    @game_object.add_tag :foo
    @game_object.has_tag?(:foo).should be_true
    @game_object.add_tag :bar, :baz, :quux
    @game_object.has_tag?(:bar, :baz, :quux).should be_true
  end
  
  it "allows one or more tags to be deleted to a GameObject" do
    @game_object.add_tag :foo, :bar, :baz, :quux
    @game_object.has_tag?(:foo, :bar, :baz, :quux).should be_true
    @game_object.remove_tag :foo
    @game_object.has_tag?(:foo).should be_false
    @game_object.remove_tag :bar, :baz, :quux
    @game_object.has_tag?(:bar, :baz, :quux).should be_false
  end
  

end