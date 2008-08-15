require 'managers/tag_manager'
require 'managers/score_manager'
require 'ball'

class MainState < Gemini::BaseState 
  def load
    set_manager(:tag, TagManager.new(self))
    set_manager(:score, ScoreManager.new(self))
    load_keymap :MainGameKeymap
    
    add_game_object Wall.new(0, -10, 640, 10)
    add_game_object Wall.new(640, 0, 10, 480)
    add_game_object Wall.new(-10, 0, 10, 480)
    add_game_object Wall.new(0, 480, 640, 10)
    
    paddle = Paddle.new(1)
    paddle.move(50, 200)
    add_game_object paddle
    
    paddle = Paddle.new(2)
    paddle.move(590, 200)
    add_game_object paddle
  end
end