class Ground < Gemini::GameObject
  POINT_SPACING     = 25
  DIRT_DEATH_FACTOR =  0.50
  MINIMUM_BOTTOM    = 50
  VARIANCE_FACTOR   =  0.05
  MAX_STEEPNESS     = 18
  
  has_behavior :Taggable
  has_behavior :Physical
  has_behavior :DrawableShape

  attr_reader :points
  
  def load
    set_static_body
    set_mass :infinite
    set_restitution 1.0
    set_friction 10.0
    set_image @game_state.manager(:render).get_cached_image(:ground)
    add_tag :ground
#    on_physical_collided :deform_ground
  end

  def deform_ground(event)
    return unless event.other.has_tag? :damage
    result = nil
    @points.each_with_index do |point, index|
      next if index < 2
      next if index > (@points.size - 2)
      next_point = @points[index + 1]
      return if next_point.nil?
      if (point.x..next_point.x).include? event.other.x
        result = index
        break
      end
    end
    return if result.nil?

    loss = event.other.damage * DIRT_DEATH_FACTOR

    reduce_point_height(@points[result - 1], loss / 2.0) unless result - 1 < 3
    reduce_point_height(@points[result]    , loss)       unless result     > @points.size - 2
    reduce_point_height(@points[result + 1], loss)       unless result + 1 > @points.size - 2
    reduce_point_height(@points[result + 2], loss / 2.0) unless result + 2 > @points.size - 2

    set_ground_points
  end

  def reduce_point_height(point, height)
    point.y += height
    point.y = @minimum_height if point.y >= @minimum_height
  end
  
  def fill_dimensions(left, top, right, bottom)
    @minimum_height = bottom - MINIMUM_BOTTOM
    width = right - left
    height = bottom - top
    current_height = rand(height.to_f * 0.6) + (height.to_f * 0.2) + top
    points = [Vector.new(right, bottom), Vector.new(left, bottom)] # these are the start points
    variance = height.to_f * VARIANCE_FACTOR
    y_direction = 0
    (0..(width / POINT_SPACING + 1)).each do |point_width|
      y_direction += (rand(variance) * 2 - variance)
      y_direction = constrain(y_direction, -MAX_STEEPNESS, MAX_STEEPNESS)
      current_height += y_direction
      current_height = constrain(current_height, top, @minimum_height)
      y_direction = 0 if current_height <= top or current_height >= @minimum_height
#      puts("x1: #{x1}, y1: #{y1}, x2: #{x2}, y2: #{y2}, current_height: #{current_height}, y_direction: #{y_direction}")
      vector = Vector.new((point_width * POINT_SPACING) + left, current_height)
      points << vector
    end
    points << Vector.new(points.last.x, points.first.y)
    
    @points = points
    set_ground_points
  end

  def set_ground_points
    set_shape :Polygon, *@points
    set_visual_shape :Polygon, *@points
  end

  def spawn_along(times, offset)
    spawn_points = @points[2...-1].dup
    raise "spawn_along needs a block" unless block_given?
    times.times do |index|
      physical = yield index
      spawn_point_index = rand(spawn_points.size - 2) + 1 # offsets to prevent wall spawning
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
