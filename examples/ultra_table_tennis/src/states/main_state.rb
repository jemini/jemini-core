require 'managers/tag_manager'
require 'ball'

class MainState < Gemini::BaseState 
  def load
    set_manager(:tag, create_game_object(:TagManager))
    load_keymap :MainGameKeymap
    
    3.times do
      ball = create_game_object :Ball, [rand(11)-5, rand(11)-5]
      ball.move(rand(640 -ball.width), rand(480 - ball.height))
    end
    
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