class SoundManager < Gemini::GameObject
  #TODO: Raise errors if sounds/music loaded/used when not on the proper thread?
  #TODO: We can't play oggs as sounds in Windows/Linux. We get an Open AL error: 40963
  #Wrapper for org.newdawn.slick.Sound.
  class Sound < Java::org::newdawn::slick::Sound; end
  
  def load
    @sounds = {}
  end
  
  def unload
    @music.stop if @music
    stop_all
  end
  
  #Load a sound from the given file name in the sounds folder, and make it accessible via the given reference.
  def add_sound(reference, path)
    @sounds[reference] = load_sound path
  end
  
  #Takes a sound reference (set via add_sound) and plays it.
  def play_sound(reference, volume = 1.0, pitch = 1.0)
    @sounds[reference].play(pitch, volume)
  end
  
  #Stop playback of all sounds.
  def stop_all
    @sounds.each_value {|s| s.stop if s.playing}
  end
  
  #Loads the given file name from the data directory and plays it in a loop.
  #Stops any previously playing song.
  #Takes a hash with the following keys and values:
  #[:volume] The playback volume.
  def loop_song(music_file_name, options={})
    @music.stop if @music
    begin
      @music = Java::org::newdawn::slick::Music.new("data/#{music_file_name}", true)
      @music.loop
    rescue java.lang.RuntimeException
      @music = Java::org::newdawn::slick::Music.new("../data/#{music_file_name}", true)
      @music.loop
    end
    # volume MUST be set after loop is called
    @music.volume = options[:volume] if options.has_key? :volume
  end
  
  #Loads the given file name from the data directory and plays it.
  #Stops any previously playing song.
  def play_song(music_file_name)
    @music.stop if @music
    @music = Java::org::newdawn::slick::Music.new(Resource.path_of(music_file_name), true)
    @music.play
  end
private

  def load_sound(sound_file_name)
    Sound.new(Resource.path_of(sound_file_name))
  end
end