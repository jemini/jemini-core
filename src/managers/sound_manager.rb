class SoundManager < Gemini::GameObject

  #Wrapper for org.newdawn.slick.Sound.
  class Sound < Java::org::newdawn::slick::Sound; end
  
  def load
    @sounds = {}
  end
  
  def unload
    @music.stop if @music
    stop_all
  end
  
  def add_sound(reference, path)
    @sounds[reference] = Sound.new("data/#{path}")
  end
  
  def play_sound(reference, volume = 1.0, pitch = 1.0)
    @sounds[reference].play(pitch, volume)
  end
  
  def stop_all
    @sounds.each_value {|s| s.stop if s.playing}
  end
  
  def loop_song(music_file_name)
    @music.stop if @music
    @music = Java::org::newdawn::slick::Music.new("data/#{music_file_name}")
    @music.loop
  end
  
  def play_song(music_file_name)
    @music.stop if @music
    @music = Java::org::newdawn::slick::Music.new("data/#{music_file_name}")
    @music.play
  end
end