class Ball < Gemini::GameObject
  has_behavior :UpdatesAtConsistantRate
  has_behavior :TangibleSprite
  has_behavior :Taggable
  
  def load
    set_image "ball.png"
    set_shape :Circle, 15
    set_restitution 1.0
    
    on_collided do |event|
      if event.body_a.user_data.has_tag?(:score_region) || event.body_b.user_data.has_tag?(:score_region)
        @game_state.manager(:score).ball_scored self
      end
    end
  end
end