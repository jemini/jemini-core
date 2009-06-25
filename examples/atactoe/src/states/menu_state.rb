class MenuState < Gemini::BaseState
  
  def load(target_score = 10)
    @target_score = target_score
    set_manager :sound, create(:SoundManager)
    manager(:sound).loop_song "j-hop.ogg", :volume => 0.6
    manager(:sound).add_sound :no, "no.wav"
    
    manager(:render).cache_image :grid, "grid.png"

    load_keymap :GameStartKeymap
    
    create :Background, "grid.png"
    
    create :Text, screen_width / 2, screen_height * 0.33, "AtacToe"
    
    @target_score_text = create(:Text,
      screen_width * 0.25,
      screen_height * 0.25, 
      target_score_string
    )
    create :Text, screen_width * 0.25, screen_height * 0.30, "Up/Down to change target score"

    menu_handler = create :GameObject, :ReceivesEvents
    menu_handler.handle_event :change_target_score do |message|
      @target_score += message.value
      if @target_score < 1
        @target_score = 1
        manager(:sound).play_sound :no
      end
      @target_score_text.text = target_score_string
    end
    menu_handler.handle_event :quit do
      quit_game
    end
    menu_handler.handle_event :start do
      switch_state :PlayState, @target_score, 0, 0
    end

  end
  
  def target_score_string
    "Press A: Start a #{@target_score}-point match"
  end
  
end