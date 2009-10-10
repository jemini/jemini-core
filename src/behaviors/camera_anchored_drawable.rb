#These are sprites that deliberately ignore the scrolling of the render manager.
class CameraAnchoredDrawable < Jemini::Behavior
  #TODO: Change this to Drawable when the engine supports overriding declared methods (such as draw)
  depends_on :Sprite
  
  def load
    @game_object.on_before_draw do
      @render_manager = @game_object.game_state.manager(:render)
      return unless @render_manager.has_behavior? :ScrollingRenderManager
      @camera_position = @render_manager.camera_position
      @render_manager.renderer.gl_translatef(-@camera_position.x, -@camera_position.y, 0.0)
    end
    
    @game_object.on_after_draw do
      return unless @render_manager
      @render_manager.renderer.gl_translatef(@camera_position.x, @camera_position.y, 0.0)
      @camera_position = nil
    end
  end
end