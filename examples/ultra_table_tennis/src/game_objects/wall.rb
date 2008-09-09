class Wall < Gemini::GameObject
#  has_behavior :BoundingBoxCollidable
  has_behavior :Taggable
  has_behavior :Tangible
  
  def load(x, y, width, height, *tags)
    set_shape :Box, width, height
    set_mass 10000000 #Tangible::INFINITE_MASS 
    set_restitution 1.0
    come_to_rest
    move(x, y)
    add_tag :wall, *tags
  end
end