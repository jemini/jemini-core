class CollisionPoolAlgorithm < Gemini::Behavior
  depends_on :BoundingBoxCollidable
  
  declared_methods :get_collision_candidates
end