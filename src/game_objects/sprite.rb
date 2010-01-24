class Sprite < Jemini::GameObject
  has_behavior :DrawableImage

  def load(image = nil)
    self.image = image if image
  end
end