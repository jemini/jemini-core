class MainState < Gemini::BaseState
  def load
    @sprites = []
    3.times do
      ball = Ball.new [rand(11)-5, rand(11)-5]
      ball.move(rand(640 -ball.width), rand(480 - ball.height))
      @sprites << ball
    end
    @walls = []
    @walls << Wall.new(0, -10, 640, 10)
    @walls << Wall.new(640, 0, 10, 480)
    @walls << Wall.new(-10, 0, 10, 480)
    @walls << Wall.new(0, 480, 640, 10)
    
    paddle = Paddle.new(1)
    paddle.move(100, 100)
    @sprites << paddle
    
    paddle = Paddle.new(2)
    paddle.move(500, 300)
    @sprites << paddle
  end
  
  def update(delta)
    @sprites.each { |sprite| sprite.update(delta) }
  end
  
  def render(graphics)
    @sprites.each { |sprite| sprite.draw }
  end
end