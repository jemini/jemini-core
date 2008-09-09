require 'sprite'

class TangibleSprite < Sprite
  depends_on :Tangible
  #:width, :height, 
  declared_methods :draw, :image, :image=, :set_image, :image_scaling, :color, :set_color, :bounded_image=, :set_bounded_image
  #:rotation, :rotation=, :set_rotation, 
  wrap_with_callbacks :draw
#  use_behaviors_methods :Tangible => [:width, :height]
  
#  def width
#    @target.behavior[:Tangible].width
#  end
#  
#  def height
#    @target.height
#  end
  
  def image=(image)
    super
  end
  alias_method :set_image, :image=
  
  def bounded_image=(new_image)
    set_image new_image
    set_shape(:Box, image.width, image.height)
  end
  alias_method :set_bounded_image, :bounded_image=
  
  
  def center_position
    vec(x - (width / 2), y - (height / 2))
  end
  
  def draw(graphics)
    image.rotation = @target.rotation
    position = center_position
    @image.draw(position.x, position.y, @color.native_color)
  end
end