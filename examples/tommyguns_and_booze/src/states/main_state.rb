require 'managers/tag_manager'
require 'basic_physics_manager'

class MainState < Gemini::BaseState 
  def load
    set_manager :physics, create_game_object(:BasicPhysicsManager)
    set_manager :tag, create_game_object(:TagManager)
    
    load_keymap :MainGameKeymap
    
    car = create_game_object :Car
    car.set_position(100,100)
    # uncomment to enable profiler (needs keymap too)
#    quitter = create_game_object :GameObject
#    quitter.add_behavior :RecievesEvents
#    quitter.handle_event :quit do
#      Profiler__::print_profile(STDERR) if $profiling
#      Java::java::lang::System.exit 0
#    end
  end
end