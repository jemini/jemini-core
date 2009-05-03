class PlayState < Gemini::BaseState
  def load
    set_manager :physics, create_game_object(:BasicPhysicsManager)
    set_manager :tag, create_game_object(:TagManager)
    set_manager :sound, create_game_object(:SoundManager)
    set_manager :tangible, create_game_object(:BasicTangibleManager)
    
    manager(:game_object).add_layer_at :gui_text, 5
    manager(:physics).gravity = 5
    manager(:render).cache_image :tank_body, "tank-body.png"
    manager(:render).cache_image :ground, "ground.png"
    manager(:render).cache_image :tank_barrel, "tank-barrel.png"
    
    load_keymap :PlayKeymap

    ground = create_game_object :Ground
    ground.fill_dimensions(0, screen_height / 2, screen_width, screen_height)
    @tanks = []
    ground.spawn_along 4, Vector.new(0.0, -10.0) do
      tank = create_game_object :Tank
      @tanks << tank
      tank
    end
    left_wall = create_game_object :GameObject, :Physical
    left_wall.set_shape :Box, 40, screen_height
    left_wall.set_static_body
    left_wall.body_position = Vector.new(-20, screen_height / 2)
    
    right_wall = create_game_object :GameObject, :Physical
    right_wall.set_shape :Box, 40, screen_height
    right_wall.set_static_body
    right_wall.body_position = Vector.new(screen_width + 20, screen_height / 2)

    floor = create_game_object :GameObject, :Physical
    floor.set_shape :Box, screen_width, 40
    floor.set_static_body
    floor.body_position = Vector.new(screen_width / 2, screen_height + 20)
#    spawner = create_game_object :GameObject, :RecievesEvents
#    spawner.handle_event :spawn_thing do
#      tank = create_game_object :Tank
##      thing.set_shape :Box, 50, 30
#      #tank.body_position = Vector.new(rand(screen_width), 0)
#      tank.body_position = Vector.new(screen_width / 2, screen_height / 2)
#    end
  end
end