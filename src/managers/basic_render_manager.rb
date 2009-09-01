class BasicRenderManager < Jemini::GameObject
  include_class 'org.newdawn.slick.geom.Circle'

  def load
    enable_listeners_for :before_render, :after_render
    @image_cache = {}
    @debug_queue = []
  end
  
  #Render all game objects to the given graphics context.
  #Triggers :before_render, :after_render callbacks.
  def render(graphics)
    notify :before_render, graphics
    #game_state.manager(:game_object).game_objects.each { |game_object| game_object.draw if game_object.respond_to? :draw}
    game_state.manager(:game_object).layers_by_order.each do |game_objects|
      game_objects.each { |game_object| game_object.draw(graphics) if game_object.respond_to? :draw}
    end

    pre_debug_color = graphics.color
    until @debug_queue.empty?
      debug_render = @debug_queue.shift
      color = debug_render[:color]
      color = Color.new(color) unless color.kind_of? Color
      graphics.color = color.native_color
      case debug_render[:type]
      when :point
        graphics.fill Circle.new(debug_render[:position].x, debug_render[:position].y, 2)
      end
    end
    graphics.color = pre_debug_color
    notify :after_render, graphics
  end

  def debug(type, color, options)
    @debug_queue << {:type => type, :color => color}.merge(options)
  end
  
  #Load image for rapid retrieval via get_cached_image.
  def cache_image(cache_name, image_name)
    image_resource = Java::org::newdawn::slick::Image.new Resource.path_of(image_name)
    @image_cache[cache_name] = image_resource
  end
  
  #Retrieve cached image.
  def get_cached_image(cache_name)
    @image_cache[cache_name].copy
  end
end