class Car < Gemini::GameObject
  attr_accessor :facing_in_degrees
  
  has_behavior :VectoredMovement
  has_behavior :TangibleSprite
  
  def load
    set_bounded_image "car.png"
    
    set_forward_speed 5
    set_reverse_speed -2
    set_rotation_speed 0.2
    
    set_angular_damping 0.1
    set_damping 0.1
    
    behavior_event_alias :VectoredMovement, :start_move do |message|
      case message.value
      when :up
        message.value = :forward
        :begin_acceleration
      when :down
        message.value = :reverse
        :begin_acceleration
      when :right
        message.value = :clockwise
        :begin_turn
      when :left
        message.value = :counter_clockwise
        :begin_turn
      end
    end
    
    behavior_event_alias :VectoredMovement, :stop_move do |message|
      case message.value
      when :up
        message.value = :forward
        :end_acceleration
      when :down
        message.value = :reverse
        :end_acceleration
      when :right
        message.value = :clockwise
        :end_turn
      when :left
        message.value = :counter_clockwise
        :end_turn
      end
    end
  end
end