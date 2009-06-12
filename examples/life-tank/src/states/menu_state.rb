class MenuState < Gemini::BaseState
  
  def load(player_count = 2)
    @player_count = player_count
    set_manager :physics, create(:BasicPhysicsManager)
    set_manager :tag, create(:TagManager)
    set_manager :sound, create(:SoundManager)
    
    manager(:render).cache_image :ground, "ground.png"
    manager(:sound).loop_song "just-aimin.ogg", :volume => 0.5

    manager(:sound).add_sound :fire_cannon, "fire-cannon.wav"
    manager(:sound).add_sound :shell_explosion, "shell-explosion-int.wav"

    load_keymap :GameStartKeymap
    
    create :Background, "evening-sky.png"
    
    ground = create :Ground
    ground.fill_dimensions(0, screen_height / 2, screen_width, screen_height)
    create :Text, screen_width / 2, screen_height * 0.33, "Life-Tank"
    
    @player_count_text = create(:Text,
      screen_width * 0.25,
      screen_height * 0.25, 
      "Press 1 or A: Start a game with #{@player_count} tanks"
    )
    create :Text, screen_width * 0.25, screen_height * 0.30, "Up/Down to change player count"

    menu_handler = create :GameObject, :ReceivesEvents
    menu_handler.handle_event :increase_player_count do
      @player_count += 1 unless @player_count >= 6
      @player_count_text.text = "Press 1 or A: Start a game with #{@player_count} tanks"
    end
    menu_handler.handle_event :decrease_player_count do
      @player_count -= 1 unless @player_count <= 2
      @player_count_text.text = "Press 1 or A: Start a game with #{@player_count} tanks"
    end
    menu_handler.handle_event :quit do
      quit_game
    end
    menu_handler.handle_event :start do
      switch_state :PlayState, @player_count
    end

  end
end