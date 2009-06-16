class Updates < Gemini::Behavior
  
  def load
    @target.enable_listeners_for :update
  end
  
  def update(delta)
    @target.notify :update, delta
  end
end