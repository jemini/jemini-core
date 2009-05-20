class Ground < Gemini::GameObject
  POINT_SPACING = 50

  has_behavior :Taggable
  has_behavior :Physical
  has_behavior :DrawableShape

  attr_reader :points
  
  def load
    set_static_body
    set_mass :infinite
    set_restitution 0.5
    set_friction 1.0
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
 def fill_dimensions(left, top, right, bottom)
   width = right - left
   height = bottom - top
   current_height = rand(height.to_f * 0.6) + (height.to_f * 0.2) + top
   points = [Vector.new(right, bottom), Vector.new(left, bottom)] # these are the start points
   variance = height.to_f * 0.1
   y_direction = 0
   (0..(width / POINT_SPACING + 1)).each do |point_width|
     y_direction += (rand(variance) * 2 - variance)
     y_direction = constrain(y_direction, -50, 50)
     current_height += y_direction
     current_height = constrain(current_height, top, bottom - 20)
     y_direction = 0 if current_height <= top or current_height >= bottom - 20
#     puts("x1: #{x1}, y1: #{y1}, x2: #{x2}, y2: #{y2}, current_height: #{current_height}, y_direction: #{y_direction}")
     vector = Vector.new((point_width * POINT_SPACING) + left, current_height)
     points << vector
   end
   points << Vector.new(points.last.x, points.first.y)
   set_shape :Polygon, *points
   set_visual_shape :Polygon, *points
   @points = points
 end

 def spawn_along(times, offset)
   spawn_points = @points[2...-1]
   raise "spawn_along needs a block" unless block_given?
   times.times do |index|
     physical = yield index
     spawn_point_index = rand(spawn_points.size)
     point_along_ground = spawn_points.delete_at spawn_point_index
     point_along_ground.x -= physical.width if point_along_ground.x + physical.width > @game_state.screen_width
     point_along_ground.x += physical.width if point_along_ground.x - physical.width < 0
     physical.body_position = point_along_ground + offset
   end
 end

 private

   def constrain(value, min, max)
     value = min if value < min
     value = max if value > max
     value
   end
end