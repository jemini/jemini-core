require 'tag_manager'
require 'sound_manager'
require 'basic_physics_manager'

# this is just the menu
class MainState < Jemini::GameState
  def load
    set_manager :physics, create_game_object(:BasicPhysicsManager)
    set_manager :tag, create_game_object(:TagManager)
    set_manager :sound, create_game_object(:SoundManager)
    
    manager(:game_object).add_layer_at :gui_text, 5
    
    # negative layers don't work yet. Just make sure this is the first sprite instead
    background = create_game_object :GameObject, :Sprite
    background.set_image "loading_background.png"
    background.move_by_top_left 0, 0
    
#    start_button = create_game_object :MenuButton, "singularity_button_background.png", "Start", screen_width / 2.0, screen_height / 2.0
#    start_button.on_after_released do
#      puts "start game!"
#      switch_state :PlayState
#    end
    switch_state :MenuState
  end
  
  
end
