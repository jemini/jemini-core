require 'events/grid_changed_event'

class GridBound < Gemini::Behavior
  DEFAULT_GRID_WIDTH  = 32
  DEFAULT_GRID_HEIGHT = 32
  DEFAULT_GRID_SIZE = Vector.new(DEFAULT_GRID_WIDTH, DEFAULT_GRID_HEIGHT)
  depends_on :Spatial
  depends_on :Movable

  listen_for :grid_changed
  
  attr_accessor :grid_size, :grid_position

  def load
    @grid_size = DEFAULT_GRID_SIZE
    @target.on_movement { notify_grid_changed }
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
  def grid_position=(position)
    top_left_of_grid = Vector.new(position.x.to_i * @grid_size.x.to_i, position.y.to_i * @grid_size.y.to_i)
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

private
  def notify_grid_changed
    old_position = @grid_position
    new_position = detect_grid_position

    unless old_position == new_position
      @grid_position = new_position
      @target.notify(:grid_changed, GridChangedEvent.new(new_position, old_position))
    end
  end

  def detect_grid_position
    x = @target.x.to_i / grid_size.x.to_i
    y = @target.y.to_i / grid_size.y.to_i
    Vector.new(x, y)
  end
end