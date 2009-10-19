#Gives an object a bitmap that responds appropriately to the physics engine.
class PhysicalSprite < Jemini::Behavior
  depends_on :Sprite
  depends_on :Physical
  attr_accessor :tiled_to_bounds
  alias_method :set_tiled_to_bounds, :tiled_to_bounds=
  
  def load
    @game_object.on_before_draw :draw_physical_sprite
    @offset_position = Vector.new
    @offset_rotation = 0.0
  end
  
  def bounded_image=(new_image)
    @game_object.set_image new_image
    @game_object.set_shape(:Box, @game_object.image_size.x, @game_object.image_size.y)
  end
  alias_method :set_bounded_image, :bounded_image=
  
  def tiled_to_bounds=(state)
    @tiled_to_bounds = state
    @game_object.image_size = @game_object.box_size
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
    @game_object.image_rotation = @game_object.physical_rotation unless @game_object.image.nil?
    #TODO: Only execute this if the shape is bound to the image.
    #TODO: Call raw_move instead of x= and y=
    position = @game_object.body_position

    offset = Vector::ORIGIN.pivot_around_degrees(@offset_position, @game_object.physical_rotation + @offset_rotation)
    @game_object.x = position.x + offset.x
    @game_object.y = position.y + offset.y
  end
end