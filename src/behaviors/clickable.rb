#Makes an object clickable with the mouse.
class Clickable < Jemini::Behavior
  depends_on :HandlesEvents
  depends_on :Regional
  wrap_with_callbacks :pressed, :released
  
  def load
    @game_object.handle_event :click do |mouse_event|
      released if @game_object.within_region? mouse_event.value.screen_position
    end
  end
  
  def pressed; end
  def released; end
end
