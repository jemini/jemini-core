class Background < Jemini::GameObject
  has_behavior :Sprite
  
  #Takes a reference to an image loaded via ResourceManager.
  def load(image)
    set_image image
    set_position Vector.new(game_state.screen_width, game_state.screen_height).half
  end
end

