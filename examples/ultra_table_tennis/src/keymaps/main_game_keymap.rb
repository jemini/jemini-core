Gemini::InputManager.define_keymap do |i|
  i.map KEY_HELD, :source_value => Input::KEY_Q, :destination_type => :p1_paddle_movement, :destination_value => :up
  i.map KEY_HELD, :source_value => Input::KEY_A, :destination_type => :p1_paddle_movement, :destination_value => :down
  i.map KEY_HELD, :source_value => Input::KEY_O, :destination_type => :p2_paddle_movement, :destination_value => :up
  i.map KEY_HELD, :source_value => Input::KEY_L, :destination_type => :p2_paddle_movement, :destination_value => :down

  i.map KEY_RELEASED, :source_value => Input::KEY_ESCAPE, :destination_type => :quit, :destination_value => :quit
  i.map KEY_RELEASED, :source_value => Input::KEY_D, :destination_type => :toggle_debug_mode, :destination_value => nil
end