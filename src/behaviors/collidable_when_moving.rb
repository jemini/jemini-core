class CollidableWhenMoving < Gemini::Behavior
  depends_on :BoundingBoxCollidable
  depends_on :Movable2D
  
  def load
    @target.on_after_move do
      if TAGS == @algorithm
        Tags.find_by_all_tags(*@tags).each {|collidable| collision_check collidable }
      elsif DISTANCE == @algorithm
        @@collidables.each {|collidable| collision_check collidable, source_bounds }
      end
    end
  end
end