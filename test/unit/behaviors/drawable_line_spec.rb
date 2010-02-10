require 'spec_helper'
require 'behaviors/drawable_line'

describe 'DrawableLine' do
  
  before :each do
    @state = TestState.new(mock('Container', :null_object => true), mock('Game', :null_object => true))
    @game_object = @state.create :GameObject, :DrawableLine
  end
  
  it "accepts a position and line end position" do
    @game_object.position = Vector.new(25, 50)
    @game_object.line_end_position = Vector.new(100, 150)
    graphics = mock('Graphics', :null_object => true)
    graphics.should_receive(:draw).with do |line|
      line.x1.should be_close(25, MARGIN)
      line.y1.should be_close(50, MARGIN)
      line.x2.should be_close(100, MARGIN)
      line.y2.should be_close(150, MARGIN)
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
    
end
