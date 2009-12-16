class ConfigManager < Jemini::GameObject
  
  def load
    @configs = {}
  end
  
  #Takes a reference to a config loaded via the resource manager, and returns it.
  def get_config(reference)
    game_state.manager(:resource).get_config(reference)
  end
  
end