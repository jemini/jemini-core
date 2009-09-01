#Makes an object receive events for changes in state.
class Updates < Jemini::Behavior
  listen_for :update
  
  def update(delta)
    @target.notify :update, delta
  end
end