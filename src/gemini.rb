include_class 'org.newdawn.slick.BasicGame'
include_class 'org.newdawn.slick.AppGameContainer'

require 'message_queue'
require 'input_manager'
require 'base_state'
require 'game_object'
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
      MessageQueue.instance.start_processing
      
      BaseState.active_state = load_state(:MainState)
      BaseState.active_state.load
    end
    
    def update(container, delta)
      InputManager.instance.poll(@screen_width, @screen_height)
      BaseState.active_state.manager(:update).update(delta)
    end

    def render(container, graphics)
      BaseState.active_state.manager(:render).render(graphics)
    end
    
  private
    def load_state(state_name)
      require "states/#{state_name.underscore}" unless Object.const_defined? state_name.camelize
      state_name.camelize.constantize.new @container
    end
  end
end