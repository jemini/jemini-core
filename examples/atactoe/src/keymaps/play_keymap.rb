# KEYBOARD_ANGLE_ADJUST_RATE = 1.0
# KEYBOARD_POWER_ADJUST_RATE = 1.0

UP_VALUE = 1
DOWN_VALUE = -1
LEFT_VALUE = -1
RIGHT_VALUE = 1

Gemini::InputManager.define_keymap do |i|
  # i.map_key :pressed => Input::KEY_F1, :toggle_debug_mode => nil
  i.map_key :pressed => Input::KEY_ESCAPE, :quit => nil

  0.upto i.connected_joystick_size - 1 do |j|

    i.map_joystick :joystick_id => j, :released => XBOX_360_A, :draw => nil, :player => j do |message, raw_input|
      puts message.inspect
      puts raw_input.inspect
    end
    i.map_key :held => Input::XBOX_360_DPAD_UP, :move_cursor => :up, :player => j do |message, raw_input|
      message.value = UP_VALUE
    end
    i.map_key :held => Input::XBOX_360_DPAD_DOWN, :move_cursor => :down, :player => j do |message, raw_input|
      message.value = DOWN_VALUE
    end
    i.map_key :held => Input::XBOX_360_DPAD_LEFT, :move_cursor => :left, :player => j do |message, raw_input|
      message.value = LEFT_VALUE
    end
    i.map_key :held => Input::XBOX_360_DPAD_RIGHT, :move_cursor => :right, :player => j do |message, raw_input|
      message.value = RIGHT_VALUE
    end
    # i.map_joystick :joystick_id => j, :axis_update => XBOX_360_LEFT_X_AXIS, :adjust_angle => nil, :player => j do |message, raw_input|
    #   message.value = i.filter_dead_zone(0.2, message.value)
    # end
    # i.map_joystick :joystick_id => j, :axis_update => XBOX_360_LEFT_Y_AXIS, :adjust_power => nil, :player => j do |message, raw_input|
    #   # y is inverted
    #   message.value = -i.filter_dead_zone(0.2, message.value)
    # end
  end

  # ########################################
  # # Keys for player 1
  # ########################################
  # i.map_key :held => Input::KEY_A, :adjust_angle => nil, :player => 0 do |message, raw_input|
  #   message.value = -KEYBOARD_ANGLE_ADJUST_RATE
  # end
  # 
  # i.map_key :held => Input::KEY_D, :adjust_angle => nil, :player => 0 do |message, raw_input|
  #   message.value = KEYBOARD_ANGLE_ADJUST_RATE
  # end
  # 
  # i.map_key :held => Input::KEY_W, :adjust_power => nil, :player => 0 do |message, raw_input|
  #   message.value = KEYBOARD_POWER_ADJUST_RATE
  # end
  # 
  # i.map_key :held => Input::KEY_S, :adjust_power => nil, :player => 0 do |message, raw_input|
  #   message.value = -KEYBOARD_POWER_ADJUST_RATE
  # end
  # 
  # i.map_key :held => Input::KEY_LSHIFT, :fire => nil, :player => 0
  # 
  # ########################################
  # # Keys for player 2
  # ########################################
  # i.map_key :held => Input::KEY_LEFT, :adjust_angle => nil, :player => 1 do |message, raw_input|
  #   message.value = -KEYBOARD_ANGLE_ADJUST_RATE
  # end
  # 
  # i.map_key :held => Input::KEY_RIGHT, :adjust_angle => nil, :player => 1 do |message, raw_input|
  #   message.value = KEYBOARD_ANGLE_ADJUST_RATE
  # end
  # 
  # i.map_key :held => Input::KEY_UP, :adjust_power => nil, :player => 1 do |message, raw_input|
  #   message.value = KEYBOARD_POWER_ADJUST_RATE
  # end
  # 
  # i.map_key :held => Input::KEY_DOWN, :adjust_power => nil, :player => 1 do |message, raw_input|
  #   message.value = -KEYBOARD_POWER_ADJUST_RATE
  # end
  # 
  # i.map_key :held => Input::KEY_SPACE, :fire => nil, :player => 1


end
