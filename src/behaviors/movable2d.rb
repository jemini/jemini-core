#Makes an object move within a 2D plane.
class Movable2d < Gemini::Behavior
  depends_on :Spatial2d
  wrap_with_callbacks :move
  
  def move(x, y)
    self.x = x unless x.nil?
    self.y = y unless y.nil?
  end
end