class GridBound < Gemini::Behavior
  DEFAULT_GRID_WIDTH  = 32.0
  DEFAULT_GRID_HEIGHT = 32.0
  DEFAULT_GRID_SIZE = Vector.new(DEFAULT_GRID_WIDTH, DEFAULT_GRID_HEIGHT)
  depends_on :Spatial
  
  attr_accessor :grid_size, :grid_position

  def load
    @grid_size = DEFAULT_GRID_SIZE
  end
  # position is a vector
  # setting grid position calculates at the center of the grid
  def grid_position=(position)
    top_left_of_grid = Vector.new(position.x * @grid_size.x, position.y * @grid_size.y)
    center_offset = @grid_size.half
    @target.position = top_left_of_grid + center_offset
    @grid_position = position
  end

  def adjacent_grid(direction)
    adjacent_grid = @grid_position.dup
    case direction
    when :left, :west
      adjacent_grid.x -= 1
    when :right, :east
      adjacent_grid.x += 1
    when :top, :north, :up
      adjacent_grid.y += 1
    when :bottom, :south, :down
      adjacent_grid.y -= 1
    end
    adjacent_grid
  end
end