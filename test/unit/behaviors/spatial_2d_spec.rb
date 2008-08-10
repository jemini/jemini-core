require 'game_object'
require 'behaviors/spatial_2d'
require 'base_state'

describe Spatial2D do
  class Spatial2DGameObject < Gemini::GameObject
    has_behavior :Spatial2D
  end
  
  before(:each) do
    @game_object = Spatial2DGameObject.new
  end
  
  it "allows the x and y values to be read and written to" do
    @game_object.x.should == 0
    @game_object.x = 10
    @game_object.x.should == 10
    
    @game_object.y.should == 0
    @game_object.y = 10
    @game_object.y.should == 10
  end
  
  it "notifies listeners when x changes" do
    before_called = false
    after_called = false
    
    @game_object.on_before_x_changes { before_called = true }
    @game_object.on_after_x_changes { after_called = true }
    
    @game_object.x = 5
    
    before_called.should be_true
    after_called.should be_true
  end
  
  it "notifies listeners when y changes" do
    before_called = false
    after_called = false
    
    @game_object.on_before_y_changes { before_called = true }
    @game_object.on_after_y_changes { after_called = true }
    
    @game_object.y = 5
    
    before_called.should be_true
    after_called.should be_true
  end
  
  it "allows the width and height to be read and written to"
  it "notifies listeners when width changes"
  it "notifies listeners when height changes"
end