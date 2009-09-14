class MenuState < Gemini::GameState
  
  def load(player_count = 2)
    @player_count = player_count
    set_manager :physics, create(:BasicPhysicsManager)
    set_manager :tag, create(:TagManager)
    set_manager :sound, create(:SoundManager)
    
    manager(:render).cache_image :ground, "ground.png"
    manager(:sound).loop_song "just-aimin.ogg", :volume => 0.5

    manager(:sound).add_sound :fire_cannon, "fire-cannon.wav"
    manager(:sound).add_sound :explosion, "shell-explosion-int.wav"
    
    create :Background, "evening-sky.png"
    
    ground = create :Ground
    ground.fill_dimensions(0, screen_height / 2, screen_width, screen_height)
    create :Text, "Life-Tank", :position => Vector.new(screen_width / 2, screen_height * 0.20)
    
    @player_count_text = create(:Text, "Press 1 or A: Start a game with #{@player_count} tanks", :position => Vector.new(screen_width * 0.15, screen_height * 0.25), :justify => :top_left)
    display_instructions
    

    menu_handler = create :GameObject, :HandlesEvents
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

  def display_instructions
    create :Text, "Press up/down or left/right bumpers to change player count", :position => Vector.new(screen_width * 0.15, screen_height * 0.30), :justify => :top_left
    create :Text, "Tank Controls for player 1, 2, and XBox 360 controllers:", :position => Vector.new(screen_width * 0.15, screen_height * 0.35), :justify => :top_left
    create :Text, "Space, Left Shift, or A: Fire", :position => Vector.new(screen_width * 0.20, screen_height * 0.40), :justify => :top_left
    create :Text, "Left/Right, A/D, or Left Stick Left/Right: Aim turret", :position => Vector.new(screen_width * 0.20, screen_height * 0.45), :justify => :top_left
    create :Text, "Up/Down, W/S, or Left Stick Up/Down: Adjust shot power", :position => Vector.new(screen_width * 0.20, screen_height * 0.50), :justify => :top_left
    create :Text, "</>, Q/E, or Left/Right Trigger: Move the tank", :position => Vector.new(screen_width * 0.20, screen_height * 0.55), :justify => :top_left
    create :Text, "Hold F, ?, or B: Charge jump", :position => Vector.new(screen_width * 0.20, screen_height * 0.60), :justify => :top_left
    create :Text, "Release F, ?, or B: Jump!", :position => Vector.new(screen_width * 0.20, screen_height * 0.65), :justify => :top_left
  end
end