class BasicUpdateManager < Gemini::GameObject
  def load(state)
    @state = state
    enable_listeners_for :before_update, :after_update
  end
  
  def update(delta)
    return if paused?
    
    notify :before_update
    state.manager(:game_object).game_objects.each { |game_object| game_object.update(delta) if game_object.respond_to? :update}
    notify :after_update
  end
  
  def pause
    @paused = true
  end

  def resume
    @paused = false
  end

  def paused?
    @paused
  end
end