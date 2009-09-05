class Flag < Jemini::GameObject
  has_behavior :Sprite
  
  def load(tank)
    @tank = tank
    set_image @game_state.manager(:render).get_cached_image(:flag_background)
    @logo = @game_state.create_on_layer :GameObject, :logo, :Sprite
    @logo.set_image @game_state.manager(:render).get_cached_image(:gangplank_logo)

    snap_to_tank
    @tank.on_after_body_position_changes { snap_to_tank }
    @tank.on_update { snap_to_tank }
  end

  def snap_to_tank
    self.position  = Vector.new(@tank.body_position.x, 40.0)
    @logo.position = Vector.new(@tank.body_position.x, 40.0)
  end

  def unload
    @game_state.remove @logo
  end
end