require 'spec_helper'
require 'behaviors/physical'

MARGIN = 0.001
MILLISECONDS = 1000.0

describe "Physical" do
  
  def do_update
    @state.manager(:update).update(MILLISECONDS)
  end
  
  before :each do
    @state = TestState.new(mock('Container', :null_object => true), mock('Game', :null_object => true))
    @state.set_manager(:physics, @state.create(:BasicPhysicsManager))
    @game_object = @state.create :GameObject, :Physical
  end
  
  describe "#add_force" do
    it "moves the object" do
      starting_location = Vector.new(0.0, 0.0)
      @game_object.set_body_position(starting_location)
      @game_object.add_force(Vector.new(1.0, 1.0))
      do_update
      @game_object.body_position.x.should > starting_location.x
      @game_object.body_position.y.should > starting_location.y
    end
    
    it "moves more massive objects less distance with the same force" do
      force = Vector.new(1.0, 0.0)
      @game_object.mass = 1.0
      @game_object.add_force(force)
      @big_object = @state.create :GameObject, :Physical
      @big_object.body_position.y = @game_object.body_position.y + 1000.0
      @big_object.mass = 2.0
      @big_object.add_force(force)
      do_update
      @big_object.body_position.x.should < @game_object.body_position.x
    end
  end
  
  describe "#add_velocity" do
    it "adds a velocity to the object" do
      @game_object.add_velocity(Vector.new(1.0, 1.0))
      do_update
      @game_object.velocity.x.should be_close(1.0, MARGIN)
      @game_object.velocity.y.should be_close(1.0, MARGIN)
    end
    it "is cumulative" do
      @game_object.add_velocity(Vector.new(1.0, 1.0))
      @game_object.add_velocity(Vector.new(1.0, 1.0))
      do_update
      @game_object.velocity.x.should be_close(2.0, MARGIN)
      @game_object.velocity.y.should be_close(2.0, MARGIN)
    end
    it "is negatable" do
      @game_object.add_velocity(Vector.new(1.0, 1.0))
      @game_object.add_velocity(Vector.new(-1.0, -1.0))
      do_update
      @game_object.velocity.x.should be_close(0.0, MARGIN)
      @game_object.velocity.y.should be_close(0.0, MARGIN)
    end
  end
  
  describe "#add_excluded_physical" do
    it "allows the object to occupy the same space as the given target" do
      @other_object = @state.create :GameObject, :Physical
      @game_object.body_position = Vector.new(1.0, 1.0)
      @other_object.body_position = Vector.new(1.0, 1.0)
      @game_object.add_excluded_physical(@other_object)
      do_update
      @game_object.body_position.x.should be_close(1.0, MARGIN)
      @game_object.body_position.y.should be_close(1.0, MARGIN)
      @other_object.body_position.x.should be_close(1.0, MARGIN)
      @other_object.body_position.y.should be_close(1.0, MARGIN)
    end
  end
  
  describe "#angular_damping=" do
    it "slows rotation continually when angular damping is applied" do
      @game_object.angular_velocity = 1.0
      @game_object.angular_damping = 1.0
      do_update
      @game_object.angular_velocity.should < 1.0
      old_value = @game_object.angular_velocity
      do_update
      @game_object.angular_velocity.should < old_value
    end
    it "does not slow if angular damping is zero" do
      @game_object.angular_velocity = 1.0
      @game_object.angular_damping = 0.0
      do_update
      @game_object.angular_velocity.should be_close(1.0, MARGIN)
    end
  end
  
  
  describe "#angular_velocity=" do
    it "sets the object's angular velocity to an absolute value" do
      @game_object.angular_velocity = 1.0
      do_update
      @game_object.angular_velocity.should be_close(1.0, MARGIN)
    end
    it "works even if the object is already rotating" do
      @game_object.apply_angular_velocity(100.0)
      do_update
      @game_object.angular_velocity = 1.0
      do_update
      @game_object.angular_velocity.should be_close(1.0, MARGIN)
    end
  end
  
  describe "#apply_angular_velocity" do
    it "adds to the object's angular velocity" do
      @game_object.apply_angular_velocity(1.0)
      do_update
      @game_object.angular_velocity.should be_close(1.0, MARGIN)
    end
    it "is cumulative" do
      @game_object.apply_angular_velocity(1.0)
      @game_object.apply_angular_velocity(1.0)
      do_update
      @game_object.angular_velocity.should be_close(2.0, MARGIN)
    end
    it "is negatable" do
      @game_object.apply_angular_velocity(1.0)
      @game_object.apply_angular_velocity(-1.0)
      @game_object.angular_velocity.should be_close(0.0, MARGIN)
    end
  end
  
  describe "#come_to_rest" do
    it "stops moving" do
      @game_object.velocity = Vector.new(1.0, 1.0)
      do_update
      old_position = @game_object.body_position
      @game_object.come_to_rest
      @game_object.velocity.x.should be_close(0.0, MARGIN)
      @game_object.velocity.y.should be_close(0.0, MARGIN)
      do_update
      new_position = @game_object.body_position
      old_position.x.should be_close(new_position.x, MARGIN)
      old_position.y.should be_close(new_position.x, MARGIN)
    end
    it "stops rotating" do
      @game_object.angular_velocity = 1.0
      @game_object.come_to_rest
      @game_object.angular_velocity.should be_close(0.0, MARGIN)
    end
  end
  
  describe "#exclude_all_physicals" do
    it "causes the object not to interact even with new objects" do
      @game_object.exclude_all_physicals
      @other_object = @state.create :GameObject, :Physical
      @game_object.body_position = Vector.new(1.0, 1.0)
      @other_object.body_position = Vector.new(1.0, 1.0)
      do_update
      @game_object.body_position.x.should be_close(1.0, MARGIN)
      @game_object.body_position.y.should be_close(1.0, MARGIN)
      @other_object.body_position.x.should be_close(1.0, MARGIN)
      @other_object.body_position.y.should be_close(1.0, MARGIN)
    end
  end
  
  describe "#friction=" do
    it "slows continually when friction is applied" do
      @game_object.velocity = Vector.new(1.0, 0.0)
      @game_object.friction = 1.0
      do_update
      @game_object.velocity.x.should < 1.0
      old_x = @game_object.velocity.x
      do_update
      @game_object.velocity.x.should < old_x
    end
    it "does not slow if friction is zero" do
      @game_object.velocity = Vector.new(1.0, 0.0)
      @game_object.friction = 0.0
      do_update
      @game_object.velocity.x.should be_close(1.0, MARGIN)
    end
  end
  
  describe "#get_collision_events" do
    it "returns events for objects currently colliding with this one" do
      @other_object = @state.create :GameObject, :Physical
      @game_object.body_position = Vector.new(1.0, 1.0)
      @other_object.body_position = Vector.new(1.0, 1.0)
      do_update
      @game_object.get_collision_events.should_not be_empty
      @game_object.get_collision_events.first.other.should == @other_object
    end
    it "does not return any events if there was no collision" do
      @other_object = @state.create :GameObject, :Physical
      @game_object.body_position = Vector.new(1.0, 1.0)
      @other_object.body_position = Vector.new(100.0, 100.0)
      do_update
      @game_object.get_collision_events.should be_empty
    end
    it "does not return any events if other object is excluded from physical interaction" do
      @other_object = @state.create :GameObject, :Physical
      @game_object.add_excluded_physical(@other_object)
      @game_object.body_position = Vector.new(1.0, 1.0)
      @other_object.body_position = Vector.new(1.0, 1.0)
      do_update
      @game_object.get_collision_events.should be_empty
    end
  end
  
  describe "#gravity_effected=" do
    before :each do
      @state.manager(:physics).gravity = 1.0
    end
    it "turns gravity on for object when true" do
      @game_object.gravity_effected = true
      old_position = @game_object.body_position
      do_update
      @game_object.body_position.y.should > old_position.y
    end
    it "turns gravity off for object when false" do
      @game_object.gravity_effected = false
      old_position = @game_object.body_position
      do_update
      @game_object.body_position.y.should be_close(old_position.y, MARGIN)
    end
  end
  
  describe "#set_static_body" do
    it "becomes immobile" do
      @game_object.body_position = Vector.new(1.0, 1.0)
      @game_object.set_static_body
      @other_object = @state.create :GameObject, :Physical
      @other_object.body_position = Vector.new(1.0, 1.0)
      do_update
      @game_object.body_position.x.should be_close(1.0, MARGIN)
      @game_object.body_position.y.should be_close(1.0, MARGIN)
    end
    it "stops moving" do
      @game_object.velocity = Vector.new(1.0, 1.0)
      do_update
      old_position = @game_object.body_position
      @game_object.set_static_body
      do_update
      @game_object.body_position.x.should be_close(old_position.x, MARGIN)
      @game_object.body_position.y.should be_close(old_position.y, MARGIN)
    end
    it "stops rotating" do
      @game_object.angular_velocity = 1.0
      do_update
      @game_object.set_static_body
      old_rotation = @game_object.physical_rotation
      do_update
      @game_object.physical_rotation.should be_close(old_rotation, MARGIN)
    end
  end
  
  describe "#speed_limit" do
    it "restricts the object to the given x/y velocity" do
      @game_object.speed_limit = Vector.new(1.0, 1.0)
      @game_object.add_force(Vector.new(100000.0, 1000000.0))
      do_update
      @game_object.velocity.x.should be_close(1.0, MARGIN)
      @game_object.velocity.y.should be_close(1.0, MARGIN)
    end
  end
  
  describe "#velocity=" do
    it "sets the object's velocity to an absolute value" do
      @game_object.velocity = Vector.new(1.0, 1.0)
      do_update
      @game_object.velocity.x.should be_close(1.0, MARGIN)
      @game_object.velocity.y.should be_close(1.0, MARGIN)
    end
    it "works even if the object is already moving" do
      @game_object.add_velocity(Vector.new(100000.0, 100000.0))
      do_update
      @game_object.velocity = Vector.new(1.0, 1.0)
      do_update
      @game_object.velocity.x.should be_close(1.0, MARGIN)
      @game_object.velocity.y.should be_close(1.0, MARGIN)
    end
  end
    
end
