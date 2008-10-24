# Allows control of a TangibleSprite in a platformer environment.
# Respects multiple players
# TODO: Consider moving some of this to a general platformer behavior
#       This behavior will know if it is on the ground
# TODO: Make a CardinalMovable, for moving N E S W
# TODO: Allow Walljumping?
# TODO: Jump-platform exclusion list
# TODO: Stateful behavior to know when we're jumping, walking, jumping + shooting, walking + shooting, etc
class PlatformerControllable < Gemini::Behavior
  depends_on :RecievesEvents
  depends_on :MultiAnimatedSprite
  depends_on :TangibleSprite
  depends_on :Timeable
#  depends_on :AxisStateful
  
  declared_methods :set_player_number, :player_number=, :player_number, :grounded?, :facing_direction
  attr_accessor :player_number
  
  def load
#    @target.set_state_transitions_on_axis[:vertical_platform]   = [:grounded, :jumping, :falling]
#    @target.set_state_transitions_on_axis[:horizontal_platform] = [:walking, :standing]
    @target.set_mass 1
    #set_damping 0.1
    @target.set_friction 0
    @target.set_speed_limit(Vector.new(20, 50))
    @target.set_rotatable false
    @horizontal_speed = 100
    @jump_force = 20000
    @facing_right = true
    @target.on_update do
      detect_grounded
      if @moving && grounded?
        @target.animate :walk
      elsif !@moving && grounded?
        @target.animate :stand
      else
        @target.animate :jump
      end
      
      if @moving
        # causes smooth movement
        velocity = @target.velocity
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
        
        @target.set_velocity(velocity)
      else
        # comment out to allow for momentum?
        @target.add_velocity(-@target.velocity.x, 0)
      end
    end
#    @target.on_collided do |message|
#      # The collision event hasn't been resolved yet, so we can't check all of our collisions yet
#      # Queue up the collision check for the next update.
#      @check_grounded_on_next_update = true
#      #@target.gravity_effected = false
#    end
  end
  
  def grounded?
    @grounded
  end
  
  def facing_direction
    @facing_right ? :east : :west
  end
  
  def player_number=(player_number)
    @player_number = player_number
    @target.handle_event :"p#{player_number}_start_platformer_movement" do |message|
      start_platform_move(message)
    end
    @target.handle_event :"p#{player_number}_stop_platformer_movement" do |message|
      stop_platform_move(message)
    end
    @target.handle_event :"p#{player_number}_platformer_jump" do |message|
      platform_jump(message)
    end
  end
  alias_method :set_player_number, :player_number=
  
  def start_platform_move(message)
    @moving = true
    if grounded?
      @target.animate :walk
    else
      @target.animate :jump
    end
    case message.value
    #TODO: Up and down for ladders (aka PlatformerClimbables)
    when :left
      @target.flip_horizontally if @facing_right
      @facing_right = false
      @target.add_force(-@horizontal_speed, 0)
    when :right
      @target.flip_horizontally unless @facing_right
      @facing_right = true
      @target.add_force( @horizontal_speed, 0)
    end
  end
  
  def stop_platform_move(message)
    if grounded?
      @target.animate :stand
    else
      @target.animate :jump
    end
    case message.value
    when :left
      @moving = false unless @facing_right
    when :right
      @moving = false if @facing_right
    end
  end
  
  def platform_jump(message)
    detect_grounded
    if grounded?
      puts "jump!"
      @target.animate :jump
      # This should help us get the object unstuck if it's sunk a little into another body
      # Although, this might also get us stuck too
      # TODO: Test to see if super low cielings cause PlatformerControllable to get stuck.
      @target.move(@target.x, @target.y - 10)
      #@target.add_force(0, -@jump_force)
      # addForce doesn't always get added. Perhaps a Phys2D bug?
      @target.add_velocity(0, -@jump_force)
      @grounded = false
    end
  end
  
  def detect_grounded
    @target.get_collision_events.each do |collision_event|
      # shameless rip/port from Kevin Glass's platformer example, with his comments
      # if the point of collision was below the centre of the actor
      # i.e. near the feet
      if collision_event.point.y > (@target.y + (@target.height / 4))
        # check the normal to work out which body we care about
        # if the right body is involved and a collision has happened
        # below it then we're on the ground
        if (collision_event.normal.y <  0) && (collision_event.body_b.user_data == @target) ||
           (collision_event.normal.y >  0) && (collision_event.body_a.user_data == @target) 
           @grounded = true
           #@target.transfer_state_on_axis :grounded, :grounded
           return true
        end
      end
    end
#    jumping_or_falling = @target.velocity.y > 0 ? :jumping : :falling
#    @target.transfer_state_on_axis :grounded, jumping_or_falling
    @grounded = false
    false
  end
end