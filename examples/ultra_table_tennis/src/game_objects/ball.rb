class Paddle < Gemini::GameObject
  has_behavior :UpdatesAtConsistantRate
  has_behavior :RecievesEvents
  has_behavior :CollidableWhenMoving
  has_behavior :AnimatedSprite
  
  def load(player_number)
    sprites "paddle1.png", "paddle2.png", "paddle3.png", "paddle4.png", "paddle5.png"
    animation_mode :ping_pong
    animation_fps 5
    handle_event :"p#{player_number}_paddle_movement", :move_paddle
    handle_event :button_action, :handle_button_actions
    handle_event :mouse_action, :handle_mouse_actions
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
    end
  end
  
  def handle_button_actions(message)
    case message.value
    when :fire
      puts "bang"
    end
  end
  
  def handle_mouse_actions(message)
    puts "mouse moved to: #{message.value[0]}, #{message.value[1]}"
  end
  
  def move_paddle(message)
    if :start == message.value[0]
      @movement << message.value[1]
    else
      @movement.delete message.value[1]
    end
  end
end

class Ball < Gemini::GameObject
  has_behavior :UpdatesAtConsistantRate
  has_behavior :CollidableWhenMoving
  has_behavior :Sprite
  has_behavior :Inertial
  
  def load(vector)
    collides_with_tags :wall, :paddle
    preferred_collision_check CollidableWhenMoving::TAGS
    self.image = "ball.png"
    self.updates_per_second = 30
    self.x = rand(640 - width)
    self.y = rand(480 - height)
    self.inertia = vector
    
    on_collided do |event, continue|
      if event.collided_object.has_tag? :wall
        inertia[0] *= -1 if x > (640 - width) || x < 0
        inertia[1] *= -1 if y > (480 - height) || y < 0
      else
        puts "hit paddle"
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