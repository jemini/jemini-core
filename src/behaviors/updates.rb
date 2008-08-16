class Updates < Gemini::Behavior
  declared_methods :update
  
  def load
    @target.enable_listeners_for :update
  end
  
  def update(delta)
    notify :update, delta
  end
end