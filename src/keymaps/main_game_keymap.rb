# Requirements
# - allow overriding a default keymapping
# - syntax that a game designer could grok
# - DRY
# - allow logic in the translation, i.e. mouse up may mean "accelerate" or "jump"
#


# This code will be instance_eval'd inside a class that has a method_missing
# designed to define new events


map :source_type => :key, :source_value => Input::KEY_UP, :source_state => :down, :destination_type => :paddle_movement, :destination_value => [:start, :up]
map :source_type => :key, :source_value => Input::KEY_DOWN, :source_state => :down, :destination_type => :paddle_movement, :destination_value => [:start, :down]
map :source_type => :key, :source_value => Input::KEY_RIGHT, :source_state => :down, :destination_type => :paddle_movement, :destination_value => [:start, :right]
map :source_type => :key, :source_value => Input::KEY_LEFT, :source_state => :down, :destination_type => :paddle_movement, :destination_value => [:start, :left]

map :source_type => :key, :source_value => Input::KEY_UP, :source_state => :up, :destination_type => :paddle_movement, :destination_value => [:stop, :up]
map :source_type => :key, :source_value => Input::KEY_DOWN, :source_state => :up, :destination_type => :paddle_movement, :destination_value => [:stop, :down]
map :source_type => :key, :source_value => Input::KEY_RIGHT, :source_state => :up, :destination_type => :paddle_movement, :destination_value => [:stop, :right]
map :source_type => :key, :source_value => Input::KEY_LEFT, :source_state => :up, :destination_type => :paddle_movement, :destination_value => [:stop, :left]