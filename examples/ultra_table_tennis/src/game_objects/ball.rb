class Ball < Gemini::GameObject
  has_behavior :UpdatesAtConsistantRate
#  has_behavior :CollidableWhenMoving
#  has_behavior :CollisionPoolAlgorithmTaggable
  has_behavior :TangibleSprite
#  has_behavior :Inertial
  
  def load
    set_image "ball.png"
    set_shape :Circle, 15
    set_restitution 1.0
#    collides_with_tags :wall, :paddle
#    move(rand(640 - width), rand(480 - height))
    
#    on_collided do |event, continue|
#      if event.collided_object.has_tag? :wall
#        inertia[1] *= -1 if y > (480 - height) || y < 0
#        if event.collided_object.has_tag? :score_region
#          @game_state.manager(:score).ball_scored self
#        end
#      else
#        if x < 320
#          inertia[0] = inertia[0].abs
#        else
#          inertia[0] = -(inertia[0].abs)
#        end
#      end
#    end
  end
end