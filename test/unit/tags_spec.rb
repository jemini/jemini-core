require 'behaviors/tags'

describe Tags do
  class TagGameObject < Gemini::GameObject
    has_behavior :Tags
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
  
  it "can find all GameObjects that have all of one or more specified tags" do
    game_object1 = TagGameObject.new
    game_object1.add_tag :all_test
    game_object2 = TagGameObject.new
    game_object2.add_tag :all_test
    Tags.find_by_all_tags(:all_test).size.should == 2
    game_object1.add_tag :all_test2
    Tags.find_by_all_tags(:all_test, :all_test2).size.should == 1
    Tags.find_by_all_tags(:all_test, :all_test2, :all_test3).size.should == 0
  end
  
  it "can find all GameObjects that have any of one or more specified tags" do
    game_object1 = TagGameObject.new
    game_object1.add_tag :any_test
    game_object2 = TagGameObject.new
    game_object2.add_tag :any_test, :any_test2
    Tags.find_by_any_tags(:any_test).size.should == 2
    game_object3 = TagGameObject.new
    game_object3.add_tag :any_test3
    Tags.find_by_any_tags(:any_test, :any_test2).size.should == 2
    Tags.find_by_any_tags(:any_test, :any_test2, :any_test3).size.should == 3
  end
end