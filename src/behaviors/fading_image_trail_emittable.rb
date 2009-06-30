#Makes an object leave a trail of images behind it that fade over time.
class FadingImageTrailEmittable < Gemini::Behavior
  depends_on :Updates
  
  def load
    @fading_image_offset = Vector.new(0,0)
    @move_threshold = 4
    @move_count = 0
    @seconds_to_fade_away = 2
    @target.on_update do
      @move_count += 1
      if @move_count >= @move_threshold
        fading_image = @target.game_state.create_game_object :FadingImage, @image, Color.new(:white), @seconds_to_fade_away
        #center_position = @target.center_position
        fading_image.move(@fading_image_offset.x + @target.x, @fading_image_offset.y + @target.y)
        @move_count = 0
      end
    end 
  end
  
  #Sets the Image to emit.
  def emit_fading_image(image)
    @image = image
  end
  
  #Causes fading images to appear at some distance away from object.
  #Takes a Vector with the x/y offset at which to emit the images.
  def emit_fading_image_trail_from_offset(offset)
    @fading_image_offset = offset
  end
  
end