require 'behaviors/sprite'

class TangibleSprite < Sprite
  depends_on :Tangible 
  declared_methods :center_position, :draw, :image, :image=, :set_image, :image_scaling, :color, :set_color, :bounded_image=, :set_bounded_image
  wrap_with_callbacks :draw
  
  def bounded_image=(new_image)
    set_image new_image
    set_shape(:Box, image.width, image.height)
  end
  alias_method :set_bounded_image, :bounded_image=
  
  def center_position
    Vector.new(@target.x - (@image.width / 2), @target.y - (@image.height / 2))
  end
  
  def draw(graphics)
    @image.rotation = @target.rotation
    super
  end
end