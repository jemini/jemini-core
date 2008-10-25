class Car < Gemini::GameObject
  attr_accessor :facing_in_degrees
  
  has_behavior :VectoredMovement
  has_behavior :TangibleSprite
  
  def load
    set_bounded_image "car.png"
    
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
#  CAR_FORWARD_SPEED = 5
#  CAR_REVERSE_SPEED = -1
#  CAR_ROTATION_SPEED = 1.5
#  
#  def load
#    set_bounded_image "car.png"
#    handle_event :move, :movement
#    @facing_in_degrees = 0
#  end
#  
#  def movement(message)
#    case message.value
#   #   relative degrees
#   #       |   direction we want to move
#   #       v     ^
#   #   |       /
#   #   |     /
#   # h |   /
#   #   | / 
#   #   --------------------
#   #         w
#    
#    when :up #forward
#      x_delta, y_delta = calculate_next_movement
#      move(x + x_delta * CAR_FORWARD_SPEED, y + y_delta * CAR_FORWARD_SPEED)
#    when :down #reverse
#      x_delta, y_delta = calculate_next_movement
#      move(x + x_delta * CAR_REVERSE_SPEED, y + y_delta * CAR_REVERSE_SPEED)
#    when :right #turn right
#      @facing_in_degrees += 1
#      @facing_in_degrees %= 360
#      set_rotation @facing_in_degrees
#    when :left #turn left
#      @facing_in_degrees -= 1
#      @facing_in_degrees %= 360
#      set_rotation @facing_in_degrees
#    end
#  end
# 
end