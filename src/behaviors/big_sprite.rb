# Simplistic implementation of a big image to be used as a background image

class BigSprite < Drawable
  include_class 'org.newdawn.slick.BigImage'
  attr_accessor :image
  depends_on :Spatial
  declared_methods :draw, :image, :set_image, :image=
  
  def load
    @color = Color.new(1.0, 1.0, 1.0, 1.0)
    @texture_coords = [Vector.new(0.0, 0.0), Vector.new(1.0, 1.0)]
  end
  
  def draw(graphics)
    half_width = @image.width / 2
    half_height = @image.height / 2
    center_x = @target.x - half_width
    center_y = @target.y - half_height
    #puts "drawing with rotation: #{@image.rotation}"
    unless 0 == @image.rotation
      graphics.rotate @target.x, @target.y, @image.rotation
    end
    @image.draw(center_x, center_y, @target.x + half_width, @target.y + half_height,
                @texture_coords[0].x * @image.width, @texture_coords[0].y * @image.height, @texture_coords[1].x * @image.width, @texture_coords[1].y * @image.height,
                @color.native_color)
    graphics.reset_transform
  end
  
  def image=(sprite_name)
    if sprite_name.kind_of? BigImage
      @image = sprite_name
    else
      @image = BigImage.new("data/#{sprite_name}")
      puts @image.width
      puts @image.height
    end
#    set_image_size(Vector.new(@image.width, @image.height))
  end
  alias_method :set_image, :image=
end