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
    stop_all
  end
  
  #Takes a reference to a sound loaded via the resource manager, and plays it.
  #volume is 0.0 for silence, 1.0 for normal volume, or higher values for amplified volume.
  #pitch is 1.0 for original pitch. Lower or higher values will bend the pitch accordingly.
  def play_sound(reference, volume = 1.0, pitch = 1.0)
    game_state.manager(:resource).get_sound(reference).play(pitch, volume)
  end
  
  #Stop playback of all sounds.
  def stop_all
    @song.stop if @song
    game_state.manager(:resource).get_all_sounds.each {|s| s.stop if s.playing}
  end
  
  #Takes a reference to a song loaded via the resource manager, and plays it.
  #volume is 0.0 for silence, 1.0 for normal volume, or higher values for amplified volume.
  def play_song(reference, volume=1.0)
    @song.stop if @song
    @song = game_state.manager(:resource).get_song(reference)
    @song.play
    @song.volume = volume if volume != 1.0 #Volume must be set AFTER play is called.
  end
  
  #Takes a reference to a song loaded via the resource manager, and plays it in a loop.
  #volume is 0.0 for silence, 1.0 for normal volume, or higher values for amplified volume.
  def loop_song(reference, volume=1.0)
    @song.stop if @song
    @song = game_state.manager(:resource).get_song(reference)
    @song.loop
    @song.volume = volume if volume != 1.0 #Volume must be set AFTER loop is called.
  end
    
end