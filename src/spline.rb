class Spline
  def initialize(*x_y_arrays)
    @points = x_y_arrays
    @current_point_index = 0
  end
  
  def succ
    y = @points[@current_point_index][1]
    @current_point_index += 1
    @current_point_index = 0 if @current_point_index >= @points.size
    y
  end
end