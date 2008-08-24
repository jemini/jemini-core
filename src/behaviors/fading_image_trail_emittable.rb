class FadingImageTrailEmittable < Gemini::Behavior
  declared_methods :emit_fading_image_trail_from_offset, :emit_fading_image
  
  def load
    @fading_image_offset = vec(0,0)
    @move_threshold = 4
    @move_count = 0
    @seconds_to_fade_away = 2
    on_after_move do
      @move_count += 1
      if @move_count >= @move_threshold
        fading_image = game_state.create_game_object :FadingImage, @image, clr(:white), @seconds_to_fade_away
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