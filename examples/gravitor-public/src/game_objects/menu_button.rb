class MenuButton < Jemini::GameObject
  has_behavior :Clickable
  has_behavior :Sprite
  
  def load(image_name, text, x, y)
    set_image image_name
    set_dimensions image_size
    set_text text
    on_after_move do
      @text.move(self.x, self.y)
    end
    move(x,y)
  end
  
  def unload
    game_state.remove_game_object @text
  end
  
  def text=(text)
    @text ||= game_state.create_game_object_on_layer(:Text, :gui_text)
    # third time is the charm
    @text.text = text
  end
  alias_method :set_text, :text=
end