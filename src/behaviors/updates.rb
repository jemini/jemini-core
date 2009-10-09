#Makes an object receive events for changes in state.
class Updates < Jemini::Behavior
  listen_for :update
  
  def update(delta)
    @game_object.notify :update, delta
  end
end