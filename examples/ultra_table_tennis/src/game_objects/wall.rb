class Wall < Gemini::GameObject
#  has_behavior :BoundingBoxCollidable
  has_behavior :Taggable
  has_behavior :Tangible
  
  def load(x, y, width, height, *tags)
    set_shape :Box, width, height
    move(x, y)
    set_mass 100000
    add_tag :wall, *tags
  end
end