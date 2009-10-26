class FadingImage < Jemini::GameObject
  has_behavior :DrawableImage
  has_behavior :Spatial
  has_behavior :Timeable
  
  def load(image, color, seconds_to_fade_away)
    self.image = image
    self.color = color
    add_countdown :fade_timer, seconds_to_fade_away, 1.0 / 30.0 
    
    on_countdown_complete do
      game_state.remove self
    end
    
    on_timer_tick do |timer|
      fade(timer.percent_complete)
    end
  end
  
  def fade(percent)
    color.transparency = percent
  end
end