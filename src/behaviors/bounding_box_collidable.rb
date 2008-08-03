require 'behavior_event'
include_class 'org.newdawn.slick.geom.Rectangle'

class BoundingBoxCollidable < Gemini::Behavior
  DISTANCE = :distance
  TAGS = :tags
  depends_on :Tags
  
  declared_methods :preferred_collision_check, :collides_with_tags, :collision_check
  
  @@collidables = []
  
  def load
    @@collidables << self
    @algorithm = DISTANCE
    
    @target.add_listener_for :collided
  end
  
  def unload
    @@collidables.delete self
  end
  
  def collides_with_tags(*tags)
    @tags = tags
  end
  
  def preferred_collision_check(type)
    raise "Invalid collision type" unless DISTANCE == type || TAGS == type
    @algorithm = type
  end
  
  def tags_to_use_for_collision(*tags)
    @collision_tags = tags
  end

  def collision_check(collidable)
    return if self == collidable || @target == collidable.target

    notify :collided, BoundingBoxCollisionEvent.new(@target, collidable.target) if bounds.intersects(collidable.bounds)
  end
end

class BoundingBoxCollisionEvent < Gemini::BehaviorEvent
  attr_accessor :colliding_object, :collided_object
  
  def load(source, other)
    @colliding_object = source
    @collided_object = other
  end
end