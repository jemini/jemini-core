class SplineStretchableSprite < Gemini::Behavior
  INDEPENDENT_MODE = :independent
  MERGED_MODE = :merged
  depends_on_kind_of :Sprite
  depends_on :UpdatesAtConsistantRate #TODO: Make Updates coexist with this behavior
  
  declared_methods :set_stretch_spline, :set_stretch_splines
  
  def load
    @original_image = @target.image
    @target.on_update do
#      @target.width = @original_width
#      @target.height = @original_height
      old_width = @target.width
      old_height = @target.height
      @target.image = @original_image
      if INDEPENDENT_MODE == @mode
        @target.image_scaling(@spline_x.succ, @spline_y.succ)
      else
        @target.image_scaling(@spline.succ)
      end
      
      new_width = @target.width
      new_height = @target.height
      #recenter_position(old_width, old_height, new_width, new_height) unless @target.kind_of? TangibleSprite
    end
  end
  
  def set_stretch_splines(spline_x, spline_y = nil)
    @original_image = @target.image
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
    @target.x = @target.x + (old_width - new_width) / 2
    @target.y = @target.y + (old_height - new_height) / 2
  end
end