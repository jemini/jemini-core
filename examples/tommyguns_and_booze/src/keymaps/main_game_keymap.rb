Gemini::InputManager.define_keymap do |i|
  #map KEY_HELD, :source_value => Input::KEY_W,  :destination_type => :move, :destination_value => :up
  #map KEY_HELD, :source_value => Input::KEY_S, :destination_type => :move, :destination_value => :down
  #map KEY_HELD, :source_value => Input::KEY_A,  :destination_type => :move, :destination_value => :left
  #map KEY_HELD, :source_value => Input::KEY_D, :destination_type => :move, :destination_value => :right

  i.map KEY_PRESSED, :source_value => Input::KEY_W, :destination_type => :start_move, :destination_value => :up
  i.map KEY_PRESSED, :source_value => Input::KEY_S, :destination_type => :start_move, :destination_value => :down
  i.map KEY_PRESSED, :source_value => Input::KEY_A, :destination_type => :start_move, :destination_value => :left
  i.map KEY_PRESSED, :source_value => Input::KEY_D, :destination_type => :start_move, :destination_value => :right

  i.map KEY_RELEASED, :source_value => Input::KEY_W, :destination_type => :stop_move, :destination_value => :up
  i.map KEY_RELEASED, :source_value => Input::KEY_S, :destination_type => :stop_move, :destination_value => :down
  i.map KEY_RELEASED, :source_value => Input::KEY_A, :destination_type => :stop_move, :destination_value => :left
  i.map KEY_RELEASED, :source_value => Input::KEY_D, :destination_type => :stop_move, :destination_value => :right

  i.map KEY_RELEASED, :source_value => Input::KEY_ESCAPE, :destination_type => :quit, :destination_value => :quit
  i.map KEY_RELEASED, :source_value => Input::KEY_F1, :destination_type => :toggle_debug_mode, :destination_value => nil
end