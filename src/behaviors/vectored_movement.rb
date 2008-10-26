class VectoredMovement < Gemini::Behavior
  attr_accessor :facing_in_degrees
  
  depends_on :Tangible
  depends_on :RecievesEvents
  
  def load
    @target.set_damping 0.0
    @target.set_angular_damping 0.0
    @facing_in_degrees = 0
    @velocity = 0
    @forward_speed = 3
    @reverse_speed = -1
    @rotation_speed = 0.1
    @angular_velocity = 0
    @movement_vector = Vector.new(0,0)
    
    @target.on_update do
#      if @rotating
#        puts "rotation rate: #{@rotation_rate}"
#        @facing_in_degrees += @rotation_rate
#        @facing_in_degrees %= 360
#        @target.set_rotation @facing_in_degrees
#        @movement_vector = Vector.from_polar_vector(@forward_speed, @facing_in_degrees)
#      end
      @target.set_angular_velocity(@angular_velocity * @rotation_speed)
      @target.add_velocity(Vector.from_polar_vector(@velocity, @target.rotation))
    end
  end
  
  def begin_acceleration(message)
    @velocity = :forward == message.value ? @forward_speed : @reverse_speed
  end
  
  def end_acceleration(message)
    @velocity = 0
  end
  
  def begin_turn(message)
    if :clockwise == message.value
      @angular_velocity = 1
    else
      @angular_velocity = -1
    end
  end
  
  def end_turn(message)
    @angular_velocity = 0
  end 
end