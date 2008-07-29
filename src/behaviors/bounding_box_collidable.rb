require 'behavior_event'

class BoundingBoxCollidable < Gemini::Behavior
  DISTANCE = :distance
  TAGS = :tags
  depends_on :Tags
  depends_on :Movable2D
  
  declared_methods :preferred_collision_check, :collides_with_tags
  
  @@collidables = []
  
  def load
    @@collidables << self
    @algorithm = DISTANCE
    
    @target.add_listener_for :collided
    @target.on_after_move do
      if TAGS == @algorithm
        Tags.find_by_all_tags(*@tags).each {|collidable| collision_check collidable }
      elsif DISTANCE == @algorithm
        @@collidables.each {|collidable| collision_check collidable }
      end
    end
  end
  
  def unload
    @@collidables.delete self
  end
  
  def collision_check(collidable)
    return if self == collidable
    if (((x <= collidable.x && (x >= (collidable.x - width))) || 
         (x >= collidable.x && (x <= (collidable.x + collidable.width)))) &&
        ((y <= collidable.y && (y >= (collidable.y - height))) || 
         (y >= collidable.y && (y <= (collidable.y + collidable.height)))))
      notify :collided, BoundingBoxCollisionEvent.new(@target, collidable.target)
    end
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
end

class BoundingBoxCollisionEvent < Gemini::BehaviorEvent
  attr_accessor :colliding_object, :collided_object
  
  def load(source, other)
    @colliding_object = source
    @collided_object = other
  end
end