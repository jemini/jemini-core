KEYBOARD_ANGLE_ADJUST_RATE = 1.0
KEYBOARD_POWER_ADJUST_RATE = 1.0

Gemini::InputManager.define_keymap do |i|
  i.map_key :pressed => Input::KEY_F1, :toggle_debug_mode => nil
  i.map_key :pressed => Input::KEY_ESCAPE, :quit => nil
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

  i.map_key :held => Input::KEY_Q, :move => -1, :player => 0
  i.map_key :held => Input::KEY_E, :move =>  1, :player => 0
  i.map_key :held => Input::KEY_COMMA, :move => -1, :player => 1
  i.map_key :held => Input::KEY_PERIOD, :move =>  1, :player => 1
  i.map_key :pressed  => Input::KEY_F, :charge_jump => nil, :player => 0
  i.map_key :released => Input::KEY_F, :jump => nil, :player => 0
  i.map_key :pressed  => Input::KEY_SLASH, :charge_jump => nil, :player => 1
  i.map_key :released => Input::KEY_SLASH, :jump => nil, :player => 1
  # KEY_TAB doesn't work unless alt+tab. Mac only?
  i.map_key :held => Input::KEY_LSHIFT, :fire => nil, :player => 0

  0.upto i.connected_joystick_size - 1 do |j|
    if Platform.using_osx?
      i.map_joystick :joystick_id => j, :axis_update => XBOX_360_LEFT_TRIGGER_AXIS, :move => nil, :player => j do |message, raw_input|
        message.value += 1.0
        message.value /= 2.0
        message.value = -i.filter_dead_zone(0.2, message.value)
        message.value = nil if message.value.zero?
      end

      i.map_joystick :joystick_id => j, :axis_update => XBOX_360_RIGHT_TRIGGER_AXIS, :move => nil, :player => j do |message, raw_input|
        message.value += 1.0
        message.value /= 2.0
        message.value = i.filter_dead_zone(0.2, message.value)
        message.value = nil if message.value.zero?
      end
    elsif Platform.using_windows?
      i.map_joystick :joystick_id => j, :axis_update => XBOX_360_TRIGGER_AXIS, :move => nil, :player => j do |message, raw_input|
        message.value = -i.filter_dead_zone(0.2, message.value)
      end
    end

    i.map_joystick :joystick_id => j, :axis_update => XBOX_360_LEFT_X_AXIS, :adjust_angle => nil, :player => j do |message, raw_input|
      message.value = i.filter_dead_zone(0.2, message.value)
    end

    i.map_joystick :joystick_id => j, :axis_update => XBOX_360_LEFT_Y_AXIS, :adjust_power => nil, :player => j do |message, raw_input|
      # y is inverted
      message.value = -i.filter_dead_zone(0.2, message.value)
    end
    i.map_joystick :joystick_id => j, :held => XBOX_360_A, :fire => nil, :player => j
    i.map_joystick :joystick_id => j, :pressed  => XBOX_360_B, :charge_jump => nil, :player => j
    i.map_joystick :joystick_id => j, :released => XBOX_360_B, :jump => nil, :player => j
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
