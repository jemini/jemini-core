Jemini::InputManager.define_keymap do |i|
  i.map MOUSE_BUTTON1_PRESSED, :destination_type => :mouse_button1_pressed do |raw_value, message|
    message.value = MouseEvent.new(MouseEvent::PRESSED, Vector.new(raw_value[1], raw_value[2]))
  end

  i.map MOUSE_BUTTON1_RELEASED, :destination_type => :mouse_button1_released do |raw_value, message|
    message.value = MouseEvent.new(MouseEvent::RELEASED, Vector.new(raw_value[1], raw_value[2]))
  end

  i.map MOUSE_MOVED, :destination_type => :mouse_move do |raw_value, message|
    message.value = MouseEvent.new(nil, Vector.new(raw_value[2], raw_value[3]))
  end


  i.map KEY_RELEASED, :source_value => Input::KEY_F1, :destination_type => :toggle_debug_mode, :destination_value => nil
  i.map KEY_RELEASED, :source_value => Input::KEY_P, :destination_type => :toggle_pretty_mode, :destination_value => nil
  i.map KEY_RELEASED, :source_value => Input::KEY_ESCAPE, :destination_type => :exit_to_menu, :destination_value => nil
end