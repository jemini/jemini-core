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
  
  def add_sound(reference, path)
    @sounds[reference] = load_sound path
  end
  
  def play_sound(reference, volume = 1.0, pitch = 1.0)
    @sounds[reference].play(pitch, volume)
  end
  
  def stop_all
    @sounds.each_value {|s| s.stop if s.playing}
  end
  
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
  
  def play_song(music_file_name)
    @music.stop if @music
    begin
      @music = Java::org::newdawn::slick::Music.new("data/#{music_file_name}", true)
      @music.play
    rescue java.lang.RuntimeException
      @music = Java::org::newdawn::slick::Music.new("../data/#{music_file_name}", true)
      @music.play
    end
  end
private

  def load_sound(sound_file_name)
    begin
      Sound.new("data/#{sound_file_name}")
    rescue #java.lang.RuntimeException
      Sound.new("../data/#{sound_file_name}")
    end
  end
end