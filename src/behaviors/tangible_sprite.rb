require 'behaviors/sprite'

class TangibleSprite < Gemini::Behavior
  depends_on :Sprite
  depends_on :Tangible
  declared_methods :bounded_image=, :set_bounded_image, :tiled_to_bounds=, :set_tiled_to_bounds
  attr_accessor :tiled_to_bounds
  alias_method :set_tiled_to_bounds, :tiled_to_bounds=
  
  def load
    #TODO: This should call a method that does the same thing for performance
    @target.on_before_draw do
      @target.image_rotation = @target.rotation
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