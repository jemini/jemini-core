class Paddle < Gemini::GameObject
  has_behavior :UpdatesAtConsistantRate
  has_behavior :RecievesEvents
  has_behavior :Movable2D
  has_behavior :Sprite
  
  def load
    self.image = "duke.png"
    handle_event :paddle_movement, :move_paddle
    @movement = []
  end
  
  def move_paddle(type, message)
    if :start == message[0]
      @movement << message[1]
    else
      @movement.delete message[1]
    end
  end
  
  def tick
    @movement.each do |direction|
      case direction
      when :up
        self.y -= 1
      when :down
        self.y += 1
      when :right
        self.x += 1
      when :left
        self.x -= 1
      end
    end
  end
end

class Ball < Gemini::GameObject
  has_behavior :UpdatesAtConsistantRate
  has_behavior :BoundingBoxCollidable
  has_behavior :Sprite
  
  def load(vector)
    collides_with_tags :wall
    preferred_collision_check BoundingBoxCollidable::TAGS
    self.image = "ball.png"
    self.updates_per_second = 30
    self.x = rand(640 - width)
    self.y = rand(480 - height)
    @vector = vector
    
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