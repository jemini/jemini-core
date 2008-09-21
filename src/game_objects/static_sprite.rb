class StaticSprite < Gemini::GameObject
  has_behavior :TangibleSprite
  def load(sprite_name_or_image, x, y, width, height, *tags)
    set_image sprite_name_or_image
    set_shape :Box, width, height
    #set_shape :Polygon, [Vector.new(0, 0), Vector.new(0, width), Vector.new(width, height), Vector.new(0, height), Vector.new(0, 0)].map {|v| v.to_phys2d_vector}.to_java('net.phys2d.math.Vector2f')
    set_mass Tangible::INFINITE_MASS
    move(x, y)
    set_static_body
    set_restitution 1.0
    set_friction 0.0
  end
end