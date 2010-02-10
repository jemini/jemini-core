class ResourceManager < Jemini::GameObject
  java_import 'org.newdawn.slick.Image'
  java_import 'org.newdawn.slick.Music'
  java_import 'org.newdawn.slick.Sound'

  attr_accessor :base_path

  #Sets a default data directory path of "data".
  def load
    enable_listeners_for :resources_loaded
    @configs = {}
    @images = {}
    @sounds = {}
    @songs = {}
    @base_path ||= choose_base_path
  end
  
  #Load resources for the given state.
  #Uses the current state if none specified.
  def load_resources(state_name = game_state.name)
    subdirectory = File.join(@base_path, state_name)
    [subdirectory, @base_path].each do |directory|
      begin
        load_directory(directory)
      rescue Errno::ENOENT
        log.debug "#{directory} not found"
      end
    end
    notify :resources_loaded
  end
  
  #Load the config at the given path, and make it accessible via the given key.
  def cache_config(key, path)
    log.debug "Caching config for #{key} with path: #{path}"
    log.warn "Skipping duplicate config for #{key} with path: #{path}" and return if @configs[key]
    @configs[key] = File.read(path)
  end
  
  #Load the image at the given path, and make it accessible via the given key.
  def cache_image(key, path)
    log.debug "Caching image for #{key} with path: #{path}"
    log.warn "Skipping duplicate image for #{key} with path: #{path}" and return if @images[key]
    @images[key] = Image.new(strip_jar_path(path))
  end
  
  #Load the sound at the given path, and make it accessible via the given key.
  def cache_sound(key, path)
    log.debug "Caching sound for #{key} with path: #{path}"
    log.warn "Skipping duplicate sound for #{key} with path: #{path}" and return if @sounds[key]
    @sounds[key] = Sound.new(strip_jar_path(path))
  end
  
  #Load the song at the given path, and make it accessible via the given key.
  def cache_song(key, path)
    log.debug "Caching song for #{key} with path: #{path}"
    log.warn "Skipping duplicate song for #{key} with path: #{path}" and return if @songs[key]
    @songs[key] = Music.new(strip_jar_path(path))
  end
  
  #Get a config stored previously with cache_config.
  def get_config(key)
    @configs[key] or raise "Could not find config: #{key} - cached configs: #{@configs.keys}"
  end
  alias_method :config, :get_config
  
  #Get all configs stored previously with cache_config.
  def get_all_configs
    @configs.values
  end
  alias_method :configs, :get_all_configs

  #Get keys for all configurations stored previously with cache_config.
  def config_names
    @configs.keys
  end
    
  #Get an image stored previously with cache_image.
  def get_image(key)
    @images[key] or raise "Could not find image: #{key} - cached images: #{@images.keys}"
  end
  alias_method :image, :get_image
  
  #Get all images stored previously with cache_image.
  def get_all_images
    @images.values
  end
  alias_method :images, :get_all_images

  #Get keys for all images stored previously with cache_config.
  def image_names
    @images.keys
  end

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
      resources_for(directory).each do |file|
        next if file =~ /^\./
        log.debug "directory: #{directory} file: #{file}"
        load_file(File.join(directory, file))
      end
    end

    def load_file(file)
      extension = File.extname(file)
      key = File.basename(file, extension).downcase.to_sym
      log.debug "Extension: #{extension}"
      case extension.downcase
      when '.png', '.gif'
        cache_image(key, file)
      when '.wav'
        cache_sound(key, file)
      when '.ogg'
        cache_song(key, file)
      when '.ini'
        cache_config(key, file)
      else
        log.warn "Skipping unknown file: #{file}"
      end
    end

    def resources_for(directory)
      log.debug("resources_for(#{directory})")
      if directory =~ /^(?:file\:)?(.*data\.jar)\!(.*)/
        #Example: "/mygame/data.jar!/data/mystate/foo.png" - we need "data/mystate/" and "foo.png"
        jar_path = $1
        jarred_directory = $2.sub(/^[\\\/]/, '')
        jar = java.util.jar.JarFile.new(jar_path)
        jarred_directory_regex = Regexp.new("^#{jarred_directory}")
        resources = jar.entries.map{|f| f.name} #Gives us all resources in jar.
        resources = resources.select{|f| f =~ jarred_directory_regex} #Keep only entries under desired directory.
        resources = resources.reject{|f| f =~ /#{jarred_directory}[\\\/](.*)[\\\/]/} #Discard entries in subdirectories of desired directory.
        return resources.map{|f| File.basename(f)}
      else
        return Dir.open(directory)
      end
    end
    
    def choose_base_path
      #If running from jar, use data jar.
      if $0 =~ /(\.jar!)|(^-$)/
        File.expand_path(File.join(File.dirname(__FILE__), '..', '..', '..', '..', 'data.jar!', 'data'))
      #Otherwise use data directory.
      else
        'data'
      end
    end
    
    #If given path is within a jar, return only the path within the jar.
    #Example: "/mygame/data.jar!/data/mystate/foo.png" - we need "data/mystate/foo.png"
    def strip_jar_path(path)
      if path =~ /\bdata\.jar\![\\\/](.*)$/
        return $1
      else
        return path
      end
    end

end
