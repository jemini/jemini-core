class Ball < Gemini::GameObject
  has_behavior :UpdatesAtConsistantRate
  has_behavior :CollidableWhenMoving
  has_behavior :CollisionPoolAlgorithmTaggable
  has_behavior :Sprite
  has_behavior :Inertial
  has_behavior :TriangleTrailEmittable
  
  def load
    collides_with_tags :wall, :paddle
    self.image = "ball.png"
    self.x = rand(640 - width)
    self.y = rand(480 - height)
    
    on_collided do |event, continue|
      if event.collided_object.has_tag? :wall
        inertia[1] *= -1 if y > (480 - height) || y < 0
        if x > (640-width) || x < 0
          @game_state.manager(:score).ball_scored self
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