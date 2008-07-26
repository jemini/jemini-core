class Movable2D < Gemini::Behavior
  depends_on :Position2D
  wrap_with_callbacks :move
  declared_methods :move
  
  def move(x, y)
    self.x = x unless x.nil?
    self.y = y unless y.nil?
  end
end