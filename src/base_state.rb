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
      @game_object_manager = BasicGameObjectManager.new(self)
      @update_manager = BasicUpdateManager.new(self)
      @render_manager = BasicRenderManager.new(self)
      @managers = {:game_object => @game_object_manager, :update => @update_manager, :render => @render_manager}
      
      @paused = false
      load
    end
    
    def manager(type)
      @managers[type]
    end
    
    def add_game_object(game_object)
      game_object.state = self
      @game_object_manager.add_game_object game_object
    end
    
    def remove_game_object(game_object)
      @game_object_manager.remove_game_object(game_object)
    end
    
    def switch_state(state)
      self.class.active_state = state
    end
    
    def update(delta)
      @update_manager.update(delta)
    end

    def render(graphics)
      @render_manager.render(graphics)
    end
    
  private
    def set_manager(type, manager)
      @managers[type] = manager
    end
  end
end