class ResourceManager < Jemini::GameObject
  
  attr_accessor :data_directory
  
  def load
    @data_directory = "data"
    @images = {}
    @sounds = {}
  end
  
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
  
  def cache_image(key, path)
    log.debug "Caching image for #{key} with path: #{path}"
    log.warn "Skipping duplicate image for #{key} with path: #{path}" and return if @images[key]
    @images[key] = Java::org::newdawn::slick::Image.new(path)
  end
  
  def cache_sound(key, path)
    log.debug "Caching sound for #{key} with path: #{path}"
    log.warn "Skipping duplicate sound for #{key} with path: #{path}" and return if @images[key]
    @sounds[key] = Java::org::newdawn::slick::Sound.new(path)
  end
  
  def get_image(key)
    @images[key] or raise "Could not find image: #{key}"
  end
  alias_method :image, :get_image
  
  def get_sound(key)
    @images[key] or raise "Could not find image: #{key}"
  end
  alias_method :sound, :get_sound
  
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
          else log.warn "Skipping unknown file: #{path}"
        end
      end
    end

    
  
end
