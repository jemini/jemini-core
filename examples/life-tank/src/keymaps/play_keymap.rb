KEYBOARD_ANGLE_ADJUST_RATE = 1.0
KEYBOARD_POWER_ADJUST_RATE = 1.0

Gemini::InputManager.define_keymap do |i|
  i.map_key :released => Input::KEY_F1, :toggle_debug_mode => nil
#  i.map_key :held => Input::KEY_UP, :move => :up
#  i.map_key :released => Input::KEY_SPACE, :spawn_thing => nil

  ########################################
  # Keys for player 1
  ########################################
  i.map_key :held => Input::KEY_A, :adjust_angle => nil, :player => 0 do |message, raw_input|
    message.value = -KEYBOARD_ANGLE_ADJUST_RATE
  end

  i.map_key :held => Input::KEY_D, :adjust_angle => nil, :player => 0 do |message, raw_input|
    message.value = KEYBOARD_ANGLE_ADJUST_RATE
  end

  i.map_key :held => Input::KEY_W, :adjust_power => nil, :player => 0 do |message, raw_input|
    message.value = KEYBOARD_POWER_ADJUST_RATE
  end

  i.map_key :held => Input::KEY_S, :adjust_power => nil, :player => 0 do |message, raw_input|
    message.value = -KEYBOARD_POWER_ADJUST_RATE
  end

  # KEY_TAB doesn't work unless alt+tab. Mac only?
  i.map_key :held => Input::KEY_LSHIFT, :fire => nil, :player => 0

  0.upto i.connected_controller_size - 1 do |j|
    i.map_joystick :joystick_id => j, :axis_update => 'x', :adjust_angle => nil, :player => j do |message, raw_input|
      message.value = i.filter_dead_zone(0.2, message.value)
    end

    i.map_joystick :joystick_id => j, :axis_update => 'y', :adjust_power => nil, :player => j do |message, raw_input|
      # y is inverted
      message.value = -i.filter_dead_zone(0.2, message.value)
    end
    i.map_joystick :joystick_id => j, :held => XBOX_360_A, :fire => nil, :player => j
  end
#  25.times do |button_number|
#    i.map_joystick :joystick_id => 0, :pressed => button_number, :fire => nil do |message, raw_input|
#      message.value = raw_input
#    end
#  end

  ########################################
  # Keys for player 2
  ########################################
  i.map_key :held => Input::KEY_LEFT, :adjust_angle => nil, :player => 1 do |message, raw_input|
    message.value = -KEYBOARD_ANGLE_ADJUST_RATE
  end

  i.map_key :held => Input::KEY_RIGHT, :adjust_angle => nil, :player => 1 do |message, raw_input|
    message.value = KEYBOARD_ANGLE_ADJUST_RATE
  end

  i.map_key :held => Input::KEY_UP, :adjust_power => nil, :player => 1 do |message, raw_input|
    message.value = KEYBOARD_POWER_ADJUST_RATE
  end

  i.map_key :held => Input::KEY_DOWN, :adjust_power => nil, :player => 1 do |message, raw_input|
    message.value = -KEYBOARD_POWER_ADJUST_RATE
  end

  # KEY_TAB doesn't work unless alt+tab. Mac only?
  i.map_key :held => Input::KEY_SPACE, :fire => nil, :player => 1
end
