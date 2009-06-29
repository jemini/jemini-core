#Gives an object a bitmap that responds appropriately to the physics engine.
class PhysicalSprite < Gemini::Behavior
  depends_on :Sprite
  depends_on :Physical
  attr_accessor :tiled_to_bounds
  alias_method :set_tiled_to_bounds, :tiled_to_bounds=
  
  def load
    #TODO: This should call a method that does the same thing for performance
    @target.on_before_draw do
      @target.image_rotation = @target.physical_rotation unless @target.image.nil?
      #TODO: Only execute this if the shape is bound to the image.
      #TODO: Call raw_move instead of x= and y=
      position = @target.body_position
      @target.x = position.x
      @target.y = position.y
    end
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
end