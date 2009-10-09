#Allows an object to accelerate and turn within a 2D plane.
class TopDownVehicle < Jemini::Behavior
  attr_accessor :minimum_speed_to_turn
  alias_method :set_minimum_speed_to_turn, :minimum_speed_to_turn=
  
  depends_on :VectoredMovement
  
  def load
    @vm_behavior = @game_object.send(:instance_variable_get, :@__behaviors)[:VectoredMovement]
    @game_object.set_damping 0.1
    @game_object.set_angular_damping 0.1
    @minimum_speed_to_turn = 2.5
    @vectored_movement_turning = false
    
    #TODO: Replace this with a spline method that determines how far to turn based on the spline
    @game_object.on_update do
      if @turning && !@vectored_movement_turning && (@game_object.velocity.x.abs + @game_object.velocity.y.abs) > @minimum_speed_to_turn
        @at_beginning_of_turn.call
        @vectored_movement_turning = true
      end
    end
  end
  
  def begin_acceleration(message)
    @vm_behavior.begin_acceleration(message)
  end
  
  def end_acceleration(message)
    @vm_behavior.end_acceleration(message)
  end
  
  def begin_turn(message)
    @turning = true
    @at_beginning_of_turn = Proc.new { @vm_behavior.begin_turn(message) }
  end
  
  def end_turn(message)
    @turning = false
    @vm_behavior.end_turn(message)
    @vectored_movement_turning = false
  end
end