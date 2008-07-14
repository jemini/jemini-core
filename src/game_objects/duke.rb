class Duke < Gemini::GameObject
  has_behavior :Movable2D
  has_behavior :Sprite
  has_behavior :UpdatesAtConsistantRate
  
  def load
    self.image = "duke.png"
    self.updates_per_second = 30
    @direction = :right
    self.x = rand(640 - image.width)
    self.y = rand(480 - image.height)
  end
  
  def tick
    if x > (640 - image.width) || x < 0
      @direction = @direction == :right ? :left : :right
    end
    self.x = x + (@direction == :right ? 1 : -1)
  end
end