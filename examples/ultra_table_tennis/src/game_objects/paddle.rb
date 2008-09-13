class Paddle < Gemini::GameObject
  has_behavior :UpdatesAtConsistantRate
  has_behavior :RecievesEvents
  has_behavior :Taggable
  has_behavior :TangibleSprite
  has_behavior :AnimatedSprite
  
  def load(player_number)
    sprites "paddle1.png", "paddle2.png", "paddle3.png", "paddle4.png", "paddle5.png"
    animation_mode :ping_pong
    animation_fps 4
    set_bounded_image "paddle1.png"
    set_rotatable false
    set_mass 10000
    set_restitution 1
    handle_event :"p#{player_number}_paddle_movement", :move_paddle
    add_tag :paddle
    set_damping 500.0
    set_speed_limit 0, 0.5
  end
  
  def move_paddle(message)
    case message.value
    when :up
      add_force(0, -75.0)
    when :down
      add_force(0, 75.0)
    end
  end
end