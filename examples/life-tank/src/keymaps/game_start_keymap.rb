Gemini::InputManager.define_keymap do |i|
  i.map_key :released => Input::KEY_F1, :toggle_debug_mode => nil
  i.map_key :pressed => Input::KEY_1, :start => nil
  i.map_key :pressed => Input::KEY_ESCAPE, :quit => nil
end