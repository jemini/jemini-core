require 'managers/tag_manager'
require 'managers/sound_manager'
require 'basic_physics_manager'

class MainState < Gemini::BaseState 
  def load
    set_manager :physics, create_game_object(:BasicPhysicsManager)
    set_manager :tag, create_game_object(:TagManager)
    set_manager :sound, create_game_object(:SoundManager)
    manager(:physics).gravity = 10
    
    load_keymap :MainGameKeymap
    
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
    platform = create_game_object :StaticSprite, "platform.png", (640) / 2, (480 / 2), 250, 30
    platform.tiled_to_bounds = true
    
    microman = create_game_object :Microman
    microman.set_position(640 / 2, 450)

    set_manager :render, create_game_object(:ScrollingRenderManager, microman)
    manager(:render).cache_image :bullet, "bullet.png"
    # uncomment to enable profiler (needs keymap too)
#    quitter = create_game_object :GameObject
#    quitter.add_behavior :RecievesEvents
#    quitter.handle_event :quit do
#      Profiler__::print_profile(STDERR) if $profiling
#      Java::java::lang::System.exit 0
#    end
  end
end