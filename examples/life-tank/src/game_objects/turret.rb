class Turret < Gemini::GameObject
  has_behavior :Sprite

  def load
    set_image @game_state.manager(:render).get_cached_image(:tank_barrel)
  end
end