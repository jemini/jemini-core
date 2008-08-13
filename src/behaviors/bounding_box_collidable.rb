require 'behavior_event'
include_class 'org.newdawn.slick.geom.Rectangle'

class BoundingBoxCollidable < Gemini::Behavior
  depends_on :Spatial2D
  
  declared_methods :collision_check
  
  def load
    @target.enable_listeners_for :collided
  end
  
  def collision_check(collidable)
    return if self == collidable || @target == collidable

    notify :collided, BoundingBoxCollisionEvent.new(@target, collidable) if bounds.intersects(collidable.bounds)
  end
end

class BoundingBoxCollisionEvent < Gemini::BehaviorEvent
  attr_accessor :colliding_object, :collided_object
  
  def load(source, other)
    @colliding_object = source
    @collided_object = other
  end
end