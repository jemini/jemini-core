class FadingImageTrailEmittable < Gemini::Behavior
  declared_methods :emit_fading_image_trail_from_offset, :emit_fading_image
  depends_on :Updates
  
  def load
    @fading_image_offset = vec(0,0)
    @move_threshold = 4
    @move_count = 0
    @seconds_to_fade_away = 2
    #@target.on_after_move do
    @target.on_update do
      @move_count += 1
      if @move_count >= @move_threshold
        fading_image = game_state.create_game_object :FadingImage, @image, clr(:white), @seconds_to_fade_away
        if @target.kind_of? TangibleSprite
          x = self.x - (width / 2)
          y = self.y - (height / 2)
        else
          x = self.x
          y = self.y
        end
        fading_image.move(@fading_image_offset.x + x, @fading_image_offset.y + y)
        @move_count = 0
      end
    end 
  end
  
  def emit_fading_image(image)
    @image = image
  end
  def emit_fading_image_trail_from_offset(offset)
    @fading_image_offset = offset
  end
  
end