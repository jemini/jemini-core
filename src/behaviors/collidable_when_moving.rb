class CollidableWhenMoving < Gemini::Behavior
  depends_on :BoundingBoxCollidable
  depends_on :Movable2D
  depends_on :Taggable
  
  declared_methods :preferred_collision_check, :collides_with_tags
  
  DISTANCE = :distance
  TAGS = :tags
  
  def load
    
    @algorithm = DISTANCE
    
    @target.on_after_move do
      if TAGS == @algorithm
        state.manager(:tag).find_by_any_tags(*@tags).each {|collidable| collision_check collidable }
      elsif DISTANCE == @algorithm
        state.manager(:game_object).game_objects.each {|collidable| collision_check collidable }
      end
    end
  end
  
  def collides_with_tags(*tags)
    @tags = tags
  end
  
  def preferred_collision_check(type)
    raise "Invalid collision type" unless DISTANCE == type || TAGS == type
    @algorithm = type
  end
end