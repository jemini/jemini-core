class Car < Gemini::GameObject
  attr_accessor :facing_in_degrees
  
  has_behavior :VectoredMovement
  
  def load
    behavior_event_alias(:VectoredMovement, :move => :p1_move)
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
#  def calculate_next_movement
#    relative_degrees = @facing_in_degrees % 90
#    w = Math.sin(Gemini::Math.degrees_to_radians(relative_degrees))
#    h = Math.cos(Gemini::Math.degrees_to_radians(relative_degrees))
#
#    if @facing_in_degrees <= 90
#      x_delta = w
#      y_delta = -h
#    elsif @facing_in_degrees > 90 && @facing_in_degrees <= 180
#      x_delta = h
#      y_delta = w
#    elsif @facing_in_degrees > 180 && @facing_in_degrees <= 270
#      x_delta = -w
#      y_delta = h
#    elsif @facing_in_degrees > 270
#      x_delta = -h
#      y_delta = -w
#    end
#    return x_delta, y_delta
#  end
end