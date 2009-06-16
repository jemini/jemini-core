class WorldCollidable < Gemini::Behavior
  depends_on :BoundingBoxCollidable
  depends_on_kind_of :CollisionPoolAlgorithm
  
  def world_collision_check
    get_collision_candidates.each {|candidate| collision_check candidate}
  end
end