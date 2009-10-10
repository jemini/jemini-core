class Ball < Jemini::GameObject
  has_behavior :TangibleSprite
  
  def load
    set_image :ball
    set_shape :Circle, 15
    
    set_restitution 1.0
    set_mass 1.1
    set_friction 0
    set_speed_limit 30
    on_collided do |message|
      if message.other.respond_to?(:has_tag?) && message.other.has_tag?(:score_region)
        game_state.manager(:score).ball_scored self
      end
    end
  end
end