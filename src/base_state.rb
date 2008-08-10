module Gemini
  class BaseState
    @@active_state = nil
    def self.active_state
      @@active_state
    end
    
    def self.active_state=(state)
      @@active_state = state
    end
        
    def initialize
      game_object_manager = BasicGameObjectManager.new(self)
      update_manager = BasicUpdateManager.new(self)
      render_manager = BasicRenderManager.new(self)
      @managers = {:game_object => game_object_manager, :update => update_manager, :render => render_manager}

      @paused = false
    end
    
    def manager(type)
      @managers[type]
    end
    
    def add_game_object(game_object)
      @managers[:game_object].add_game_object game_object
    end
    
    def remove_game_object(game_object)
      @managers[:game_object].remove_game_object(game_object)
    end
    
    def switch_state(state)
      self.class.active_state = state
    end
    
    def load(*args); end
    
  private
    def set_manager(type, manager)
      @managers[type] = manager
    end
  end
end