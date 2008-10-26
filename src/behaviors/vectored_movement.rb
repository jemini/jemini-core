class VectoredMovement < Gemini::Behavior
  attr_accessor :forward_speed, :reverse_speed, :rotation_speed
  alias_method :set_forward_speed, :forward_speed=
  alias_method :set_reverse_speed, :reverse_speed=
  alias_method :set_rotation_speed, :rotation_speed=
  
  depends_on :Tangible
  depends_on :RecievesEvents
  
  declared_methods :forward_speed, :set_forward_speed, :forward_speed=,
                   :reverse_speed, :set_reverse_speed, :reverse_speed=,
                   :rotation_speed, :set_rotation_speed, :rotation_speed=
  def load
    @target.set_damping 0.0
    @target.set_angular_damping 0.0
    
    @forward_speed = 0
    @reverse_speed = 0
    @rotation_speed = 0
    
    @intended_velocity = 0
    @angular_velocity = 0
    @movement_vector = Vector.new(0,0)
    
    @target.on_update do
      @target.set_angular_velocity(@angular_velocity)
      @target.add_velocity(Vector.from_polar_vector(@intended_velocity, @target.rotation))
    end
  end
  
  def begin_acceleration(message)
    @intended_velocity = :forward == message.value ? @forward_speed : @reverse_speed
  end
  
  def end_acceleration(message)
    @intended_velocity = 0
  end
  
  def begin_turn(message)
    if :clockwise == message.value
      @angular_velocity = @rotation_speed
    else
      @angular_velocity = -@rotation_speed
    end
  end
  
  def end_turn(message)
    @angular_velocity = 0
  end 
end