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
      @game_objects = []
      @paused = false
      load
    end
    
    def pause
      @paused = true
    end
    
    def resume
      @paused = false
    end
    
    def paused?
      @paused
    end
    
    def add_game_object(game_object)
      @game_objects << game_object
    end
    
    def switch_state(state)
      self.class.active_state = state
    end
    
    def update(delta)
      @game_objects.each { |game_object| game_object.update(delta) if game_object.respond_to? :update } unless @paused
    end

    def render(graphics)
      @game_objects.each { |game_object| game_object.draw if game_object.respond_to? :draw }
    end
  end
end