class ResourceManager < Jemini::GameObject
  
  attr_accessor :data_directory
  
  def load
    @data_directory = "data"
    @images = {}
  end
  
  def load_resources
    Dir.open(data_directory).each do |file|
      next if file == '.' or file == '..'
      path = File.join(data_directory, file)
      next unless File.file?(path)
      log.debug "Processing file: #{path}"
      extension = File.extname(file)
      key = File.basename(file, extension).downcase.to_sym
      case extension
        when /(png|gif)/i then cache_image(key, path)
        when /(wav)/i then cache_sound(key, path)
        else STDERR.puts "Unknown type of file: #{path}"
      end
    end
  end
  
  def cache_image(key, path)
    log.debug "Caching image with key: #{key} and path: #{path}"
    log.warn "Duplicate image for #{key}" and return if @images[key]
    @images[key] = 1 #TODO: Java::org::newdawn::slick::Image.new(path)
  end
  def cache_sound(key, path)
    @sounds[key] = 1 #TODO: Sound
  end
  def get_image(key)
    @images[key] or raise "Could not find image: #{key}"
  end
  alias_method :image, :get_image
  def get_sound(key)
    @images[key] or raise "Could not find image: #{key}"
  end
  alias_method :sound, :get_sound
  
  
end
