class Clickable < Gemini::Behavior
  depends_on :BoundingBoxCollidable
  wrap_with_callbacks :click
  declared_methods :click
  
  def load
    preferred_collision_check BoundingBoxCollidable::TAGS
  end
  
  def click; end
end