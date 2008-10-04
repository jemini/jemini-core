class BasicRenderManager < Gemini::GameObject
  def load
    enable_listeners_for :before_render, :after_render
    @image_cache = {}
  end
  
  def render(graphics)
    notify :before_render, graphics
    #game_state.manager(:game_object).game_objects.each { |game_object| game_object.draw if game_object.respond_to? :draw}
    game_state.manager(:game_object).layers_by_order.each do |game_objects|
      game_objects.each { |game_object| game_object.draw(graphics) if game_object.respond_to? :draw}
    end
    notify :after_render, graphics
  end
  
  def cache_image(cache_name, image_name)
    @image_cache[cache_name] = Java::org::newdawn::slick::Image.new "data/#{image_name}"
  end
  
  def get_cached_image(cache_name)
    @image_cache[cache_name]
  end
end