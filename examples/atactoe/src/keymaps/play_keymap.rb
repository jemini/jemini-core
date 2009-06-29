Gemini::InputManager.define_keymap do |i|

  i.map_key :pressed => Input::KEY_ESCAPE, :quit => nil

  0.upto i.connected_joystick_size - 1 do |j|
    i.map_joystick :joystick_id => j, :released => XBOX_360_A, :draw_mark => nil, :player => j
    i.map_joystick :joystick_id => j, :held => XBOX_360_DPAD_UP, :change_y => nil, :player => j do |message, raw_input|
      message.value = -1
    end
    i.map_joystick :joystick_id => j, :released => XBOX_360_DPAD_UP, :change_y => nil, :player => j do |message, raw_input|
      message.value = 0
    end
    i.map_joystick :joystick_id => j, :held => XBOX_360_DPAD_DOWN, :change_y => nil, :player => j do |message, raw_input|
      message.value = 1
    end
    i.map_joystick :joystick_id => j, :released => XBOX_360_DPAD_DOWN, :change_y => nil, :player => j do |message, raw_input|
      message.value = 0
    end
    i.map_joystick :joystick_id => j, :held => XBOX_360_DPAD_LEFT, :change_x => nil, :player => j do |message, raw_input|
      message.value = -1
    end
    i.map_joystick :joystick_id => j, :released => XBOX_360_DPAD_LEFT, :change_x => nil, :player => j do |message, raw_input|
      message.value = 0
    end
    i.map_joystick :joystick_id => j, :held => XBOX_360_DPAD_RIGHT, :change_x => nil, :player => j do |message, raw_input|
      message.value = 1
    end
    i.map_joystick :joystick_id => j, :released => XBOX_360_DPAD_RIGHT, :change_x => nil, :player => j do |message, raw_input|
      message.value = 0
    end
    i.map_joystick :joystick_id => j, :released => XBOX_360_BACK, :quit => nil, :player => j
  end

  # ########################################
  # # Keys for player 1
  # ########################################
  i.map_key :pressed => Input::KEY_LSHIFT, :draw_mark => nil, :player => 0
  i.map_key :held => Input::KEY_W, :change_y => nil, :player => 0 do |message, raw_input|
    message.value = -1
  end
  i.map_key :released => Input::KEY_W, :change_y => nil, :player => 0 do |message, raw_input|
    message.value = 0
  end
  i.map_key :held => Input::KEY_S, :change_y => nil, :player => 0 do |message, raw_input|
    message.value = 1
  end
  i.map_key :released => Input::KEY_S, :change_y => nil, :player => 0 do |message, raw_input|
    message.value = 0
  end
  i.map_key :held => Input::KEY_A, :change_x => nil, :player => 0 do |message, raw_input|
    message.value = -1
  end
  i.map_key :released => Input::KEY_A, :change_x => nil, :player => 0 do |message, raw_input|
    message.value = 0
  end
  i.map_key :held => Input::KEY_D, :change_x => nil, :player => 0 do |message, raw_input|
    message.value = 1
  end
  i.map_key :released => Input::KEY_D, :change_x => nil, :player => 0 do |message, raw_input|
    message.value = 0
  end

  # ########################################
  # # Keys for player 2
  # ########################################
  i.map_key :pressed => Input::KEY_SPACE, :draw_mark => nil, :player => 1
  i.map_key :held => Input::KEY_I, :change_y => nil, :player => 1 do |message, raw_input|
    message.value = -1
  end
  i.map_key :released => Input::KEY_I, :change_y => nil, :player => 1 do |message, raw_input|
    message.value = 0
  end
  i.map_key :held => Input::KEY_K, :change_y => nil, :player => 1 do |message, raw_input|
    message.value = 1
  end
  i.map_key :released => Input::KEY_K, :change_y => nil, :player => 1 do |message, raw_input|
    message.value = 0
  end
  i.map_key :held => Input::KEY_J, :change_x => nil, :player => 1 do |message, raw_input|
    message.value = -1
  end
  i.map_key :released => Input::KEY_J, :change_x => nil, :player => 1 do |message, raw_input|
    message.value = 0
  end
  i.map_key :held => Input::KEY_L, :change_x => nil, :player => 1 do |message, raw_input|
    message.value = 1
  end
  i.map_key :released => Input::KEY_L, :change_x => nil, :player => 1 do |message, raw_input|
    message.value = 0
  end


end
