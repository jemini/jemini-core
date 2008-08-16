include_class 'org.newdawn.slick.BasicGame'
include_class 'org.newdawn.slick.AppGameContainer'

$LOAD_PATH << File.expand_path(File.dirname(__FILE__) + '/managers')

require 'game_object'
require 'message_queue'
require 'input_manager'
require 'base_state'
require 'inflector'
require 'basic_game_object_manager'
require 'basic_update_manager'
require 'basic_render_manager'

module Gemini
  class Main < BasicGame
    def initialize(screen_title, screen_width=640, screen_height=480, fullscreen=false)
      super(screen_title)
      @screen_width, @screen_height = screen_width, screen_height
      app = AppGameContainer.new(self, screen_width, screen_height, fullscreen)
      app.start
    end

    def init(container)
      @container = container
      #MessageQueue.instance.start_processing
      
      BaseState.active_state = load_state(:MainState)
      BaseState.active_state.load
    end
    
    def update(container, delta)
      #don't tell the new state that it now has to update load time worth of a delta
      if @fresh_state
        delta = 0
        @fresh_state = false
      end
      # Workaround for image loading with Slick.
      # Must be done in game init or game loop (instead of immediately in the event).
      if @queued_state
        @queued_state.load
        BaseState.active_state = @queued_state
        @queued_state = nil
        @fresh_state = true
        return
      end
      BaseState.active_state.manager(:input).poll(@screen_width, @screen_height)
      BaseState.active_state.manager(:update).update(delta)
    end

    def render(container, graphics)
      BaseState.active_state.manager(:render).render(graphics)
    end
    
    def load_state(state_name)
      require "states/#{state_name.underscore}" unless Object.const_defined? state_name.camelize
      state_name.camelize.constantize.new @container, self
    end
    
    def queue_state(state)
      @queued_state = state
    end
  end
end