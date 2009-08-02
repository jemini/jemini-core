require 'spec_helper'
require 'behaviors/grid_bound'

describe "GridBound" do
  it_should_behave_like "initial mock state"

  before :each do
    @game_object = Gemini::GameObject.new(@state)
    @game_object.add_behavior :GridBound
  end

  describe '#grid_size' do
    it "defaults to 32x32 by default" do
      @game_object.grid_size.x.should be_close(32, 0.01)
      @game_object.grid_size.y.should be_close(32, 0.01)
    end
  end
  
  describe '#grid_position=' do
    it "sets the position of the game object to the center of the grid" do
      @game_object.grid_position = Vector.new(2, 1)
      @game_object.position.x.should be_close(64 + 16, 0.01)
      @game_object.position.y.should be_close(32 + 16, 0.01)
    end

    it "sets the value used for #grid_position" do
      @game_object.grid_position = Vector.new(2.0, 3.0)
      @game_object.grid_position.x.should be_close(2.0, 0.01)
      @game_object.grid_position.y.should be_close(3.0, 0.01)
    end
  end

  describe 'adjacent_grid' do
    it 'determines grids to the left of the current grid' do
      @game_object.grid_position = Vector.new(2, 3)
      @game_object.adjacent_grid(:left).should == Vector.new(1, 3)
    end

    it 'determines grids to the right of the current grid' do
      @game_object.grid_position = Vector.new(2, 3)
      @game_object.adjacent_grid(:right).should == Vector.new(3, 3)
    end

    it 'determines grids to the top of the current grid' do
      @game_object.grid_position = Vector.new(2, 3)
      @game_object.adjacent_grid(:top).should == Vector.new(2, 4)
    end

    it 'determines grids to the bottom of the current grid' do
      @game_object.grid_position = Vector.new(2, 3)
      @game_object.adjacent_grid(:bottom).should == Vector.new(2, 2)
    end

    it 'supports cardinal directions' do
      @game_object.grid_position = Vector.new(5, 4)
      @game_object.adjacent_grid(:west).should == Vector.new(4, 4)

      @game_object.grid_position = Vector.new(5, 4)
      @game_object.adjacent_grid(:east).should == Vector.new(6, 4)

      @game_object.grid_position = Vector.new(5, 4)
      @game_object.adjacent_grid(:north).should == Vector.new(5, 5)

      @game_object.grid_position = Vector.new(5, 4)
      @game_object.adjacent_grid(:south).should == Vector.new(5, 3)
    end

    it 'supports up/down as directions' do
      @game_object.grid_position = Vector.new(4, 8)
      @game_object.adjacent_grid(:up).should == Vector.new(4, 9)

      @game_object.grid_position = Vector.new(4, 8)
      @game_object.adjacent_grid(:down).should == Vector.new(4, 7)
    end
  end
end