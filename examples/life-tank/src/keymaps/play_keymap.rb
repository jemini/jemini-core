Gemini::InputManager.define_keymap do |i|
  i.map_key :released => Input::KEY_F1, :toggle_debug_mode => nil
  i.map_key :held => Input::KEY_UP, :move => :up
  i.map_key :released => Input::KEY_SPACE, :spawn_thing => nil
  i.map_key :held => Input::KEY_F1, :destination_type => :toggle_debug_mode, :destination_value => nil
  i.map_key :held => Input::KEY_UP, :destination_type => :move, :destination_value => :up
  i.map_key :held => Input::KEY_DOWN, :destination_type => :move, :destination_value => :down
  i.map_key :held => Input::KEY_LEFT, :destination_type => :move, :destination_value => :left
  i.map_key :held => Input::KEY_RIGHT, :destination_type => :move, :destination_value => :right
  i.map_key :released => Input::KEY_SPACE, :destination_type => :spawn_thing, :destination_value => nil
  # i.map_joystick :joystick_id => 0, :axis_update => 'x', :adjust_angle => nil do |message, raw_input|
    # message.value = i.filter_dead_zone(0.2, message.value)
  # end
  # i.map_joystick :joystick_id => 0, :axis_update => 'y' do |data, message|
    # 'foo'
  # end
#  i.map :controller, :axis_update, :id => 0, :source_value => 'x', :destination_type => :adjust_angle do |data, message|
#    message.value = JoystickEvent.new(nil, Vector.new(data[2], data[3]))
#  end
end

#i.map_key :held => Input::KEY_F1, :move => :up
