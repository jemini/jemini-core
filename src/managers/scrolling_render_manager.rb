require 'managers/basic_render_manager'

class ScrollingRenderManager < BasicRenderManager
  attr_accessor :camera_position, :tracking_game_object
  alias_method :set_camera_position, :camera_position=
  alias_method :set_tracking_game_object, :tracking_game_object=
  
  def load(camera_position_or_tracking_game_object=nil)
    unless camera_position_or_tracking_game_object.nil?
      if camera_position_or_tracking_game_object.kind_of? Vector
        @camera_position = camera_position_or_tracking_game_object
      else
        @tracking_game_object = camera_position_or_tracking_game_object
      end
    end
    @gl = Java::org::newdawn::slick::opengl::renderer::Renderer.get
    super()
  end
  
  def renderer
    @gl
  end
  
  def render(graphics)
    translation = camera_position
    @gl.gl_translatef(translation.x, translation.y, 0.0)
    super
    @gl.gl_translatef(-translation.x, -translation.y, 0.0)
  end
  
  def camera_position
    @camera_position || calculate_object_position
  end
  
  def calculate_object_position
    #TODO: This should go once declared method overriding is possible.
    position = @tracking_game_object.position
    Vector.new(-(position.x - (@game_state.screen_width / 2)), -(position.y - (@game_state.screen_height / 2)))
#    if @tracking_game_object.kind_of? TangibleSprite
#      body_position = @tracking_game_object.body_position
#      Vector.new(-(body_position.x - (@game_state.screen_width / 2)), -(body_position.y - (@game_state.screen_height / 2)))
#    else
#      Vector.new(-(body_position.x - (@game_state.screen_width / 2)), -(body_position.y - (@game_state.screen_height / 2)))
#    end
  end
end