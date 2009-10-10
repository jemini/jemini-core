#All other game states should inherit from this class.
module Jemini
  class GameState
    @@active_state = nil
    def self.active_state
      @@active_state
    end
    
    def self.active_state=(state)
      @@active_state = state
    end

    @@inputs = Hash.new {|h,k| h[k] = []}
    def self.use_input(input)
      @@inputs[self] << input
    end

    def self.inputs
      @@inputs[self]
    end

    def initialize(container, game)
      @container = container
      @game = game
      
      @managers = {:game_object => BasicGameObjectManager.new(self),
                   :update => BasicUpdateManager.new(self),
                   :render => BasicRenderManager.new(self),
                   :input => InputManager.new(self, container),
                   :message_queue => MessageQueue.new(self),
                   :resource => ResourceManager.new(self)
                  }

      configure_inputs
      load_resources
      @paused = false
    end

    def screen_size
      @game.screen_size
    end

    # deprecate
    def screen_width
      @game.screen_width
    end

    #deprecate
    def screen_height
      @game.screen_height
    end
    
    #Creates a game object of the given type on the named layer.
    #The given params will be passed to the object's constructor.
    def create_on_layer(type, layer_name, *params)
      game_object_type = if :game_object == type.to_sym || :GameObject == type.to_sym
                           Jemini::GameObject
                         elsif Module.const_defined?(type.camelize.to_sym)
                           type.constantize
                         else
                           try_require("game_objects/#{type.underscore}") or try_require("managers/#{type.underscore}")
                           type.camelize.constantize
                         end
      game_object = game_object_type.new(self, *params)
      add_game_object_to_layer game_object, layer_name
      game_object
    end
    
    def create(type, *params)
      create_on_layer(type, :default, *params)
    end

    def create_game_object(type, *params)
      warn "create_game_object is deprecated, use create instead"
      create(type, *params)
    end
    
    def manager(type)
      @managers[type]
    end
    
    def add_game_object(game_object)
      @managers[:game_object].add_game_object game_object
    end

    def add_game_object_to_layer(game_object, layer_name)
      @managers[:game_object].add_game_object_to_layer game_object, layer_name
    end
    
    def remove(game_object)
      @managers[:game_object].remove_game_object(game_object)
    end

    def remove_game_object(game_object)
      warn "remove_game_object is deprecated, use remove instead"
      remove(game_object)
    end
    
    def switch_state(state_name, *args)
      state = @game.load_state state_name, args
      @game.queue_state state
      #self.class.active_state = state
      #state.load
      state
    end

    def use_input(input)
      @managers[:input].use_input input
    end
    
    def load(*args); end
    
    def quit_game
      java.lang.System.exit 0
    end

    def name
      @name ||= self.class.name.underscore.sub('_state', '')
    end
    
    def load_resources
      @managers[:resource].load_resources
    end

  private

    def configure_inputs
      # global - automatic
      begin
        use_input :global
      rescue LoadError
      end

      # class name - automatic
      begin
        use_input self.class.to_s.underscore.sub('_state', '')
      rescue LoadError
      end
      # class declared
      self.class.inputs.each {|input| use_input input}
    end
    
    def set_manager(type, manager)
      @managers[type] = manager
    end
    
    def try_require(path)
      begin
        require path
      rescue LoadError => e
        return false
      end
      return true
    end
  end
end
