require 'spec_helper'
# require File.join(File.dirname(__FILE__), 'shared_spec')
require 'managers/tag_manager'

describe 'TagManager' do

  # it_should_behave_like "a manager"

  before :each do
    @state = Jemini::GameState.new(mock('Container', :null_object => true), mock('Game', :null_object => true))
    @tag_manager = TagManager.new(@state)
    @state.send(:set_manager, :tag, @tag_manager)
  end
  
  it "tracks tags that are added to objects" do
    object = @state.create :GameObject, :Taggable
    object.add_tag :foo
    @state.manager(:tag).find_by_tag(:foo).should include(object)
  end
  
end
