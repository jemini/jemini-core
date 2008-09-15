#map KEY_HELD, :source_value => Input::KEY_LEFT,  :destination_type => :p1_platformer_movement, :destination_value => :left
#map KEY_HELD, :source_value => Input::KEY_RIGHT, :destination_type => :p1_platformer_movement, :destination_value => :right
map KEY_PRESSED, :source_value => Input::KEY_SPACE, :destination_type => :p1_platformer_jump,     :destination_value => :jump

map KEY_PRESSED, :source_value => Input::KEY_LEFT,  :destination_type => :p1_start_platformer_movement, :destination_value => :left
map KEY_PRESSED, :source_value => Input::KEY_RIGHT, :destination_type => :p1_start_platformer_movement, :destination_value => :right
map KEY_RELEASED, :source_value => Input::KEY_LEFT,  :destination_type => :p1_stop_platformer_movement, :destination_value => :left
map KEY_RELEASED, :source_value => Input::KEY_RIGHT, :destination_type => :p1_stop_platformer_movement, :destination_value => :right

map KEY_RELEASED, :source_value => Input::KEY_ESCAPE, :destination_type => :quit, :destination_value => :quit
map KEY_RELEASED, :source_value => Input::KEY_D, :destination_type => :toggle_debug_mode, :destination_value => nil