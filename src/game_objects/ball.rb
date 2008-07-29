class Ball < Gemini::GameObject
  attr_accessor :vector
  
  has_behavior :UpdatesAtConsistantRate
  has_behavior :BoundingBoxCollidable
  has_behavior :Sprite
  
  def load
    collides_with_tags :wall
    preferred_collision_check BoundingBoxCollidable::TAGS
    self.image = "ball.png"
    self.updates_per_second = 30
    self.x = rand(640 - width)
    self.y = rand(480 - height)
    @vector = [0,0]
    
    on_collided do |event, continue|
      vector[0] = -1 if x > (640 - width)
      vector[0] = 1 if x < 0
      vector[1] = -1 if y > (480 - height)
      vector[1] = 1 if y < 0
   end
  end
  
  def tick
    move(x + @vector[0], y + @vector[1])
  end
end

class Wall < Gemini::GameObject
  has_behavior :BoundingBoxCollidable
  
  def load(x, y, width, height)
    self.x = x
    self.y = y
    self.width = width
    self.height = height
    self.add_tag :wall
  end
end