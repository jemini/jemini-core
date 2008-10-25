class Audible < Gemini::Behavior

  depends_on :Spatial
  declared_methods :add_sound, :emit_sound
  
  #Wrapper for org.newdawn.slick.Sound.
  class Sound < Java::org::newdawn::slick::Sound; end
  
  def load
    @sounds = {}
  end
  
  def add_sound(reference, path)
    @sounds[reference] = Sound.new(path)
  end
  
  def emit_sound(reference, x = @target.x, y = @target.y, volume = nil, pitch = nil)
    #@target.game_state.manager(:sound).get_sound(:sound_reference)
    @sounds[reference].play_at(x, y, 0)
  end
  
end