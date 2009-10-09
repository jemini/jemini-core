require 'behaviors/drawable'

#Makes an object draw a shrinking trail behind itself as it moves.
class TriangleTrailEmittable < Jemini::Behavior
  #depends_on :Movable2d
  depends_on :Updates
  depends_on_kind_of :Spatial
  
  def load
    @emitter = @game_object.game_state.create :TriangleTrail
    @emitter_offset = [0,0]

    
    @game_object.on_update do
      @emitter.position = Vector.new(@emitter_offset[0] + @game_object.x, @emitter_offset[1] + @game_object.y)
    end
  end

  def unload
    @game_object.game_state.remove @emitter
  end
  
  #Transparency to use.  1.0 is opaque.  Default is 0.5.
  def alpha
    @emitter.alpha
  end
  
  def alpha=(alpha)
    @emitter.alpha = alpha
  end
  
  #Takes an Array with the relative x and y coordinates to begin the trail.
  def emit_triangle_trail_from_offset(offset)
    @emitter_offset = offset
  end
  
  #Specifies the half-width of the widest part of the trail.
  def emit_triangle_trail_with_radius(radius)
    @emitter.radius = radius
  end
  
  #Name of layer to draw trail on.
  def layer=(layer_name)
    @game_object.game_state.manager(:game_object).move_game_object_to_layer(@emitter, layer_name)
  end
end