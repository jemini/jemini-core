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
    set_mass 100
    set_restitution 1.0
    set_rotatable false
    handle_event :"p#{player_number}_paddle_movement", :move_paddle
    add_tag :paddle
    
    # restrict horizontal movement
    on_collided do |event|
      puts "collision occured in paddle!"
      puts "normal: #{event.normal}"
      puts "penetration: #{event.penetration_depth}"
      puts "velocity: #{velocity}"
      puts "force: #{force}"
      #add_force(-event.normal.x * event.penetration_depth * 2, 0)
      add_velocity(event.normal.x * event.penetration_depth, 0)
      #come_to_rest
    end
  end
  
  def move_paddle(message)
    case message.value
    when :up
      add_velocity(0.0, -0.3)
    when :down
      add_velocity(0.0, 0.3)
    when :stop
      come_to_rest
    end
  end
end