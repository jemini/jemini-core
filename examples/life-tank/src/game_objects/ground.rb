class Ground < Gemini::GameObject
  has_behavior :Taggable
  has_behavior :Physical

  def load
    set_static_body
  end
  
  def fill_dimensions(x1, y1, x2, y2)
    width = x2 - x1
    height = y2 - y1
    current_height = rand(height.to_f * 0.6) + (height.to_f * 0.2) + y1
    points = [Vector.new(x2, y2), Vector.new(x1, y2)] # these are the start points
    variance = height.to_f * 0.1
    y_direction = 0
    (0..(width / 30 + 1)).each do |point_width|
      y_direction += (rand(variance) * 2 - variance)
      y_direction = constrain(y_direction, -50, 50)
      current_height += y_direction
      current_height = constrain(current_height, y1, y2 - 20)
      y_direction = 0 if current_height <= y1 or current_height >= y2 - 20
      puts("x1: #{x1}, y1: #{y1}, x2: #{x2}, y2: #{y2}, current_height: #{current_height}, y_direction: #{y_direction}")
      points << Vector.new(point_width * 30, current_height)
    end
    set_shape :Polygon, *points
  end
  
  private
    
    def constrain(value, min, max)
      value = min if value < min
      value = max if value > max
      value
    end
  
end