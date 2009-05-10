KEYBOARD_ANGLE_ADJUST_RATE = 1.0
KEYBOARD_POWER_ADJUST_RATE = 1.0

Gemini::InputManager.define_keymap do |i|
  i.map_key :released => Input::KEY_F1, :toggle_debug_mode => nil
#  i.map_key :held => Input::KEY_UP, :move => :up
#  i.map_key :released => Input::KEY_SPACE, :spawn_thing => nil

  ########################################
  # Keys for player 1
  ########################################
  i.map_key :held => Input::KEY_A, :adjust_angle => nil do |message, raw_input|
    message.value = -KEYBOARD_ANGLE_ADJUST_RATE
    message.player = 0
  end

  i.map_key :held => Input::KEY_D, :adjust_angle => nil do |message, raw_input|
    message.value = KEYBOARD_ANGLE_ADJUST_RATE
    message.player = 0
  end

  i.map_key :held => Input::KEY_W, :adjust_power => nil do |message, raw_input|
    message.value = KEYBOARD_POWER_ADJUST_RATE
    message.player = 0
  end

  i.map_key :held => Input::KEY_S, :adjust_power => nil do |message, raw_input|
    message.value = -KEYBOARD_POWER_ADJUST_RATE
    message.player = 0
  end

  # KEY_TAB doesn't work unless alt+tab. Mac only?
  i.map_key :held => Input::KEY_LSHIFT, :fire => nil do |message, raw_input|
    message.player = 0
  end

  i.map_joystick :joystick_id => 0, :axis_update => 'x', :adjust_angle => nil do |message, raw_input|
    message.value = i.filter_dead_zone(0.2, message.value)
  end

  i.map_joystick :joystick_id => 0, :axis_update => 'y', :adjust_power => nil do |message, raw_input|
    # y is inverted
    message.value = -i.filter_dead_zone(0.2, message.value)
  end
  i.map_joystick :joystick_id => 0, :held => XBOX_360_A, :fire => nil

#  25.times do |button_number|
#    i.map_joystick :joystick_id => 0, :pressed => button_number, :fire => nil do |message, raw_input|
#      message.value = raw_input
#    end
#  end

  ########################################
  # Keys for player 2
  ########################################
  i.map_key :held => Input::KEY_LEFT, :adjust_angle => nil do |message, raw_input|
    message.value = -KEYBOARD_ANGLE_ADJUST_RATE
    message.player = 1
  end

  i.map_key :held => Input::KEY_RIGHT, :adjust_angle => nil do |message, raw_input|
    message.value = KEYBOARD_ANGLE_ADJUST_RATE
    message.player = 1
  end

  i.map_key :held => Input::KEY_UP, :adjust_power => nil do |message, raw_input|
    message.value = KEYBOARD_POWER_ADJUST_RATE
    message.player = 1
  end

  i.map_key :held => Input::KEY_DOWN, :adjust_power => nil do |message, raw_input|
    message.value = -KEYBOARD_POWER_ADJUST_RATE
    message.player = 1
  end

  # KEY_TAB doesn't work unless alt+tab. Mac only?
  i.map_key :held => Input::KEY_SPACE, :fire => nil do |message, raw_input|
    message.player = 1
  end
end