class MenuState < Gemini::BaseState
  def load
    set_manager :physics, create_game_object(:BasicPhysicsManager)
    set_manager :tag, create_game_object(:TagManager)
    
    manager(:render).cache_image :ground, "ground.png"

    ground = create_game_object :Ground
    ground.fill_dimensions(0, screen_height / 2, screen_width, screen_height)
    
    create_game_object :Text, screen_width / 2, screen_height / 2, "Life-Tank"
  end
end