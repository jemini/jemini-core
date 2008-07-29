class MainState < Gemini::BaseState
  def load
    @sprites = []
    250.times do
      ball = Ball.new
      ball.x = rand(640 -ball.width)
      ball.y = rand(480 - ball.height)
      ball.vector = [rand(10)-5, rand(10)-5]
      @sprites << ball
    end
    @walls = []
    @walls << Wall.new(0, -10, 640, 10)
    @walls << Wall.new(640, 0, 10, 480)
    @walls << Wall.new(-10, 0, 10, 480)
    @walls << Wall.new(0, 480, 640, 10)
  end
  
  def update(delta)
    @sprites.each { |sprite| sprite.update(delta) }
  end
  
  def render(graphics)
    @sprites.each { |sprite| sprite.draw }
  end
end