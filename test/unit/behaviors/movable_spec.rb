require 'spec_helper'
require 'behaviors/movable'

describe 'Movable' do
  before :each do
    @game_object = Gemini::GameObject.new(@state)
    @game_object.add_behavior(:Movable)
  end

  it 'notifies listeners when moving'

  describe '#move' do
    it 'accepts a speed'
    #TODO: Movable expects a polar vector. Make sure we build our vectors this way so the test data makes sense!
    
    # TODO: Create spec helper that detects if method is wrapped with callbacks
#    it "notifies listeners when move is performed" do
#      @game_object.should_receive :on_before_move
#      @game_object.should_receive :on_after_move
#
#      @game_object.move(1.0, 2.0)
#    end
    it 'updates the position of the game object on update' do
      @game_object.position = Vector.new(0.0, 0.0)
      @game_object.movable_speed = 1.0
      @game_object.move Vector.new(2.0, 3.0)
      @game_object.update(10)

      @game_object.x.should > 2.0
      @game_object.y.should > 3.0
    end

    it 'moves faster with a higher update delta' do
      @game_object.position = Vector.new(0.0, 0.0)
      @game_object.movable_speed = 1.0
      @game_object.move Vector.new(5.0, 6.0)

      @game_object.update(10)
      slow_result = @game_object.position.dup

      @game_object.position = Vector.new(0.0, 0.0)
      @game_object.update(100)
      fast_result = @game_object.position

      slow_result.x.should < fast_result.x
      slow_result.y.should < fast_result.y
    end

    it 'cancels a #move_to call made before it'
    it 'fires position_changed even if movement overshot the destination'
    it 'moves in a radial fashion (no double-vectoring)'
  end

  describe '#move_to' do
    it 'accepts a speed'
    it 'cancels a #move call made before it'
    it 'stops moving after it arrives'

    it 'eventually ends up at the destination' do
      @game_object.movable_speed = 1.0
      @game_object.position = Vector.new(0.0, 0.0)
      @game_object.move_to Vector.new(10.0, 20.0)
      @game_object.update(10)
      @game_object.position.should_not be_near(Vector.new(10.0, 20.0), 0.1)
      @game_object.update(10)
      @game_object.update(10)
      @game_object.position.should be_near(Vector.new(10.0, 20.0), 0.1)
    end
  end
end
