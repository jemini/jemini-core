class ResourceManager < Jemini::GameObject
  
  attr_accessor :data_directory
  
  #Sets a default data directory path of "data".
  def load
    @data_directory = "data"
    @images = {}
    @sounds = {}
    @songs = {}
  end
  
  #Load resources for the given state.
  #Uses the current state if none specified.
  def load_resources(state_name = nil)
    state_name ||= self.game_state.class.name
    log.debug "Loading state: #{state_name}"
    if match = /\/?(\w+?)_state$/.match(state_name.underscore)
      subdirectory = File.join(data_directory, match[1])
      log.debug "Looking for subdirectory: #{subdirectory}"
      load_directory(subdirectory) if File.directory?(subdirectory)
    end
    load_directory(data_directory)
  end
  
  #Load the image at the given path, and make it accessible via the given key.
  def cache_image(key, path)
    log.debug "Caching image for #{key} with path: #{path}"
    log.warn "Skipping duplicate image for #{key} with path: #{path}" and return if @images[key]
    @images[key] = Java::org::newdawn::slick::Image.new(path)
  end
  
  #Load the sound at the given path, and make it accessible via the given key.
  def cache_sound(key, path)
    log.debug "Caching sound for #{key} with path: #{path}"
    log.warn "Skipping duplicate sound for #{key} with path: #{path}" and return if @sounds[key]
    @sounds[key] = Java::org::newdawn::slick::Sound.new(path)
  end
  
  #Load the song at the given path, and make it accessible via the given key.
  def cache_song(key, path)
    log.debug "Caching song for #{key} with path: #{path}"
    log.warn "Skipping duplicate song for #{key} with path: #{path}" and return if @songs[key]
    @songs[key] = Java::org::newdawn::slick::Music.new(path)
  end
  
  #Get an image stored previously with cache_image.
  def get_image(key)
    @images[key] or raise "Could not find image: #{key}"
  end
  alias_method :image, :get_image
  
  #Get all images stored previously with cache_image.
  def get_all_images
    @images.values
  end
  alias_method :images, :get_all_images

  #Get a sound stored previously with cache_sound.
  def get_sound(key)
    @sounds[key] or raise "Could not find sound: #{key}"
  end
  alias_method :sound, :get_sound
  
  #Get all sounds stored previously with cache_sound.
  def get_all_sounds
    @sounds.values
  end
  alias_method :sounds, :get_all_sounds
  
  #Get a song stored previously with cache_song.
  def get_song(key)
    @songs[key] or raise "Could not find song: #{key}"
  end
  alias_method :song, :get_song
  
  #Get all songs stored previously with cache_song.
  def get_all_songs
    @songs.values
  end
  alias_method :songs, :get_all_songs

  private
  
    def load_directory(directory)
      log.debug "Loading contents of #{directory}"
      Dir.open(directory).each do |file|
        next if file =~ /^\./
        path = File.join(directory, file)
        next unless File.file?(path)
        log.debug "Processing file: #{path}"
        extension = File.extname(file)
        key = File.basename(file, extension).downcase.to_sym
        case extension
          when /(png|gif)/i then cache_image(key, path)
          when /(wav)/i then cache_sound(key, path)
          when /(ogg)/i then cache_song(key, path)
          else log.warn "Skipping unknown file: #{path}"
        end
      end
    end

    
  
end
