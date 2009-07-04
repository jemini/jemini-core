#Gives an object a bitmap that responds appropriately to the physics engine.
class PhysicalSprite < Gemini::Behavior
  depends_on :Sprite
  depends_on :Physical
  attr_accessor :tiled_to_bounds
  alias_method :set_tiled_to_bounds, :tiled_to_bounds=
  
  def load
    @target.on_before_draw :draw_physical_sprite
    @offset_position = Vector.new
    @offset_rotation = 0.0
  end
  
  def bounded_image=(new_image)
    @target.set_image new_image
    @target.set_shape(:Box, @target.image_size.x, @target.image_size.y)
  end
  alias_method :set_bounded_image, :bounded_image=
  
  def tiled_to_bounds=(state)
    @tiled_to_bounds = state
    @target.image_size = @target.box_size
  end

  def physical_sprite_position_offset=(offset)
    @offset_position = offset.dup
  end
  alias_method :set_physical_sprite_position_offset, :physical_sprite_position_offset=

  def physical_sprite_rotation_offset=(offset)
    @offset_rotation = offset
  end
  alias_method :set_physical_sprite_rotation_offset, :physical_sprite_rotation_offset=

  def draw_physical_sprite(graphics)
    @target.image_rotation = @target.physical_rotation unless @target.image.nil?
    #TODO: Only execute this if the shape is bound to the image.
    #TODO: Call raw_move instead of x= and y=
    position = @target.body_position

    offset = Vector::ORIGIN.pivot_around_degrees(@offset_position, @target.physical_rotation + @offset_rotation)
    @target.x = position.x + offset.x
    @target.y = position.y + offset.y
  end
end