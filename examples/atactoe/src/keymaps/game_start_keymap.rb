Gemini::InputManager.define_keymap do |i|
  # i.map_key :released => Input::KEY_F1, :toggle_debug_mode => nil
  0.upto i.connected_joystick_size - 1 do |j|
    i.map_joystick :joystick_id => j, :held => XBOX_360_A, :start => nil
    i.map_joystick :joystick_id => j, :released => XBOX_360_DPAD_UP, :increase_target_score => nil
    i.map_joystick :joystick_id => j, :released => XBOX_360_DPAD_DOWN, :decrease_target_score => nil
    i.map_joystick :joystick_id => j, :held => XBOX_360_BACK, :quit => nil
  end
  i.map_key :pressed => Input::KEY_ESCAPE, :quit => nil
end