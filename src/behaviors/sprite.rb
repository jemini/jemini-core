require 'behaviors/drawable'

class Sprite < Drawable
  include_class 'org.newdawn.slick.Image'
  depends_on :Spatial
  attr_accessor :image, :color, :texture_coords, :image_size
  alias_method :set_image_size, :image_size=
  declared_methods :center_position, :draw, :set_image_size, :image_size=, :image_size, :image, :image=, :set_image,
                   :image_scaling, :color, :set_color, :color=, :image_rotation, :image_rotation=, :set_image_rotation,
                   :texture_coords, :flip_horizontally
                 
  wrap_with_callbacks :draw
    
  def load
    @color = Color.new(1.0, 1.0, 1.0, 1.0)
    @texture_coords = [Vector.new(0.0, 0.0), Vector.new(1.0, 1.0)]
  end
  
  def image=(sprite_name)
    if sprite_name.kind_of? Image
      @image = sprite_name
    else
      @image = Image.new("data/#{sprite_name}")
    end
    set_image_size(Vector.new(@image.width, @image.height))
  end
  alias_method :set_image, :image=
  
  def color=(color)
    @color = color
  end
  alias_method :set_color, :color=
  
  def image_scaling(x_scale, y_scale = nil)
    y_scale = x_scale if y_scale.nil?
    set_image @image.get_scaled_copy(x_scale.to_f * image_size.x, y_scale.to_f * image_size.y)
  end
  
  def image_rotation
    @image.rotation
  end
  
  def image_rotation=(rotation)
    @image.rotation = rotation
  end
  alias_method :set_image_rotation, :image_rotation=
  
  def add_rotation(rotation)
    @image.rotate rotation
  end
  
  def flip_horizontally
    @texture_coords[1].x, @texture_coords[0].x = @texture_coords[0].x, @texture_coords[1].x
  end
  
  def draw(graphics)
    half_width = image_size.x / 2
    half_height = image_size.y / 2
    @image.draw(@target.x - half_width, @target.y - half_height, @target.x + half_width, @target.y + half_height,
                @texture_coords[0].x * image_size.x, @texture_coords[0].y * image_size.y, @texture_coords[1].x * image_size.x, @texture_coords[1].y * image_size.y,
                @color.native_color)
  end
end