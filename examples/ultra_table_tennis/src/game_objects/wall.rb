class Wall < Gemini::GameObject
#  has_behavior :BoundingBoxCollidable
  has_behavior :Taggable
  has_behavior :Tangible
  
  def load(x, y, width, height, *tags)
    set_shape :Box, width, height
    set_mass Tangible::INFINITE_MASS
    move(x, y)
    set_static_body
    set_restitution 1.0
    come_to_rest
    add_tag :wall, *tags
  end
end