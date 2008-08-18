class Drawable < Gemini::Behavior
  depends_on :Spatial2d
  declared_methods :draw
  
  def draw; end
end