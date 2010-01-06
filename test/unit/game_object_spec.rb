require File.expand_path(File.join(File.dirname(__FILE__), '..', 'spec_helper'))
require 'game_object'

describe "Jemini::GameObject" do
  it_should_behave_like "initial mock state"

  before :each do
    @game_object = Jemini::GameObject.new(@state)
  end

  it "removes listeners after invoking on_after_remove callbacks" do
    pending
    invoked = false
    @game_object.on_after_remove do
      invoked = true
    end

    @game_object.__destroy
    invoked.should be_true

    invoked = false
    @game_object.__destroy # destroying again proves invoked should not be called because handlers are removed
    invoked.should be_false
  end

  it "has a before_remove event" do
    invoked = false
    @game_object.on_before_remove do
      invoked = true
    end

    @game_object.__destroy

    invoked.should be_true
  end

  it "has an after_remove event" do
    invoked = false
    @game_object.on_after_remove do
      invoked = true
    end

    @game_object.__destroy

    invoked.should be_true
  end

  it "invokes the before_remove event before the after_remove event" do
    status = nil
    @game_object.on_before_remove do
      status = :before
    end

    @game_object.on_after_remove do
      status = :after
    end

    @game_object.__destroy
    status.should == :after
  end

  
end