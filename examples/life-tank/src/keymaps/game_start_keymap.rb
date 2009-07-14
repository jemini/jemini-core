Gemini::InputManager.define_keymap do |i|
  i.map_key :released => Input::KEY_F1, :toggle_debug_mode => nil
  i.map_key :pressed => Input::KEY_1, :start => nil
  i.map_joystick :held => XBOX_360_A, :start => nil
  i.map_joystick :pressed => XBOX_360_RIGHT_BUMPER, :increase_player_count => nil
  i.map_joystick :pressed => XBOX_360_LEFT_BUMPER,  :decrease_player_count => nil
  i.map_key :pressed => Input::KEY_UP, :increase_player_count => nil
  i.map_key :pressed => Input::KEY_DOWN, :decrease_player_count => nil
  i.map_key :pressed => Input::KEY_ESCAPE, :quit => nil
end