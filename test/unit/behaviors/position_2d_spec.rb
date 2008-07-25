require 'behavior'
require 'game_object'
require 'behaviors/position_2d'

describe Position2D do
  class Position2DGameObject < Gemini::GameObject
    has_behavior :Position2D
  end
  
  before(:each) do
    @game_object = Position2DGameObject.new
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
    
    @game_object.on_before_x_changes do
      before_called = true
    end
    
    @game_object.on_after_x_changes do
      after_called = true
    end
    
    @game_object.x = 5
    before_called.should be_true
    after_called.should be_true
  end
  
  it "notifies listeners when y changes" do
    before_called = false
    after_called = false
    
    @game_object.on_before_y_changes do
      before_called = true
    end
    
    @game_object.on_after_y_changes do
      after_called = true
    end
    
    @game_object.y = 5
    before_called.should be_true
    after_called.should be_true
  end
end