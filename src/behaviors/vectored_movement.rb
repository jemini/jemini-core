class VectoredMovement < Gemini::Behavior
  attr_accessor :facing_in_degrees
  
  depends_on :Tangible
  depends_on :RecievesEvents
  
  def load
    @target.set_damping 0.1
    @target.set_angular_damping 0.1
    @facing_in_degrees = 0
    
    @forward_speed = 3
    @reverse_speed = -1
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
      
      @target.set_angular_velocity @angular_velocity
      @target.add_velocity(@movement_vector)
    end
  end
  
  def begin_acceleration(message)
    speed = :forward == message.value ? @forward_speed : @reverse_speed
    @movement_vector = Vector.from_polar_vector(speed, @facing_in_degrees)
  end
  
  def end_acceleration(message)
    @movement_vector = Vector.new(0,0)
  end
  
  def begin_turn(message)
    if :clockwise == message.value
      @angular_velocity = 0.01
    else
      @angular_velocity = -0.01
    end
  end
  
  def end_turn(message)
    @angular_velocity = 0
  end 
end