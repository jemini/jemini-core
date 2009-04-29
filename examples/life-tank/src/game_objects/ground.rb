class Ground < Gemini::GameObject
  has_behavior :Taggable
  has_behavior :Physical
  has_behavior :DrawableShape
  
  def load
    set_static_body
    set_friction 0.9
    set_image @game_state.manager(:render).get_cached_image(:ground)
  end
  
  #  def fill_dimensions(width, height)
  #    points = [Vector.new(width, height), Vector.new(0,height)] # these are the start points
  #    (width / 20).times do |point_width|
  #      rand_height = rand(height.to_f * 0.6) + (height.to_f * 0.2)
  #      points << Vector.new(point_width * 20, rand_height)
  #    end
  #    set_shape :Polygon, *points
  #  end

#  def fill_dimensions(width, height)
#    points = [Vector.new(width, height), Vector.new(0,height)] # these are the start points
#    current_height = rand(height.to_f * 0.6) + (height.to_f * 0.2)
#    variance = height.to_f * 0.1
#    (width / 10).times do |point_width|
#      current_height += (rand(variance) * 2 - variance)
#      points << Vector.new(point_width * 10, current_height)
#    end
#    set_shape :Polygon, *points
#  end
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
   set_visual_shape :Polygon, *points
 end

 private

   def constrain(value, min, max)
     value = min if value < min
     value = max if value > max
     value
   end
end