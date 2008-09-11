require 'behaviors/drawable'

class Sprite < Drawable
  include_class 'org.newdawn.slick.Image'
  depends_on :Spatial
  
  attr_accessor :image, :color
  declared_methods :draw, :width, :height, :image, :image=, :set_iamge, :image_scaling, :color, :set_color, :color=, :rotation, :rotation=, :set_rotation, :center_position
  wrap_with_callbacks :draw
    
  def load
    @color = Color.new(1.0, 1.0, 1.0, 1.0)
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
  
  def color=(color)
    @color = color
  end
  alias_method :set_color, :color=
  
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
  
  def center_position
    Vector.new(x - (width / 2), y - (height / 2))
  end
  
  def draw(graphics)
    @image.draw(x, y, @color.native_color)
  end
end