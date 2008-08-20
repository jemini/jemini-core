class Drawable < Gemini::Behavior
  depends_on :Spatial2d
  declared_methods :draw
  wrap_with_callbacks :draw
  
  def draw; end
end