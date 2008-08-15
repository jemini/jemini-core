class Paddle < Gemini::GameObject
  has_behavior :UpdatesAtConsistantRate
  has_behavior :RecievesEvents
  has_behavior :CollidableWhenMoving
  has_behavior :AnimatedSprite
  
  def load(player_number)
    sprites "paddle1.png", "paddle2.png", "paddle3.png", "paddle4.png", "paddle5.png"
    animation_mode :ping_pong
    animation_fps 4
    handle_event :"p#{player_number}_paddle_movement", :move_paddle
    add_tag :paddle
    
    @movement = []
    on_tick do
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
      @movement.clear
    end
  end
  
  def move_paddle(message)
    @movement << message.value
  end
end

class Ball < Gemini::GameObject
  has_behavior :UpdatesAtConsistantRate
  has_behavior :CollidableWhenMoving
  has_behavior :Sprite
  has_behavior :Inertial
  
  def load
    collides_with_tags :wall, :paddle
    preferred_collision_check CollidableWhenMoving::TAGS
    self.image = "ball.png"
    self.x = rand(640 - width)
    self.y = rand(480 - height)
    
    on_collided do |event, continue|
      if event.collided_object.has_tag? :wall
        inertia[1] *= -1 if y > (480 - height) || y < 0
        if x > (640-width) || x < 0
          @state.manager(:score).ball_scored self
        end
      else
        if x < 320
          inertia[0] = inertia[0].abs
        else
          inertia[0] = -(inertia[0].abs)
        end
      end
    end
  end
end

class Wall < Gemini::GameObject
  has_behavior :BoundingBoxCollidable
  has_behavior :Taggable
  
  def load(x, y, width, height)
    self.x = x
    self.y = y
    self.width = width
    self.height = height
    add_tag :wall
  end
end