module HardwareCursor
  def use_available_hardware_cursor
    cursor_resource = game_state.manager(:resource).get_image(:mouse_cursor) rescue nil
    game_state.container.set_mouse_cursor(cursor_resource, 0, 0) if cursor_resource
  end

  def revert_hardware_cursor
    game_state.container.set_default_mouse_cursor
  end
end