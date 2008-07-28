require 'behavior_event'

class BoundingBoxCollidable < Gemini::Behavior
  DISTANCE = :distance
  TAGS = :tags
  depends_on :Tags
  depends_on :Movable2D
  
  declared_methods :preferred_collision_check, :collides_with_tags
  
  @@collidables = []
  
  def self.add_collidable(game_object)
    @@collidables << game_object unless @@collidables.member? game_object
  end
  
  def self.remove_collidable(game_object)
    @@collidables.delete game_object
  end
  
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

class Ball < Gemini::GameObject
  attr_accessor :vector
  
  has_behavior :UpdatesAtConsistantRate
  has_behavior :BoundingBoxCollidable
  has_behavior :Sprite
  
  def load
    collides_with_tags :wall
    preferred_collision_check BoundingBoxCollidable::TAGS
    self.image = "ball.png"
    self.updates_per_second = 30
    self.x = rand(640 - width)
    self.y = rand(480 - height)
    @vector = [0,0]
    
    on_collided do |event, continue|
      vector[0] *= -1 if x > (640 - width) || x < 0
      vector[1] *= -1 if y > (480 - height) || y < 0
   end
  end
  
  def tick
    move(x + @vector[0], y + @vector[1])
  end
end

class Wall < Gemini::GameObject
  has_behavior :BoundingBoxCollidable
  
  def load(x, y, width, height)
    self.x = x
    self.y = y
    self.width = width
    self.height = height
    self.add_tag :wall
  end
end