map KEY_PRESSED, :source_value => Input::KEY_Q, :destination_type => :p1_paddle_movement, :destination_value => [:start, :up]
map KEY_PRESSED, :source_value => Input::KEY_A, :destination_type => :p1_paddle_movement, :destination_value => [:start, :down]
map KEY_PRESSED, :source_value => Input::KEY_O, :destination_type => :p2_paddle_movement, :destination_value => [:start, :up]
map KEY_PRESSED, :source_value => Input::KEY_L, :destination_type => :p2_paddle_movement, :destination_value => [:start, :down]

map KEY_RELEASED, :source_value => Input::KEY_Q, :destination_type => :p1_paddle_movement, :destination_value => [:stop, :up]
map KEY_RELEASED, :source_value => Input::KEY_A, :destination_type => :p1_paddle_movement, :destination_value => [:stop, :down]
map KEY_RELEASED, :source_value => Input::KEY_O, :destination_type => :p2_paddle_movement, :destination_value => [:stop, :up]
map KEY_RELEASED, :source_value => Input::KEY_L, :destination_type => :p2_paddle_movement, :destination_value => [:stop, :down]

#map MOUSE_BUTTON1_PRESSED, :destination_type => :action, :destination_value => :fire
#map MOUSE_MOVED, :destination_type => :character_movement do |raw_value, message|
#  message.value = [raw_value[2], raw_value[3]]
#end