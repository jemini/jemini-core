class MenuState < Gemini::BaseState
  def load
    set_manager :physics, create(:BasicPhysicsManager)
    set_manager :tag, create(:TagManager)
    
    manager(:render).cache_image :ground, "ground.png"

    load_keymap :GameStartKeymap
    
    create :Background, "evening-sky.png"
    
    ground = create :Ground
    ground.fill_dimensions(0, screen_height / 2, screen_width, screen_height)
#    ground.fill_dimensions(screen_width * 0.25, screen_height / 2, screen_width * 0.75, screen_height * 0.75)
#    ground_debug = create :GameObject, :Updates
#    ground_debug.on_update do
#      ground.points.each {|p| manager(:render).debug(:point, :yellow, :position => p)}
#    end
    create :Text, screen_width / 2, screen_height * 0.33, "Life-Tank"
    create :Text, screen_width * 0.25, screen_height * 0.25, "Press 1 or A: Start a game with two tanks"

    menu_handler = create :GameObject, :ReceivesEvents
    menu_handler.handle_event :quit do
      quit_game
    end
    menu_handler.handle_event :start do
      switch_state :PlayState
    end
#    dot = create :GameObject, :Updates
#    dot.on_update do
#      manager(:render).debug(:point, :blue, :position => Vector.new(screen_width / 2, screen_height / 2))
#    end
  end
end