# wraps the Music class on Slick to a module that can be included anywhere
module Music
  # TODO: Support URLs
  @@music = nil
  
  def loop_song(music_file_name)
    @@music.stop if @@music
    @@music = Java::org::newdawn::slick::Music.new(music_file_name)
    @@music.loop
    # do we want to store the music for later?
    
  end
  
end