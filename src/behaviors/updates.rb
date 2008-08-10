class Updates < Gemini::Behavior
  declared_methods :update
  
  def load
    @target.enable_listeners_for :tick
  end
  
  def update(delta)
    notify :tick, delta
  end
end