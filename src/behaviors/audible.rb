class Audible < Gemini::Behavior
  
  def load_sound(reference, path)
    @target.game_state.manager(:sound).add_sound(reference, path)
  end
  
  def emit_sound(reference, volume = 1.0, pitch = 1.0)
    @target.game_state.manager(:sound).play_sound(reference, volume, pitch)
  end
  
end