players :all do
  map :fire do
    key_held :x
    joystick_button_held :xbox_button_a
    joystick_button_held 12
  end

  map :adjust_angle do
    key_held :left, :value => ANGLE_RATE
    joystick_axis_update :xbox_left_stick_x do |message, raw_input|
      message.value = filter_dead_zone(0.2, message.value)
    end
  end
end

player 1 do
  map :fire do
    key_held :space
  end
end

player :bob do
  map :fire do
    key_held :left_shift
  end
end