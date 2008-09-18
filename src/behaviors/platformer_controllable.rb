# Allows control of a TangibleSprite in a platformer environment.
# Respects multiple players
# TODO: Consider moving some of this to a general platformer behavior
#       This behavior will know if it is on the ground
# TODO: Make a CardinalMovable, for moving N E S W
# TODO: Allow Walljumping?
# TODO: Jump-platform exclusion list
class PlatformerControllable < Gemini::Behavior
  depends_on :RecievesEvents
  depends_on :MultiAnimatedSprite
  depends_on :TangibleSprite
  depends_on :Timeable
  
  declared_methods :set_player_number, :player_number=, :player_number, :grounded?
  attr_accessor :player_number
  
  def load
    set_mass 1
    #set_damping 0.1
    set_friction 0
    set_speed_limit(Vector.new(20, 50))
    set_rotatable false
    @horizontal_speed = 100
    @jump_force = 20000
    @platform_state = :grounded
    @target.on_update do
      if @moving
        # causes smooth movement
        velocity = @target.velocity
        velocity.x = @facing_right ? @horizontal_speed : -@horizontal_speed
        @target.set_velocity(velocity)
      else
        # comment out to allow for momentum?
        @target.add_velocity(-@target.velocity.x, 0)
      end
    end
    @target.on_collided do |message|
      @platform_state = :grounded
      #@target.gravity_effected = false
    end
    #TODO: Configure some basic animations (standing, jumping, falling, running)
    
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
    animate :walk
    case message.value
    #TODO: Up and down for ladders (aka PlatformerClimbables)
    when :left
      @facing_right = false
      @target.add_force(-@horizontal_speed, 0)
    when :right
      @facing_right = true
      @target.add_force( @horizontal_speed, 0)
    end
  end
  
  def stop_platform_move(message)
    puts "stopping move for #{message.value}"
    animate :stand
    case message.value
    when :left
      @moving = false unless @facing_right
    when :right
      @moving = false if @facing_right
    end
  end
  
  def platform_jump(message)
    #if :grounded == @platform_state
    if grounded?
      puts "jump!"
      @target.gravity_effected = true
      @platform_state = :jumping
      @target.add_countdown(:jump, 1.0, 0.2)
      @target.add_force(0, -@jump_force) if :jumping == @platform_state
    end
  end
  
  def grounded?
    @target.get_collision_events.each do |event|
      # shameless rip/port from Kevin Glass's platformer example, with his comments
      # if the point of collision was below the centre of the actor
      # i.e. near the feet
      if event.point.y > (y + (height / 4))
        # check the normal to work out which body we care about
        # if the right body is involved and a collision has happened
        # below it then we're on the ground
        return true if (event.normal.y < -0) && (event.body_b.user_data == @target)
        return true if (event.normal.y >  0) && (event.body_a.user_data == @target)
      end
    end
    false
  end
end