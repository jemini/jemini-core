require 'spec_helper'
require 'behaviors/grid_bound'

describe "GridBound" do
  it_should_behave_like "initial mock state"

  before :each do
    @game_object = Jemini::GameObject.new(@state)
    @game_object.add_behavior :GridBound
  end

  it "depends on Movable" do
    @game_object.should have_behavior(:Movable)
  end

  it "depends on Spatial" do
    @game_object.should have_behavior(:Spatial)
  end

  describe '#adjacent_grids' do
    it 'returns the nearby 8 grids' do
      @game_object.adjacent_grids.should have(8).grids
    end
  end

  describe '#move_to_adjacent_grid' do
    it 'can move in a direction along the grid to another grid' do
      @game_object.movable_speed = 1
      @game_object.move_to_adjacent_grid(:right)
      @game_object.update(10)
      @game_object.grid_position.should == Vector.new(0, 0)
      @game_object.update(40)
      @game_object.grid_position.should == Vector.new(1, 0)
      @game_object.position.should be_near(Vector.new(48.0, 16.0), 1.0)
    end

  end

  describe '#snap_to_grid' do
    it 'sets the Spatial position to the nearest grid' do
      @game_object.position = Vector.new(50.0, 12.0)
      @game_object.snap_to_grid
      @game_object.position.should be_near(Vector.new(48.0, 16.0), 1.0)
    end

    it 'snaps to the nearest grid location' do
      @game_object.position = Vector.new(320.0, 640.0)
      @game_object.snap_to_grid
      @game_object.grid_position.should == Vector.new(10, 20)
    end
  end
  
  describe '#grid_size' do
    it "defaults to 32x32 by default" do
      @game_object.grid_size.x.should == 32
      @game_object.grid_size.y.should == 32
    end
  end

  describe '#grid_changed' do
    it 'is wrapped with callbacks' do
      @grid_changed = false

      @game_object.on_grid_changed do
        @grid_changed = true
      end
      
      @grid_changed.should be_false
      @game_object.movable_speed = 34.0 / 2.0
      @game_object.move Vector.new(1.0, 0.0)
      @game_object.update(1)
      @grid_changed.should be_false
      @game_object.update(1)
      @grid_changed.should be_true
    end
  end
  
  describe '#grid_position=' do
    it "sets the position of the game object to the center of the grid" do
      @game_object.grid_position = Vector.new(2, 1)
      @game_object.position.x.should be_close(64 + 16, 0.01)
      @game_object.position.y.should be_close(32 + 16, 0.01)
    end

    it "sets the value used for #grid_position" do
      @game_object.grid_position = Vector.new(2, 3)
      @game_object.grid_position.x.should == 2
      @game_object.grid_position.y.should == 3
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

    it 'supports dianganol directions' do
      @game_object.grid_position = Vector.new(5, 4)
      @game_object.adjacent_grid(:north_west).should == Vector.new(4, 5)
    end

    it 'supports up/down as directions' do
      @game_object.grid_position = Vector.new(4, 8)
      @game_object.adjacent_grid(:up).should == Vector.new(4, 9)

      @game_object.grid_position = Vector.new(4, 8)
      @game_object.adjacent_grid(:down).should == Vector.new(4, 7)
    end
  end
end