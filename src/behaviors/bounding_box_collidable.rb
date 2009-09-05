require 'behavior_event'
include_class 'org.newdawn.slick.geom.Rectangle'

#Makes an object generate a BoundingBoxCollisionEvent if its bounding box intersects another's.
class BoundingBoxCollidable < Jemini::Behavior
  depends_on :Spatial2d
  
  def load
    @target.enable_listeners_for :collided
  end
  
  def collision_check(collidable)
    return if self == collidable || @target == collidable

    notify :collided, BoundingBoxCollisionEvent.new(@target, collidable) if bounds.intersects(collidable.bounds)
  end
end

#Indicates that one object has collided with another.
class BoundingBoxCollisionEvent < Jemini::BehaviorEvent
  attr_accessor :colliding_object, :collided_object
  
  def load(source, other)
    @colliding_object = source
    @collided_object = other
  end
end