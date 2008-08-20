class Wall < Gemini::GameObject
  has_behavior :BoundingBoxCollidable
  has_behavior :Taggable
  
  def load(x, y, width, height, tag)
    self.x = x
    self.y = y
    self.width = width
    self.height = height
    add_tag :wall, tag
  end
end