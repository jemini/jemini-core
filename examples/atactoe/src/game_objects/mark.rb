class Mark < Gemini::GameObject
  has_behavior :Sprite

  def load(mark)
    set_image game_state.manager(:render).get_cached_image(mark)
  end

end
