require 'game_object'
require 'behaviors/movable_2d'

describe Movable2D, "#move" do
  class Movable2DGameObject < Gemini::GameObject
    has_behavior :Movable2D
  end
  
  before(:each) do
    @game_object = Movable2DGameObject.new
  end
  
  it "sets the x and y coordinates of the game object" do
    @game_object.x.should == 0
    @game_object.y.should == 0
    @game_object.move(5,12)
    @game_object.x.should == 5
    @game_object.y.should == 12
  end
  
  it "notifies listeners when move is performed" do
    before_called = false
    after_called = false
    
    @game_object.on_before_move { before_called = true }
    @game_object.on_after_move { after_called = true }
    
    @game_object.move(1,2)
    
    before_called.should be_true
    after_called.should be_true
  end
end