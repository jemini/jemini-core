class MenuState < Gemini::BaseState
  def load
    set_manager :physics, create(:BasicPhysicsManager)
    set_manager :tag, create(:TagManager)
    
    manager(:render).cache_image :ground, "ground.png"

    load_keymap :GameStartKeymap
    
    create :Background, "evening-sky.png"
    
    ground = create :Ground
    ground.fill_dimensions(0, screen_height / 2, screen_width, screen_height)
    
    create :Text, screen_width / 2, screen_height / 2, "Life-Tank"
    create :Text, screen_width * 0.25, screen_height * 0.25, "Press 1 or A: Start a game with two tanks"

    game_starter = create :GameObject, :RecievesEvents
    game_starter.handle_event :start do
      switch_state :PlayState
    end
#    dot = create :GameObject, :Updates
#    dot.on_update do
#      manager(:render).debug(:point, :blue, :position => Vector.new(screen_width / 2, screen_height / 2))
#    end
  end
end