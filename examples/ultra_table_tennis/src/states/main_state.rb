require 'tag_manager'
require 'score_manager'
require 'basic_physics_manager'
require 'ball'

class MainState < Gemini::BaseState 
  def load
    manager(:game_object).add_layer_at(:ball_effects_layer, 1)
    manager(:game_object).add_layer_at(:ball_layer, 2)
    
    set_manager :physics, create_game_object(:BasicPhysicsManager)
    set_manager :tag, create_game_object(:TagManager)
    set_manager :score, create_game_object(:ScoreManager)
    
    load_keymap :MainGameKeymap
    
    create_game_object :Wall, 640 / 2, -10, 650, 30, :top
    create_game_object :Wall, 640 - 10,  480 / 2, 20, 480, :right, :score_region
    create_game_object :Wall, 0, 480 / 2, 10, 480, :left, :score_region
    create_game_object :Wall, 640 / 2, 480 - 10, 650, 30, :bottom
    
    paddle = create_game_object :Paddle, 1
    paddle.set_body_position Vector.new(100, 100)
    
    paddle = create_game_object :Paddle, 2
    paddle.set_body_position Vector.new(500, 300)
    
    quitter = create_game_object :GameObject
    quitter.add_behavior :ReceivesEvents
    quitter.handle_event :quit do
      Profiler__::print_profile(STDERR) if $profiling
      Java::java::lang::System.exit 0
    end
  end
end