module Gemini
  class BaseState
    @@active_state = nil
    def self.active_state
      @@active_state
    end
    
    def self.active_state=(state)
      @@active_state = state
    end
        
    def initialize(container, game)
      @container = container
      @game = game
      
      game_object_manager = BasicGameObjectManager.new(self)
      update_manager = BasicUpdateManager.new(self)
      render_manager = BasicRenderManager.new(self)
      input_manager = InputManager.new(self, container)
      message_manager = MessageQueue.new(self)
      
      @managers = {:game_object => game_object_manager,
                   :update => update_manager,
                   :render => render_manager,
                   :input => input_manager,
                   :message_queue => message_manager
                   }
      
      @paused = false
      
      message_manager.start_processing
    end
    
    def create_game_object(type, *params)
      game_object_type = begin
                          type.constantize
                         rescue NameError
                           if 'GameObject' == type.to_s
                             Gemini::GameObject
                           else
                             raise
                           end
                         end
      
      game_object = game_object_type.new(self, *params)
      add_game_object game_object
      game_object
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
    
    def switch_state(state_name)
      state = @game.load_state state_name
      @game.queue_state state
      #self.class.active_state = state
      #state.load
      state
    end
    
    def load_keymap(keymap)
      @managers[:input].load_keymap keymap
    end
    
    def load(*args); end
    
  private
    def set_manager(type, manager)
      @managers[type] = manager
    end
  end
end