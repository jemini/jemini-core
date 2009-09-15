# players :all do is implicit
map :fire do
  key_held :x
  joystick_button_held :xbox_button_a
  joystick_button_held 12
end

map :quit do
  key_held :esc, :for => 3
end

map :adjust_angle do
  key_held :left, :value => ANGLE_RATE
  joystick_axis_update :xbox_left_stick_x do |message, raw_input|
    message.value = filter_dead_zone(0.2, message.value)
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


# new form

map :fire do
  hold :x
  hold :xbox_button_a
  hold :button => 12
end

map :switch_tab do
  press :alt_tab
end

map :jump do
  press :space
end

map :shoot do
  off  #until I'm done testing this
  press :left_mouse
end

map :select do
  press :left
  press :mouse => 1 # same as above
end

map :jump do
  charge :space, :max => 5, :release => 10 # charge up to 5 seconds worth of charge, but auto-release after 10 seconds
end