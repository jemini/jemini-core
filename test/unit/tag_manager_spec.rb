require 'managers/tag_manager'

describe TagManager do
  class TagManagerGameObject < Gemini::GameObject
    has_behavior :Taggable
  end
  
  
  before(:each) do
    #@manager = TagManager.new(mock_spec)
    @game_object = TagGameObject.new
  end
  
  it "can find all GameObjects that have all of one or more specified tags" #do
#    game_object1 = TagGameObject.new
#    game_object1.add_tag :all_test
#    game_object2 = TagGameObject.new
#    game_object2.add_tag :all_test
#    p Tags.find_by_all_tags(:all_test)
#    Tags.find_by_all_tags(:all_test).size.should == 2
#    game_object1.add_tag :all_test2
#    Tags.find_by_all_tags(:all_test, :all_test2).size.should == 1
#    Tags.find_by_all_tags(:all_test, :all_test2, :all_test3).size.should == 0
#  end
  
  it "can find all GameObjects that have any of one or more specified tags" #do
#    game_object1 = TagGameObject.new
#    game_object1.add_tag :any_test
#    game_object2 = TagGameObject.new
#    game_object2.add_tag :any_test, :any_test2
#    Tags.find_by_any_tags(:any_test).size.should == 2
#    game_object3 = TagGameObject.new
#    game_object3.add_tag :any_test3
#    Tags.find_by_any_tags(:any_test, :any_test2).size.should == 2
#    Tags.find_by_any_tags(:any_test, :any_test2, :any_test3).size.should == 3
#  end
end