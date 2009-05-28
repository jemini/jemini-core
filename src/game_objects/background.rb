class Background < Gemini::GameObject
  has_behavior :BigSprite
  
  def load(file)
    set_image file
    move @game_state.screen_width / 2, @game_state.screen_height / 2
  end
end

