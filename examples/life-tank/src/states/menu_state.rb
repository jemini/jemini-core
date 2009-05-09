class MenuState < Gemini::BaseState
  def load
    set_manager :physics, create(:BasicPhysicsManager)
    set_manager :tag, create(:TagManager)
    
    manager(:render).cache_image :ground, "ground.png"

    create_game_object :Background, "evening-sky.png"
    
    ground = create :Ground
    ground.fill_dimensions(0, screen_height / 2, screen_width, screen_height)
    
    create :Text, screen_width / 2, screen_height / 2, "Life-Tank"
#    dot = create :GameObject, :Updates
#    dot.on_update do
#      manager(:render).debug(:point, :blue, :position => Vector.new(screen_width / 2, screen_height / 2))
#    end
  end
end