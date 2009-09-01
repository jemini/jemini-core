#A shape used to determine if one object collides with another.
class TangibleBox
  attr_accessor :size
  def get_points(top_left_position, rotation)
    top_left = top_left_position
    top_right = Vector.new(top_left_position.x + size.x, top_left_position.y)
    bottom_left = Vector.new(top_left_position.x, top_left_position.y + size.y)
    bottom_right = Vector.new(top_left_position.x + size.x, top_left_position.y + size.y)
    [top_left, top_right, bottom_right, bottom_left]
  end
end

#Allows an object to indicate when it collides with another.
class Tangible < Jemini::Behavior
  depends_on :Spatial
  attr_reader :tangible_shape

  def load
    @target.enable_listeners_for :tangible_collision
  end

  def tangible_debug_mode=(mode)
    if mode
      @target.add_behavior :DebugTangible
    else
      @target.remove_behavior :DebugTangible
    end
  end
  alias_method :set_tangible_debug_mode, :tangible_debug_mode=

  #Set the shape of the object as seen by collision calculations.
  #call-seq:
  #set_shape(:Box, vector)
  #set_shape(:Box, width, height)
  #
  def set_tangible_shape(name, *args)
    @tangible_shape =  case name
                       when :Box
                         box = TangibleBox.new
                         if args.size == 1
                           box.size = args[0]
                         else
                           box.size = Vector.new(args[0], args[1])
                         end
                         box
                       end
  end

  #Indicates whether this object collides with the given object.
  def tangibly_collides_with?(other_tangible)
    #TODO: top_left isn't on spatial...
    other_shape = other_tangible.tangible_shape

    ((@target.x <= other_tangible.x && (@target.x + @tangible_shape.size.x) >= other_tangible.x) ||
    (@target.x >= other_tangible.x && @target.x <= (other_tangible.x + other_shape.size.x))) &&
    ((@target.y <= other_tangible.y && (@target.y + @tangible_shape.size.y) >= other_tangible.y) ||
    (@target.y >= other_tangible.y && @target.y <= (other_tangible.y + other_shape.size.y)))
  end
end