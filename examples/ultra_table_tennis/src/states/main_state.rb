require 'managers/tag_manager'
require 'managers/score_manager'
require 'ball'

class MainState < Gemini::BaseState 
  def load
    set_manager :tag, create_game_object(:TagManager)
    set_manager :score, create_game_object(:ScoreManager)
    load_keymap :MainGameKeymap
    
    create_game_object :Wall, 0, -10, 640, 10
    create_game_object :Wall, 640, 0, 10, 480
    create_game_object :Wall, -10, 0, 10, 480
    create_game_object :Wall, 0, 480, 640, 10
    
    paddle = create_game_object :Paddle, 1
    paddle.move(100, 100)
    
    paddle = create_game_object :Paddle, 2
    paddle.move(500, 300)
  end
end