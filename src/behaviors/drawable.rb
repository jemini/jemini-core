#Makes an object draw itself to the screen.
class Drawable < Jemini::Behavior
  depends_on_kind_of :Spatial
  wrap_with_callbacks :draw

  def draw(graphics); end
end