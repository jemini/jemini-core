#Makes an object clickable with the mouse.
class Clickable < Jemini::Behavior
  depends_on :HandlesEvents
  depends_on :Regional
  wrap_with_callbacks :pressed, :released
  
  def load
    @game_object.handle_event :mouse_button1_pressed do |mouse_event|
      pressed if @game_object.within_region? mouse_event.value.location
    end
    
    @game_object.handle_event :mouse_button1_released do |mouse_event|
      released if @game_object.within_region? mouse_event.value.location
    end
  end
  
  def pressed; end
  def released; end
end
