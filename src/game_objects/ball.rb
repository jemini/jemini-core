class Paddle < Gemini::GameObject
  has_behavior :UpdatesAtConsistantRate
  has_behavior :RecievesEvents
  has_behavior :BoundingBoxCollidable
  has_behavior :Sprite
  
  def load(player_number)
    self.image = "duke.png"
    handle_event :"p#{player_number}_paddle_movement", :move_paddle
    @movement = []
    add_tag :paddle
  end
  
  def move_paddle(message)
    if :start == message.value[0]
      @movement << message.value[1]
    else
      @movement.delete message.value[1]
    end
  end
  
  def tick
    @movement.each do |direction|
      case direction
      when :up
        self.y -= 0.5
        self.y = 0 if y < 0
      when :down
        self.y += 0.5
        self.y = 480-height if y > 480-height
      end
    end
  end
end

class Ball < Gemini::GameObject
  has_behavior :UpdatesAtConsistantRate
  has_behavior :BoundingBoxCollidable
  has_behavior :Sprite
  
  def load(vector)
    collides_with_tags :wall, :paddle
    preferred_collision_check BoundingBoxCollidable::TAGS
    self.image = "ball.png"
    self.updates_per_second = 30
    self.x = rand(640 - width)
    self.y = rand(480 - height)
    @vector = vector
    
    on_collided do |event, continue|
      if event.collided_object.has_tag? :wall
        vector[0] *= -1 if x > (640 - width)
        vector[0] *= -1 if x < 0
        vector[1] *= -1 if y > (480 - height)
        vector[1] *= -1 if y < 0
      else
        puts "hit paddle"
      end
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
    add_tag :wall
  end
end