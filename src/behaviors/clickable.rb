class Clickable < Gemini::Behavior
  depends_on :WorldCollidable
  depends_on :CollisionPoolAlgorithmTaggable
  
  wrap_with_callbacks :click
  declared_methods :click
  
  def click; end
end