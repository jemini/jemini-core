class MainState < Jemini::BaseState 
  def load
    set_manager :physics, create_game_object(:BasicPhysicsManager)
    set_manager :tag, create_game_object(:TagManager)
    set_manager :sound, create_game_object(:SoundManager)
    manager(:physics).gravity = 10
    
    load_keymap :MainGameKeymap
    
    
    microman = create_game_object :Microman
    microman.set_position(Vector.new(640 / 2, 450))

    set_manager :render, create_game_object(:ScrollingRenderManager, microman)
    
    manager(:render).cache_image :bullet, "bullet.png"
    manager(:render).cache_image :counter_bar, "counter-bar.png"
    
    #ground
    ground = create_game_object :StaticSprite, "platform.png", 640 / 2, 480 - 10, 610, 30
    ground.tiled_to_bounds = true
    
    # left and right walls
    left = create_game_object :StaticSprite, "platform.png", 0, 480 / 2, 30, 500
    left.tiled_to_bounds = true
    right = create_game_object :StaticSprite, "platform.png", 640, 480 / 2, 30, 500
    right.tiled_to_bounds = true
    
    #platforms!
    platform = create_game_object :StaticSprite, "platform.png", (640) / 4, (480 * 3)/ 4, 250, 30
    platform.tiled_to_bounds = true
    platform = create_game_object :StaticSprite, "platform.png", (640) / 2, (480 * 0.40), 250, 30
    platform.tiled_to_bounds = true
    
    ammo_display = create_game_object :IconStripCounterDisplay
    ammo_display.icon = :counter_bar
    ammo_display.rows = nil
    ammo_display.columns = 1
    ammo_display.count = 25
    ammo_display.layout_mode = IconStripCounterDisplay::BOTTOM_RIGHT_TO_TOP_LEFT_LAYOUT_MODE
    ammo_display.move 20, 140
    
    microman.on_emit_game_object do
      ammo_display.decrement
    end
    
    region = create_game_object :GameObject, :Regional
    region.dimensions = Vector.new(100, 100)
    region.move(475, 300)
    #region.move(175, 75)
    region.on_entered_region do |message|
      puts "#{message.spatial} entered region"
    end
    
    region.on_exited_region do |message|
      puts "#{message.spatial} exited region"
    end
    region.toggle_debug_mode
    # uncomment to enable profiler (needs keymap too)
#    quitter = create_game_object :GameObject
#    quitter.add_behavior :ReceivesEvents
#    quitter.handle_event :quit do
#      Profiler__::print_profile(STDERR) if $profiling
#      Java::java::lang::System.exit 0
#    end
  end
end