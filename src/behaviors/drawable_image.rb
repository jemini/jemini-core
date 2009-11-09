require 'behaviors/drawable'

#Makes an object draw itself as a bitmap image.
class DrawableImage < Jemini::Behavior
  include_class 'org.newdawn.slick.Image'
  depends_on :Spatial
  attr_accessor :image, :color, :texture_coords, :image_size
  alias_method :set_image_size, :image_size=               
  wrap_with_callbacks :draw
    
  def load
    @color = Color.new(1.0, 1.0, 1.0, 1.0)
    @texture_coords = [Vector.new(0.0, 0.0), Vector.new(1.0, 1.0)]
    @rotation = 0.0
  end

  #Takes a reference to an image loaded via the resource manager, and sets the bitmap.
  def image=(reference)
    store_image(game_state.manager(:resource).get_image(reference))
  end
  alias_method :set_image, :image=

  #Assign a Color to the image.
  def color=(color)
    @color = color
  end
  alias_method :set_color, :color=
  
  #Increase or decrease horizontal and vertical scale for the image.  1.0 is identical to the current scale.  If y_scale is omitted, x_scale is used for both axes.
  #TODO: Take vectors for first args as well
  def image_scaling(x_scale, y_scale = nil)
    y_scale = x_scale if y_scale.nil?
    store_image(@image.get_scaled_copy(x_scale.to_f * image_size.x, y_scale.to_f * image_size.y))
  end

  #Set horizontal and vertical scale for the image relative to the original.  1.0 is original scale.  If y_scale is omitted, x_scale is used for both axes.
  #TODO: Take vectors for first args as well
  def scale_image_from_original(x_scale, y_scale = nil)
    y_scale = x_scale if y_scale.nil?
    @original_image = @image.copy if @original_image.nil?
    store_image(@original_image.get_scaled_copy(x_scale.to_f * @original_image.width, y_scale.to_f * @original_image.height))
  end
  
  # WARNING: Using Slick's image for rotation can cause some odd quirks with it
  # not quite rotating correctly (especially noticable around 180 degress).
  # @rotation stands alone for this reason, instead of using Slick's rotation
  def image_rotation
    @rotation
  end
  
  def image_rotation=(rotation)
    @rotation = rotation
  end
  alias_method :set_image_rotation, :image_rotation=
  
  #Increment the image rotation.
  def add_rotation(rotation)
    @rotation += rotation
  end
  
  #Flip the texture horizontally.
  def flip_horizontally
    @texture_coords[1].x, @texture_coords[0].x = @texture_coords[0].x, @texture_coords[1].x
  end
  
  #Flip the texture vertically.
  def flip_vertically
    @texture_coords[1].y, @texture_coords[0].y = @texture_coords[0].y, @texture_coords[1].y
  end
  
  #Returns a Vector with the x/y coordinates of the image's top left corner.
  def top_left_position
    #Vector.new(center_position.x - image_size.x / 2.0, center_position.y - image_size.y / 2.0)
    Vector.new(@game_object.x - image_size.x / 2.0, @game_object.y - image_size.y / 2.0)
  end
  
  #Takes either a single Vector or the x/y coordinates to move the image's top left corner to.
  def move_by_top_left(move_x_or_vector, move_y = nil)
    half_width = image_size.x / 2.0
    half_height = image_size.y / 2.0
    if move_y.nil?
      @game_object.move(move_x_or_vector.x + half_width, move_x_or_vector.y + half_height)
    else
      @game_object.move(move_x_or_vector + half_width, move_y + half_height)
    end
  end
  
  #Draw the image to the given graphic context.
  def draw(graphics)
    return if @image.nil? || @image_size.nil?
    half_width = image_size.x / 2.0
    half_height = image_size.y / 2.0
    center_x = @game_object.x - half_width
    center_y = @game_object.y - half_height
    unless 0 == @rotation
      graphics.rotate @game_object.x, @game_object.y, @rotation
    end
    @image.draw(center_x, center_y, @game_object.x + half_width, @game_object.y + half_height,
                @texture_coords[0].x * image_size.x, @texture_coords[0].y * image_size.y, @texture_coords[1].x * image_size.x, @texture_coords[1].y * image_size.y,
                @color.native_color)
    graphics.reset_transform
  end
  
  private
  
    def store_image(value)
      @image = value
      set_image_size(Vector.new(@image.width, @image.height))
      @image
    end
end