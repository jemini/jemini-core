class Car < Gemini::GameObject
  attr_accessor :facing_in_degrees
  
  has_behavior :TangibleSprite
  has_behavior :RecievesEvents
  
  CAR_FORWARD_SPEED = 3
  CAR_ROTATION_SPEED = 1
  
  def load
    set_bounded_image "car.png"
    handle_event :move, :movement
    @facing_in_degrees = 0
  end
  
  def movement(message)
    case message.value
    
   #  |       /
   #  |     /
   #h |   /
   #  | /
   #  ------------- 
   #        w
    
    when :up #forward
      relative_degrees = @facing_in_degrees % 90
      x_delta = CAR_FORWARD_SPEED * Math.sin(degrees_to_radians(relative_degrees))
      y_delta = -CAR_FORWARD_SPEED * Math.cos(degrees_to_radians(relative_degrees))
      
      if @facing_in_degrees > 90 && @facing_in_degrees <= 180
        y_delta, x_delta = x_delta, y_delta
        x_delta *= -1
      elsif @facing_in_degrees > 180 && @facing_in_degrees <= 270
        x_delta *= -1
        y_delta *= -1
      elsif @facing_in_degrees > 270
        x_delta *= -1
      end
      
      puts "x: #{x_delta}, y: #{y_delta}"
      move(x + x_delta, y + y_delta)
    when :down #reverse
      
    when :right #turn right
      @facing_in_degrees += 1
      @facing_in_degrees %= 360
      set_rotation @facing_in_degrees
    when :left #turn left
      @facing_in_degrees -= 1
      @facing_in_degrees %= 360
      set_rotation @facing_in_degrees
    end
  end
  
  def degrees_to_radians(degrees)
    degrees * (Math::PI/180)
  end
  
  def radians_to_degrees(radians)
    radians * (180/Math::PI)
  end
end