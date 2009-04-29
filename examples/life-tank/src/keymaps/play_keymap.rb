Gemini::InputManager.define_keymap do |i|
  i.map_key :released => Input::KEY_F1, :toggle_debug_mode => nil
  i.map_key :held => Input::KEY_UP, :move => :up
  i.map_key :released => Input::KEY_SPACE, :spawn_thing => nil
#  i.map_joystick :joystick_id => 0, :axis_update => 'x', :adjust_angle => nil do |message, raw_input|
#    message.value = i.filter_dead_zone(0.2, message.value)
#  end
#  i.map_joystick :joystick_id => 0, :axis_update => 'y', :adjust_power => nil do |message, raw_input|
#    # y is inverted
#    message.value = -i.filter_dead_zone(0.2, message.value)
#  end
end