class Background < Gemini::GameObject
  has_behavior :BigSprite
  
  def load(file)
    set_image file
    set_position Vector.new(@game_state.screen_width, @game_state.screen_height).half
  end
end

