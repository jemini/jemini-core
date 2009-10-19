require 'events/grid_changed_event'

class GridBound < Jemini::Behavior
  DEFAULT_GRID_WIDTH  = 32
  DEFAULT_GRID_HEIGHT = 32
  DEFAULT_GRID_SIZE = Vector.new(DEFAULT_GRID_WIDTH, DEFAULT_GRID_HEIGHT)
  depends_on :Spatial
  depends_on :Movable

  listen_for :grid_changed
  
  attr_accessor :grid_size, :grid_position

  def load
    @grid_size = DEFAULT_GRID_SIZE
    @game_object.on_movement { notify_grid_changed }
    @grid_position = detect_grid_position
  end

  def grid_size=(vector)
    @grid_size = Vector.new(vector.x.to_i, vector.y.to_i)
  end
  
  def grid_position
    detect_grid_position
  end
  # position is a vector
  # setting grid position calculates at the center of the grid
  def grid_position=(grid_position)
    @game_object.position = position_at(grid_position)
    @grid_position = grid_position
  end

  def adjacent_grid(direction)
    adjacent_grid = @grid_position.dup
    case direction
    when :top, :north, :up
      adjacent_grid.y += 1
    when :north_east
      adjacent_grid.x += 1
      adjacent_grid.y += 1
    when :right, :east
      adjacent_grid.x += 1
    when :south_east
      adjacent_grid.x += 1
      adjacent_grid.y -= 1
    when :bottom, :south, :down
      adjacent_grid.y -= 1
    when :south_west
      adjacent_grid.x -= 1
      adjacent_grid.y -= 1
    when :left, :west
      adjacent_grid.x -= 1
    when :north_west
      adjacent_grid.x -= 1
      adjacent_grid.y += 1
    end
    adjacent_grid
  end

  def move_to_adjacent_grid(direction)
    move_to_grid(adjacent_grid(direction))
  end

  def move_to_grid(grid)
    @game_object.move_to position_at(grid)
  end

  def snap_to_grid
    grids = adjacent_grids
    grids << grid_position
    nearest_grid = grids.min_by { |g| position_at(g).distance_from(@game_object.position) }
    self.grid_position = nearest_grid
  end

  def adjacent_grids
    [:north, :north_east, :east, :south_east, :south, :south_west, :west, :north_west].map do |direction|
      adjacent_grid direction
    end
  end

private
  def position_at(grid_position)
    top_left_of_grid = Vector.new(grid_position.x.to_i * grid_size.x.to_i, grid_position.y.to_i * grid_size.y.to_i)
    center_offset = grid_size.half
    top_left_of_grid + center_offset
  end
  
  def grid_at(position)
    x = position.x.to_i / grid_size.x.to_i
    y = position.y.to_i / grid_size.y.to_i
    Vector.new(x, y)
  end

  def notify_grid_changed
    old_position = @grid_position
    new_position = detect_grid_position

    unless old_position == new_position
      @grid_position = new_position
      @game_object.notify(:grid_changed, GridChangedEvent.new(new_position, old_position))
    end
  end

  def detect_grid_position
    grid_at @game_object.position
  end
end