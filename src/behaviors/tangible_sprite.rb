require 'behaviors/sprite'

class TangibleSprite < Sprite
  depends_on :Tangible 
  declared_methods :center_position, :draw, :image, :image=, :set_image, :image_scaling, :color, :set_color, :bounded_image=, :set_bounded_image, :flip_horizontally, :tiled_to_bounds=, :set_tiled_to_bounds
  wrap_with_callbacks :draw
  attr_accessor :tiled_to_bounds
  alias_method :set_tiled_to_bounds, :tiled_to_bounds=
  
  def bounded_image=(new_image)
    set_image new_image
    set_shape(:Box, image.width, image.height)
  end
  alias_method :set_bounded_image, :bounded_image=
  
  def center_position
    if @tiled_to_bounds
      box_size = @target.box_size
      Vector.new(@target.x - (box_size.x / 2), @target.y - (box_size.y / 2))
    else
      Vector.new(@target.x - (@image.width / 2), @target.y - (@image.height / 2))
    end
    
  end
  
  def render_width
    if @tiled_to_bounds
      @target.box_size.x
    else
      super
    end
  end
  
  def render_height
    if @tiled_to_bounds
      @target.box_size.y
    else
      super
    end
  end
  
  def draw(graphics)
    @image.rotation = @target.rotation
    super
  end
end