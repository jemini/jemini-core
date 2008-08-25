#map KEY_HELD, :source_value => Input::KEY_Q, :destination_type => :p1_paddle_movement, :destination_value => :up
#map KEY_HELD, :source_value => Input::KEY_A, :destination_type => :p1_paddle_movement, :destination_value => :down

map KEY_PRESSED, :source_value => Input::KEY_Q, :destination_type => :p1_paddle_movement, :destination_value => :up
map KEY_PRESSED, :source_value => Input::KEY_A, :destination_type => :p1_paddle_movement, :destination_value => :down
map KEY_RELEASED, :source_value => Input::KEY_Q, :destination_type => :p1_paddle_movement, :destination_value => :stop
map KEY_RELEASED, :source_value => Input::KEY_A, :destination_type => :p1_paddle_movement, :destination_value => :stop
map KEY_PRESSED, :source_value => Input::KEY_O, :destination_type => :p2_paddle_movement, :destination_value => :up
map KEY_PRESSED, :source_value => Input::KEY_L, :destination_type => :p2_paddle_movement, :destination_value => :down
map KEY_RELEASED, :source_value => Input::KEY_O, :destination_type => :p2_paddle_movement, :destination_value => :stop
map KEY_RELEASED, :source_value => Input::KEY_L, :destination_type => :p2_paddle_movement, :destination_value => :stop
map KEY_RELEASED, :source_value => Input::KEY_ESCAPE, :destination_type => :quit, :destination_value => :quit

#map KEY_PRESSED, :source_value => Input::KEY_Q, :destination_type => :p1_paddle_movement, :destination_value => [:start, :up]
#map KEY_PRESSED, :source_value => Input::KEY_A, :destination_type => :p1_paddle_movement, :destination_value => [:start, :down]
#map KEY_PRESSED, :source_value => Input::KEY_O, :destination_type => :p2_paddle_movement, :destination_value => [:start, :up]
#map KEY_PRESSED, :source_value => Input::KEY_L, :destination_type => :p2_paddle_movement, :destination_value => [:start, :down]
#
#map KEY_RELEASED, :source_value => Input::KEY_Q, :destination_type => :p1_paddle_movement, :destination_value => [:stop, :up]
#map KEY_RELEASED, :source_value => Input::KEY_A, :destination_type => :p1_paddle_movement, :destination_value => [:stop, :down]
#map KEY_RELEASED, :source_value => Input::KEY_O, :destination_type => :p2_paddle_movement, :destination_value => [:stop, :up]
#map KEY_RELEASED, :source_value => Input::KEY_L, :destination_type => :p2_paddle_movement, :destination_value => [:stop, :down]
