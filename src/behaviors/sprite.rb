require 'drawable'

class Sprite < Drawable
  include_class 'org.newdawn.slick.Image'
  depends_on :Spatial
  
  attr_accessor :image, :color
  declared_methods :draw, :width, :height, :image, :image=, :set_iamge, :image_scaling, :color, :set_color, :rotation, :rotation=, :set_rotation
  wrap_with_callbacks :draw
    
  def load
    @color = clr(1.0, 1.0, 1.0, 1.0)
  end
  
  def width
    @image.width
  end
  
  def height
    @image.height
  end
  
  def image=(sprite_name)
    if sprite_name.kind_of? Image
      @image = sprite_name
    else
      @image = Image.new("data/#{sprite_name}")
    end
  end
  alias_method :set_image, :image=
  
  def set_color(r, g, b, a = 1.0)
    @color = clr(r.to_f, g.to_f, b.to_f, a)
  end
  
  def image_scaling(x_scale, y_scale = nil)
    y_scale = x_scale if y_scale.nil?
    @image = @image.get_scaled_copy(x_scale.to_f * width, y_scale.to_f * height)
  end
  
  def rotation
    @image.rotation
  end
  
  def rotation=(rotation)
    @image.rotation = rotation
  end
  alias_method :set_rotation, :rotation=
  
  def add_rotation(rotation)
    @image.rotate rotation
  end
  
  def draw(graphics)
    @image.draw(x, y, @color.native_color)
  end
end