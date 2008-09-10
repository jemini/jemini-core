class Ball < Gemini::GameObject
  has_behavior :UpdatesAtConsistantRate
  has_behavior :TangibleSprite
  
  def load
    set_image "ball.png"
    set_shape :Circle, 15
    
    set_restitution 1.0
    set_mass 1
    #set_mass 1000
    listen_for(:collided) do |message|
      if message.other.respond_to?(:has_tag?) && message.other.has_tag?(:score_region)
        @game_state.manager(:score).ball_scored self
      end
    end
  end
end