require 'managers/tag_manager'
require 'managers/score_manager'
require 'ball'

class MainState < Gemini::BaseState 
  def load
    manager(:game_object).add_layer_at(:ball_effects_layer, 1)
    manager(:game_object).add_layer_at(:ball_layer, 2)
    
    set_manager :physics, create_game_object(:BasicPhysicsManager)
    set_manager :tag, create_game_object(:TagManager)
    set_manager :score, create_game_object(:ScoreManager)
    
    load_keymap :MainGameKeymap
    
    #create_game_object :Wall, 0, 0, 630, 10, :top
    #create_game_object :Wall, 20, 10, 30, 40, :right, :score_region
    create_game_object :Wall, 100, 200, 50, 100, :left, :score_region
    #create_game_object :Wall, 0, 470, 630, 10, :bottom
    
    paddle = create_game_object :Paddle, 1
    paddle.move(100, 100)
    
    paddle = create_game_object :Paddle, 2
    paddle.move(500, 300)
    
    quitter = create_game_object :GameObject
    quitter.add_behavior :RecievesEvents
    quitter.handle_event :quit do
      Profiler__::print_profile(STDERR) if $profiling
      Java::java::lang::System.exit 0
    end
  end
end