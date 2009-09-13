class SoundManager < Jemini::GameObject
  #TODO: Raise errors if sounds/music loaded/used when not on the proper thread?
  #TODO: We can't play oggs as sounds in Windows/Linux. We get an Open AL error: 40963
  #Wrapper for org.newdawn.slick.Sound.
  class Sound < Java::org::newdawn::slick::Sound; end
  class Music < Java::org::newdawn::slick::Music; end
  
  def load
    @sounds = {}
  end
  
  def unload
    @music.stop if @music
    stop_all
  end
  
  #Make a sound accessible via the given reference.
  #The sound argument is either the sound to store, or the name of a sound file to load from the data directory.
  def add_sound(reference, sound)
    @sounds[reference] = case sound
      when String then load_sound(sound)
      else sound
    end
  end
  
  #Takes a sound reference (set via add_sound) and plays it.
  def play_sound(reference, volume = 1.0, pitch = 1.0)
    @sounds[reference].play(pitch, volume)
  end
  
  #Stop playback of all sounds.
  def stop_all
    @sounds.each_value {|s| s.stop if s.playing}
  end
  
  
  #Plays the given music.
  #The music argument is either the music object to play, or the name of a music file to load from the data directory.
  #Stops any previously playing song.
  #Takes a hash with the following keys and values:
  #[:volume] The playback volume.
  #[:loop] If true, will restart playback when the song ends.
  def play_song(music, options={})
    @music.stop if @music
    @music = case music
      when String then Java::org::newdawn::slick::Music.new(Resource.path_of(music), true)
      else music
    end
    if options[:loop]
      @music.loop
    else
      @music.play
    end
    @music.volume = options[:volume] if options.has_key? :volume #Volume must be set AFTER loop is called.
  end
  
private

  def load_sound(sound_file_name)
    Sound.new(Resource.path_of(sound_file_name))
  end
end