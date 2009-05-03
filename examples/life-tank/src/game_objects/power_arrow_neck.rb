class PowerArrowNeck < Gemini::GameObject
  has_behavior :Sprite

  def load
    set_image @game_state.manager(:render).get_cached_image(:power_arrow_neck)
  end
end