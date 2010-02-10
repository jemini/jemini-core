require 'spec_helper'
require 'behaviors/drawable_rectangle'

describe 'DrawableRectangle' do
  
  before :each do
    @state = TestState.new(mock('Container', :null_object => true), mock('Game', :null_object => true))
    @game_object = @state.create :GameObject, :DrawableRectangle
  end
  
  it "accepts a position, height, and width" do
    @game_object.position = Vector.new(20, 40)
    @game_object.height = 20
    @game_object.width = 10
    graphics = mock('Graphics', :null_object => true)
    graphics.should_receive(:fill).with do |rectangle|
      rectangle.width.should be_close(10, MARGIN)
      rectangle.height.should be_close(20, MARGIN)
      rectangle.x.should be_close(15, MARGIN) #20 - 10 / 2
      rectangle.y.should be_close(30, MARGIN) #40 - 20 / 2
    end
    @game_object.draw(graphics)
  end
  
  it "accepts a color" do
    @game_object.color = Color.new(0.25, 0.5, 1.0, 0.75)
    graphics = mock('Graphics', :null_object => true)
    graphics.should_receive(:set_color).with do |native_color|
      color = Color.new native_color
      color.red.should be_close(0.25, MARGIN)
      color.green.should be_close(0.5, MARGIN)
      color.blue.should be_close(1.0, MARGIN)
      color.alpha.should be_close(0.75, MARGIN)
    end
    @game_object.draw(graphics)
  end
  
  it "can draw a wireframe" do
    @game_object.rectangle_filled = false
    graphics = mock('Graphics', :null_object => true)
    graphics.should_receive(:draw)
    @game_object.draw(graphics)
  end
    
end
