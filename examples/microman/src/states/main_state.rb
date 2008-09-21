require 'managers/tag_manager'
require 'basic_physics_manager'

class MainState < Gemini::BaseState 
  def load
    
    #manager(:game_object).add_layer_at(:ball_effects_layer, 1)
    #manager(:game_object).add_layer_at(:ball_layer, 2)
    
    set_manager :physics, create_game_object(:BasicPhysicsManager)
    set_manager :tag, create_game_object(:TagManager)
    
    manager(:physics).gravity = 10
    
    load_keymap :MainGameKeymap
    
    #ground
    create_game_object :StaticSprite, "platform.png", 640 / 2, 480 - 10, 610, 30
    
    # left and right walls
    create_game_object :StaticSprite, "platform.png", 0, 480 / 2, 30, 500
    create_game_object :StaticSprite, "platform.png", 640, 480 / 2, 30, 500
    
    #platforms!
    create_game_object :StaticSprite, "platform.png", (640) / 4, (480 * 3)/ 4, 250, 30
    create_game_object :StaticSprite, "platform.png", (640) / 2, (480 / 2), 250, 30
    
    microman = create_game_object :Microman
    microman.set_position(640 / 2, 450)
    
#    paddle = create_game_object :Paddle, 1
#    paddle.set_position(100, 100)
#    
#    paddle = create_game_object :Paddle, 2
#    paddle.set_position(500, 300)
#    
#    quitter = create_game_object :GameObject
#    quitter.add_behavior :RecievesEvents
#    quitter.handle_event :quit do
#      Profiler__::print_profile(STDERR) if $profiling
#      Java::java::lang::System.exit 0
#    end
  end
end