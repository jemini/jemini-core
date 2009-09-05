Jemini::InputManager.define_keymap do |i|
  i.map KEY_RELEASED, :source_value => Input::KEY_F1, :destination_type => :toggle_debug_mode, :destination_value => nil
  i.map KEY_HELD, :source_value => Input::KEY_UP, :destination_type => :move, :destination_value => :up
  i.map KEY_HELD, :source_value => Input::KEY_DOWN, :destination_type => :move, :destination_value => :down
  i.map KEY_HELD, :source_value => Input::KEY_LEFT, :destination_type => :move, :destination_value => :left
  i.map KEY_HELD, :source_value => Input::KEY_RIGHT, :destination_type => :move, :destination_value => :right
end