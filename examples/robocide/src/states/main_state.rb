class MainState < Jemini::BaseState
  def load
#    set_manager :physics, create_game_object(:BasicPhysicsManager)
#    set_manager :tag, create_game_object(:TagManager)
#    set_manager :sound, create_game_object(:SoundManager)

    manager(:game_object).add_layer_at :gui_text, 5

    # negative layers don't work yet. Just make sure this is the first sprite instead
#    background = create_game_object :GameObject, :Sprite
#    background.set_image :loading_background
#    background.move_by_top_left 0, 0
    switch_state :PlayState
  end
end