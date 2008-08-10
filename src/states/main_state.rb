require 'managers/tag_manager'

class MainState < Gemini::BaseState 
  def load
    set_manager(:tag, TagManager.new(self))
    
    3.times do
      ball = Ball.new [rand(11)-5, rand(11)-5]
      ball.move(rand(640 -ball.width), rand(480 - ball.height))
      add_game_object ball
    end
    @walls = []
    @walls << Wall.new(0, -10, 640, 10)
    @walls << Wall.new(640, 0, 10, 480)
    @walls << Wall.new(-10, 0, 10, 480)
    @walls << Wall.new(0, 480, 640, 10)
    
    paddle = Paddle.new(1)
    paddle.move(100, 100)
    add_game_object paddle
    
    paddle = Paddle.new(2)
    paddle.move(500, 300)
    add_game_object paddle
  end
end