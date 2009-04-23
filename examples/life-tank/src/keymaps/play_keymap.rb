Gemini::InputManager.define_keymap do |i|
  i.map KEY_RELEASED, :source_value => Input::KEY_F1, :destination_type => :toggle_debug_mode, :destination_value => nil
  i.map KEY_HELD, :source_value => Input::KEY_UP, :destination_type => :move, :destination_value => :up
  i.map KEY_HELD, :source_value => Input::KEY_DOWN, :destination_type => :move, :destination_value => :down
  i.map KEY_HELD, :source_value => Input::KEY_LEFT, :destination_type => :move, :destination_value => :left
  i.map KEY_HELD, :source_value => Input::KEY_RIGHT, :destination_type => :move, :destination_value => :right
  i.map KEY_RELEASED, :source_value => Input::KEY_SPACE, :destination_type => :spawn_thing, :destination_value => nil

  #TODO: Should be LEFT_AXIS and so on.
#  i.map CONTROLLER0_PRESSED, :source_value => LEFT_BUTTON,  :destination_type => :adjust_angle, :destination_value => :left
  i.map CONTROLLER0_HELD, :destination_type => LEFT_BUTTON do |raw_value, message|
    message.value = JoystickEvent.new(nil, Vector.new(raw_value[2], raw_value[3]))
  end
  i.map CONTROLLER0_PRESSED, :source_value => RIGHT_BUTTON, :destination_type => :adjust_angle, :destination_value => :right
  i.map CONTROLLER0_RELEASED, :source_value => UP_BUTTON,  :destination_type => :adjust_power, :destination_value => :up
  i.map CONTROLLER0_RELEASED, :source_value => DOWN_BUTTON, :destination_type => :adjust_power, :destination_value => :down
  i.map CONTROLLER0_PRESSED, :source_value => 1, :destination_type => :fire, :destination_value => :fire
end