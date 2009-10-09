# Allows control of a PhysicalSprite in a platformer environment.
# TODO: Consider moving some of this to a general platformer behavior
#       This behavior will know if it is on the ground
# TODO: Make a CardinalMovable, for moving N E S W
# TODO: Allow Walljumping?
# TODO: Jump-platform exclusion list
# TODO: Stateful behavior to know when we're jumping, walking, jumping + shooting, walking + shooting, etc
class PlatformerControllable < Jemini::Behavior
  depends_on :HandlesEvents
  depends_on :MultiAnimatedSprite
  depends_on :PhysicalSprite
  depends_on :Timeable
#  depends_on :AxisStateful
  
  def load
#    @game_object.set_state_transitions_on_axis[:vertical_platform]   = [:grounded, :jumping, :falling]
#    @game_object.set_state_transitions_on_axis[:horizontal_platform] = [:walking, :standing]
    @game_object.set_mass 1
    #set_damping 0.1
    @game_object.set_friction 0
    @game_object.set_speed_limit(Vector.new(20, 50))
    @game_object.set_rotatable false
    @horizontal_speed = 100
    @jump_force = 20000
    @facing_right = true
    @game_object.on_update do
      detect_grounded
      if @moving && grounded?
        @game_object.animate :walk
      elsif !@moving && grounded?
        @game_object.animate :stand
      else
        @game_object.animate :jump
      end
      
      if @moving
        # causes smooth movement
        velocity = @game_object.velocity
        # Another shameless rip of Kevin Glass's code
        # if we've been pushed back from a collision horizontally
        # then kill the velocity - don't want to keep pushing during
        # this frame
        if (velocity.x > 0 && !@facing_right) || (velocity.x < 0 && @facing_right)
          #puts "pushing back"
          velocity.x = 0
        else
          velocity.x = @facing_right ? @horizontal_speed : -@horizontal_speed
        end
        
        @game_object.set_velocity(velocity)
      else
        # comment out to allow for momentum?
        @game_object.add_velocity(-@game_object.velocity.x, 0)
      end
    end
#    @game_object.on_collided do |message|
#      # The collision event hasn't been resolved yet, so we can't check all of our collisions yet
#      # Queue up the collision check for the next update.
#      @check_grounded_on_next_update = true
#      #@game_object.gravity_effected = false
#    end
  end
  
  #Refers to the cached result of detect_grounded to indicate whether the object is touching the ground.
  def grounded?
    @grounded
  end
  
  #Cardinal direction the object is facing, :east or :west.
  def facing_direction
    @facing_right ? :east : :west
  end
  
  #Move the object, setting the appropriate animation and flipping its bitmap in the appropriate direction.
  #Takes a message with :left or :right as its value.  
  def start_move(message)
    @moving = true
    if grounded?
      @game_object.animate :walk
    else
      @game_object.animate :jump
    end
    case message.value
    #TODO: Up and down for ladders (aka PlatformerClimbables)
    when :left
      @game_object.flip_horizontally if @facing_right
      @facing_right = false
      @game_object.add_force(-@horizontal_speed, 0)
    when :right
      @game_object.flip_horizontally unless @facing_right
      @facing_right = true
      @game_object.add_force( @horizontal_speed, 0)
    end
  end
  
  #Halt the object, setting the appropriate animation and flipping its bitmap in the appropriate direction.
  #Takes a message with :left or :right as its value.  
  def stop_move(message)
    if grounded?
      @game_object.animate :stand
    else
      @game_object.animate :jump
    end
    case message.value
    when :left
      @moving = false unless @facing_right
    when :right
      @moving = false if @facing_right
    end
  end
  
  #Add vertical velocity to an object, but only if it's on the ground.
  def jump(message)
    detect_grounded
    if grounded?
      @game_object.animate :jump
      # This should help us get the object unstuck if it's sunk a little into another body
      # Although, this might also get us stuck too
      # TODO: Test to see if super low cielings cause PlatformerControllable to get stuck.
      @game_object.move(@game_object.x, @game_object.y - 10)
      #@game_object.add_force(0, -@jump_force)
      # addForce doesn't always get added. Perhaps a Phys2D bug?
      @game_object.add_velocity(0, -@jump_force)
      @grounded = false
    end
  end
  
  #Determine if the object is touching the ground.
  def detect_grounded
    @game_object.get_collision_events.each do |collision_event|
      # shameless rip/port from Kevin Glass's platformer example, with his comments
      # if the point of collision was below the centre of the actor
      # i.e. near the feet
      if collision_event.point.y > (@game_object.y + (@game_object.height / 4))
        # check the normal to work out which body we care about
        # if the right body is involved and a collision has happened
        # below it then we're on the ground
        if (collision_event.normal.y <  0) && (collision_event.body_b.user_data == @game_object) ||
           (collision_event.normal.y >  0) && (collision_event.body_a.user_data == @game_object) 
           @grounded = true
           #@game_object.transfer_state_on_axis :grounded, :grounded
           return true
        end
      end
    end
#    jumping_or_falling = @game_object.velocity.y > 0 ? :jumping : :falling
#    @game_object.transfer_state_on_axis :grounded, jumping_or_falling
    @grounded = false
    false
  end
end
