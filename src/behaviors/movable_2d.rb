class Movable2D < Gemini::Behavior
  depends_on :Position2D
  declared_methods :move
  
  def move(x, y)
    self.x = x
    self.y = y
  end
end