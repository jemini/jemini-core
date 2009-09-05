Jemini::InputManager.define_keymap do |i|
  #i.map KEY_HELD, :source_value => Input::KEY_LEFT,  :destination_type => :p1_platformer_movement, :destination_value => :left
  #i.map KEY_HELD, :source_value => Input::KEY_RIGHT, :destination_type => :p1_platformer_movement, :destination_value => :right
  i.map KEY_PRESSED, :source_value => Input::KEY_SPACE, :destination_type => :p1_platformer_jump,     :destination_value => :jump
  i.map KEY_PRESSED, :source_value => Input::KEY_F, :destination_type => :shoot,     :destination_value => :shoot

  i.map KEY_PRESSED, :source_value => Input::KEY_LEFT,  :destination_type => :p1_start_platformer_movement, :destination_value => :left
  i.map KEY_PRESSED, :source_value => Input::KEY_RIGHT, :destination_type => :p1_start_platformer_movement, :destination_value => :right
  i.map KEY_RELEASED, :source_value => Input::KEY_LEFT,  :destination_type => :p1_stop_platformer_movement, :destination_value => :left
  i.map KEY_RELEASED, :source_value => Input::KEY_RIGHT, :destination_type => :p1_stop_platformer_movement, :destination_value => :right

  i.map KEY_RELEASED, :source_value => Input::KEY_ESCAPE, :destination_type => :quit, :destination_value => :quit
  i.map KEY_RELEASED, :source_value => Input::KEY_D, :destination_type => :toggle_debug_mode, :destination_value => nil

  i.map CONTROLLER0_PRESSED, :source_value => LEFT_BUTTON,  :destination_type => :p1_start_platformer_movement, :destination_value => :left
  i.map CONTROLLER0_PRESSED, :source_value => RIGHT_BUTTON, :destination_type => :p1_start_platformer_movement, :destination_value => :right
  i.map CONTROLLER0_RELEASED, :source_value => LEFT_BUTTON,  :destination_type => :p1_stop_platformer_movement, :destination_value => :left
  i.map CONTROLLER0_RELEASED, :source_value => RIGHT_BUTTON, :destination_type => :p1_stop_platformer_movement, :destination_value => :right
  i.map CONTROLLER0_PRESSED, :source_value => 1, :destination_type => :p1_platformer_jump, :destination_value => :jump
end