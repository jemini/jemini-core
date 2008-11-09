require 'behaviors/drawable'

class Sprite < Drawable
  include_class 'org.newdawn.slick.Image'
  depends_on :Spatial
  attr_accessor :image, :color, :texture_coords, :image_size
  alias_method :set_image_size, :image_size=
  declared_methods :draw, :set_image_size, :image_size=, :image_size, :image, :image=, :set_image,
                   :image_scaling, :color, :set_color, :color=, :image_rotation, :image_rotation=, :set_image_rotation,
                   :add_rotation, :texture_coords, :flip_horizontally, :flip_vertically, :move_by_top_left, :top_left_position
                 
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
  rescue => e
    puts "rotation error for: #{@target}"
  end
  alias_method :set_image_rotation, :image_rotation=
  
  def add_rotation(rotation)
    @image.rotate rotation
  end
  
  def flip_horizontally
    @texture_coords[1].x, @texture_coords[0].x = @texture_coords[0].x, @texture_coords[1].x
  end
  
  def flip_vertically
    @texture_coords[1].y, @texture_coords[0].y = @texture_coords[0].y, @texture_coords[1].y
  end
  
  def top_left_position
    #Vector.new(center_position.x - image_size.x / 2.0, center_position.y - image_size.y / 2.0)
    Vector.new(@target.x - image_size.x / 2.0, @target.y - image_size.y / 2.0)
  end
  
  def move_by_top_left(move_x_or_vector, move_y = nil)
    half_width = image_size.x / 2.0
    half_height = image_size.y / 2.0
    if move_y.nil?
      @target.move(move_x_or_vector.x + half_width, move_x_or_vector.y + half_height)
    else
      @target.move(move_x_or_vector + half_width, move_y + half_height)
    end
  end
  
  def draw(graphics)
    return if @image.nil? || @image_size.nil?
    half_width = image_size.x / 2.0
    half_height = image_size.y / 2.0
    center_x = @target.x - half_width
    center_y = @target.y - half_height
    #puts "drawing with rotation: #{@image.rotation}"
    unless 0 == @image.rotation
      graphics.rotate @target.x, @target.y, @image.rotation
    end
    @image.draw(center_x, center_y, @target.x + half_width, @target.y + half_height,
                @texture_coords[0].x * image_size.x, @texture_coords[0].y * image_size.y, @texture_coords[1].x * image_size.x, @texture_coords[1].y * image_size.y,
                @color.native_color)
    graphics.reset_transform
  end
end