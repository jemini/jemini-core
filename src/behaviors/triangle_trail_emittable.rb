require 'behaviors/drawable'

class TriangleTrailEmittable < Gemini::Behavior
  #depends_on :Movable2d
  depends_on :Updates
  depends_on_kind_of :Spatial
  
  def load
    @emitter = @target.game_state.create :TriangleTrail
    @emitter_offset = [0,0]

    
    @target.on_update do
      @emitter.move(@emitter_offset[0] + @target.x, @emitter_offset[1] + @target.y)
    end
  end

  def unload
    @target.game_state.remove @emitter
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
  
  def layer=(layer_name)
    @target.game_state.manager(:game_object).move_game_object_to_layer(@emitter, layer_name)
  end
end