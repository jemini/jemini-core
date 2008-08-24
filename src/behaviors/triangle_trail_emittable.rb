require 'drawable'

class TriangleTrailEmittable < Gemini::Behavior
  depends_on :Movable2d
  #depends_on :Drawable
  declared_methods :emit_triangle_trail_from_offset, :emit_triangle_trail_with_radius, :alpha, :alpha=
  
  def load
    @emitter = game_state.create_game_object :TriangleTrail
    @emitter_offset = [0,0]
    
    on_after_move do
      @emitter.move(@emitter_offset[0] + x, @emitter_offset[1] + y)
      #@emitter.inertia = inertia
    end
  end
  
  def alpha
    @emitter.alpha
  end
  
  def alpha=(alpha)
    @emitter.alpha = alpha
  end
  
  def emit_triangle_trail_from_offset(offset)
    @emitter_offset = offset
  end
  
  def emit_triangle_trail_with_radius(radius)
    @emitter.radius = radius
  end
end