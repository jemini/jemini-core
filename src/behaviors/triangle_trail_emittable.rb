require 'drawable'

class TriangleTrailEmittable < Gemini::Behavior
  depends_on :Spatial2d
  #depends_on :Drawable
  declared_methods :emit_triangle_trail_from_offset
  
  def load
    @emitter = game_state.create_game_object :TriangleTrail
    @emitter_offset = [0,0]
    
    on_after_x_changes do
      @emitter.x = @emitter_offset[0] + x
    end
    on_after_y_changes do
      @emitter.y = @emitter_offset[1] + y
    end
  end
  
  def emit_triangle_trail_from_offset(offset)
    @emitter_offset = offset
  end
end