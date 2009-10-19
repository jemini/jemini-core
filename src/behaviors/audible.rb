#Makes an object emit sounds.
class Audible < Jemini::Behavior
  
  #Load a sound file and assign a reference to it, which can later be passed to emit_sound.
  def load_sound(reference, path)
    game_state.manager(:sound).add_sound(reference, path)
  end

  #Plays a sound whose reference was assigned via load_sound.
  #Pass in volume to play it back quieter or louder (1.0 is normal).
  #Pass in pitch for a higher or lower tone (1.0 is normal).
  def emit_sound(reference, volume = 1.0, pitch = 1.0)
    game_state.manager(:sound).play_sound(reference, volume, pitch)
  end
  
end