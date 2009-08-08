class GridChangedEvent
  attr_accessor :old_grid_position, :new_grid_position

  def initialize(new_grid_position, old_grid_position)
    @new_grid_position = new_grid_position
    @old_grid_position = old_grid_position
  end
end