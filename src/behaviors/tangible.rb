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

class Tangible < Gemini::Behavior
  depends_on :Spatial
  attr_reader :tangible_shape
  declared_methods :set_tangible_shape, :tangible_shape, :tangible_debug_mode=, :set_tangible_debug_mode, :tangibly_collides_with?

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

  def tangibly_collides_with?(other_tangible)
    #TODO: top_left isn't on spatial...
    other_shape = other_tangible.instance_variable_get(:@__behaviors)[:Tangible].instance_variable_get(:@tangible_shape)
#    puts(@target.x < other_tangible.x)
#    puts((@target.x + @tangible_shape.size.x) > other_tangible.x)
#    puts '--------'
    #puts((@target.x < other_tangible.x) && (@tangible_shape.size.x > other_tangible.x))
    (@target.x < other_tangible.x && (@target.x + @tangible_shape.size.x) > other_tangible.x) &&
    (@target.y < other_tangible.y && (@target.y + @tangible_shape.size.y) > other_tangible.y)
  end
end