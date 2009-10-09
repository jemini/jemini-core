class SplineStretchableSprite < Jemini::Behavior
  INDEPENDENT_MODE = :independent
  MERGED_MODE = :merged
  depends_on_kind_of :Sprite
  depends_on :UpdatesAtConsistantRate #TODO: Make Updates coexist with this behavior
  
  def load
    @original_image = @game_object.image
    @game_object.on_update do
#      @game_object.width = @original_width
#      @game_object.height = @original_height
      old_width = @game_object.width
      old_height = @game_object.height
      @game_object.image = @original_image
      if INDEPENDENT_MODE == @mode
        @game_object.image_scaling(@spline_x.succ, @spline_y.succ)
      else
        @game_object.image_scaling(@spline.succ)
      end
      
      new_width = @game_object.width
      new_height = @game_object.height
      #recenter_position(old_width, old_height, new_width, new_height) unless @game_object.kind_of? TangibleSprite
    end
  end
  
  def set_stretch_splines(spline_x, spline_y = nil)
    @original_image = @game_object.image
    unless spline_y.nil?
      @spline_x = spline_x
      @spline_y = spline_y
      @mode = INDEPENDENT_MODE
    else
      @spline = spline_x
      @mode = MERGED_MODE
    end
  end
  alias_method :set_stretch_spline, :set_stretch_splines
  
private
  def recenter_position(old_width, old_height, new_width, new_height)
    @game_object.x = @game_object.x + (old_width - new_width) / 2
    @game_object.y = @game_object.y + (old_height - new_height) / 2
  end
end