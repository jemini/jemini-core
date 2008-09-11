class FadingImage < Gemini::GameObject
  has_behavior :Sprite
  has_behavior :UpdatesAtConsistantRate
  has_behavior :Spatial
  
  def load(sprite, color, seconds_to_fade_away)
    @seconds_to_fade_away = seconds_to_fade_away
    self.image = sprite
    self.color = color
    @initial_alpha = self.color.alpha
    @alpha = 1.0
    on_update do
      fade
    end
  end
  
  def fade
    @alpha = @alpha - (@seconds_to_fade_away.to_f * (1.0 / updates_per_second.to_f))
    color.alpha = @alpha
    if 0 >= color.alpha
      game_state.remove_game_object self
    end
  end
end