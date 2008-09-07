class Paddle < Gemini::GameObject
  has_behavior :UpdatesAtConsistantRate
  has_behavior :RecievesEvents
#  has_behavior :CollidableWhenMoving
  has_behavior :Taggable
#  has_behavior :Inertial
#  has_behavior :AnimatedSprite
  has_behavior :TangibleSprite
#  has_behavior :CollisionPoolAlgorithmTaggable
  
  def load(player_number)
#    sprites "paddle1.png", "paddle2.png", "paddle3.png", "paddle4.png", "paddle5.png"
#    animation_mode :ping_pong
#    animation_fps 4
    set_bounded_image "paddle1.png"
    set_mass 1000
    
    handle_event :"p#{player_number}_paddle_movement", :move_paddle
    add_tag :paddle
#    collides_with_tags :wall
    
#    on_collided do |event, continue|
#      if event.collided_object.has_tag? :wall
#        wall = event.collided_object
#        snap_to_bottom_of wall if higher_than_bottom_of?(wall) && wall.has_tag?(:top)
#        snap_to_top_of wall if lower_than_top_of?(wall ) && wall.has_tag?(:bottom)
#      end
#    end
  end
  
  def move_paddle(message)
    case message.value
    when :up
#      inertia[1] = -5
      set_force(0.0, -50.0)
    when :down
#      inertia[1] = 5
      set_force(0.0, 50.0)
    when :stop
#      inertia[1] = 0
      come_to_rest
    end
  end
  
#  def higher_than_bottom_of?(object)
#    (object.y + object.height) > self.y
#  end
#  
#  def lower_than_top_of?(object)
#    object.y < (self.y + self.height)
#  end
#  
#  def snap_to_bottom_of(object)
#    self.y = object.y + object.height
#  end
#  
#  def snap_to_top_of(object)
#    self.y = object.y - self.height
#  end
end