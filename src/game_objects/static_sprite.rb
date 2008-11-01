class StaticSprite < Gemini::GameObject
  has_behavior :TangibleSprite
  def load(sprite_name_or_image, x=nil, y=nil, width=nil, height=nil, *tags)
    set_image sprite_name_or_image
    if width.nil? || height.nil?
      set_shape :Box, image_size.x, image_size.y
    else
      set_shape :Box, width, height
    end
    unless x.nil? || y.nil?
      move(x, y)
    end
    set_mass Tangible::INFINITE_MASS
    set_static_body
    set_restitution 1.0
    set_friction 0.0
  end
end