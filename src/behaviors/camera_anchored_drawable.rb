# These are sprites that deliberately ignore the scrolling of the render manager.
class CameraAnchoredDrawable < Gemini::Behavior
  #TODO: Change this to Drawable when the engine supports overriding declared methods (such as draw)
  depends_on :Sprite
  
  def load
    @target.on_before_draw do
      @render_manager = @target.game_state.manager(:render)
      return unless @render_manager.kind_of? ScrollingRenderManager
      @camera_position = @render_manager.camera_position
      @render_manager.renderer.gl_translatef(-@camera_position.x, -@camera_position.y, 0.0)
    end
    
    @target.on_after_draw do
      return unless @render_manager
      @render_manager.renderer.gl_translatef(@camera_position.x, @camera_position.y, 0.0)
      @camera_position = nil
    end
  end
end