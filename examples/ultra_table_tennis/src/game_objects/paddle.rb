class Paddle < Gemini::GameObject
  has_behavior :UpdatesAtConsistantRate
  has_behavior :RecievesEvents
  has_behavior :Taggable
#  has_behavior :AnimatedSprite
  has_behavior :TangibleSprite
  
  def load(player_number)
#    sprites "paddle1.png", "paddle2.png", "paddle3.png", "paddle4.png", "paddle5.png"
#    animation_mode :ping_pong
#    animation_fps 4
    set_bounded_image "paddle1.png"
    #set_mass Tangible::INFINITE_MASS / 2
    set_mass 10000
    set_restitution 1
    #set_static_body
    handle_event :"p#{player_number}_paddle_movement", :move_paddle
    add_tag :paddle
    #set_safe_move true
    set_rotatable false
    set_damping 500.0
    set_speed_limit 0, 0.5
#    listen_for :collided, self do |message|
#      if message.other.kind_of? Ball
#        puts "colliding with ball"
#        puts "event info"
#        puts "++normal: #{message.event.normal}"
#        puts "++depth:  #{message.event.penetration_depth}"
#        puts "\n"
#        puts "paddle info"
#        puts "--force:    #{force}"
#        puts "--velocity: #{velocity}"
#        puts "--"
#        #add_force(-force.x, -force.y) 
#        #add_velocity(velocity.x, velocity.y)
#      end
#    end
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