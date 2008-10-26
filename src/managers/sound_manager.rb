class SoundManager < Gemini::GameObject

  #Wrapper for org.newdawn.slick.Sound.
  class Sound < Java::org::newdawn::slick::Sound; end
  
  def load
    @sounds = {}
  end
  
  def add_sound(reference, path)
    @sounds[reference] = Sound.new(path)
  end
  
  def play_sound(reference, volume = 1.0, pitch = 1.0)
    @sounds[reference].play(pitch, volume)
  end
  
  def stop_all
    @sounds.each_value {|s| s.stop if s.playing}
  end
  
end